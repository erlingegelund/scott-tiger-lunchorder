-- Installer APEX 18.2
--   ADMIN e-mail: efe@scott-tiger.dk
--   Admin passwd: BremboM4;mono
--
-- alter profile default limit password_life_time unlimited;
-- alter user apex_public_user identified by BremboM4mono;
--
-- Installer ords-18.4.0 
-- https://docs.oracle.com/database/ords-18.1/AELIG/installing-REST-data-services.htm
--
-- Guide til installation
-- https://mikesmithers.wordpress.com/2019/03/01/installing-apex-and-ords-on-oracle-18cxe-on-centos/

DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    ORDS.DROP_REST_FOR_SCHEMA('ST_LUNCH');
    COMMIT;

    ORDS.ENABLE_SCHEMA(p_enabled => TRUE,
                       p_schema => 'ST_LUNCH',
                       p_url_mapping_type => 'BASE_PATH',
                       p_url_mapping_pattern => 'stlunch',
                       p_auto_rest_auth => FALSE);

    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'ST_LUNCH',
                       p_object => 'STLUNCH_CATEGORIES',
                       p_object_type => 'TABLE',
                       p_object_alias => 'categories',
                       p_auto_rest_auth => TRUE);

    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'ST_LUNCH',
                       p_object => 'STLUNCH_USERS',
                       p_object_type => 'TABLE',
                       p_object_alias => 'users',
                       p_auto_rest_auth => TRUE);

    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'ST_LUNCH',
                       p_object => 'STLUNCH_SUPPLIERS',
                       p_object_type => 'TABLE',
                       p_object_alias => 'suppliers',
                       p_auto_rest_auth => TRUE);

    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'ST_LUNCH',
                       p_object => 'STLUNCH_ACTIVE_USERS',
                       p_object_type => 'VIEW',
                       p_object_alias => 'active_users',
                       p_auto_rest_auth => TRUE);

    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'ST_LUNCH',
                       p_object => 'STLUNCH_SUPPLIER_MENUS',
                       p_object_type => 'TABLE',
                       p_object_alias => 'supplier_menus',
                       p_auto_rest_auth => TRUE);

    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'ST_LUNCH',
                       p_object => 'STLUNCH_MENU_OPTIONS',
                       p_object_type => 'TABLE',
                       p_object_alias => 'menu_options',
                       p_auto_rest_auth => TRUE);

    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'ST_LUNCH',
                       p_object => 'STLUNCH_ORDERS',
                       p_object_type => 'TABLE',
                       p_object_alias => 'orders',
                       p_auto_rest_auth => TRUE);

    ORDS.define_service(p_module_name    => 'service-supplier-menus',
                        p_base_path      => 'service-supplier/',
                        p_pattern        => 'menus/:supp_id',
                        p_method         => 'GET',
                        p_source_type    => ORDS.source_type_collection_feed,
                        p_source         => 
'SELECT sm.supplier_menu_id AS "supplier_menu_id"
, sm.supplier_id AS "supplier_id"
, sm.category_id AS "category_id"
, sm.menu_name AS "menu_name"
, sm.description AS "description"
, sm.price AS "price"
, cat.category_name AS "category_name"
FROM stlunch_supplier_menus sm
, stlunch_categories cat
WHERE sm.category_id = cat.category_id
AND sm.supplier_id = :supp_id 
ORDER BY cat.category_name, sm.menu_name, sm.price',
                        p_items_per_page => 0);

    ORDS.define_service(p_module_name    => 'service-menu-options',
                        p_base_path      => 'service-menu/',
                        p_pattern        => 'options/:menu_id',
                        p_method         => 'GET',
                        p_source_type    => ORDS.source_type_collection_feed,
                        p_source         => 'SELECT * FROM stlunch_menu_options WHERE supplier_menu_id = :menu_id ORDER BY sort_order, description',
                        p_items_per_page => 0);
                        
    ORDS.define_service(p_module_name    => 'service-orders',
                        p_base_path      => 'service-orders/',
                        p_pattern        => 'period/:p_d1/:p_d2',
                        p_method         => 'GET',
                        p_source_type    => ORDS.source_type_collection_feed,
                        p_source         =>
'SELECT u.user_id AS "user_id"
, u.user_name AS "user_name"
, COUNT(DISTINCT o.order_date) AS "number_days"
, SUM(o.items_ordered * o.price) AS "price_total"
FROM stlunch_users u, stlunch_orders o
WHERE u.user_id = o.user_id
AND o.order_date BETWEEN to_date(:p_d1,''YYYY-MM-DD'') AND to_date(:p_d2,''YYYY-MM-DD'')
GROUP BY u.user_id, u.user_name
ORDER BY u.user_name',
                        p_items_per_page => 0);
    COMMIT;

  ORDS.define_module(
    p_module_name    => 'api',
    p_base_path      => 'api/',
    p_items_per_page => 0);
  
  ORDS.define_template(
   p_module_name    => 'api',
   p_pattern        => 'prep-order/:user_id');

  ORDS.define_handler(
    p_module_name    => 'api',
    p_pattern        => 'prep-order/:user_id',
    p_method         => 'GET',
    p_source_type    => ORDS.source_type_plsql,
    p_source         => 'BEGIN stlunch_api.fetch_supplier_categories(:user_id); END;',
    p_items_per_page => 0);
 
  ORDS.define_template(
   p_module_name    => 'api',
   p_pattern        => 'prep-order/:supplier_id/:category_id');

  ORDS.define_handler(
    p_module_name    => 'api',
    p_pattern        => 'prep-order/:supplier_id/:category_id',
    p_method         => 'GET',
    p_source_type    => ORDS.source_type_plsql,
    p_source         => 'BEGIN stlunch_api.fetch_supplier_cat_menus(:supplier_id, :category_id); END;',
    p_items_per_page => 0);

  ORDS.define_template(
   p_module_name    => 'api',
   p_pattern        => 'create-order/');

  ORDS.define_handler(
    p_module_name    => 'api',
    p_pattern        => 'create-order/',
    p_method         => 'POST',
    p_source_type    => ORDS.source_type_plsql,
    p_source         => 'BEGIN stlunch_api.create_order(p_body => :body); END;',
    p_items_per_page => 0);

  ORDS.define_template(
   p_module_name    => 'api',
   p_pattern        => 'get-user-orders/:user_id/:order_date');

  ORDS.define_handler(
    p_module_name    => 'api',
    p_pattern        => 'get-user-orders/:user_id/:order_date',
    p_method         => 'GET',
    p_source_type    => ORDS.source_type_plsql,
    p_source         => 'BEGIN stlunch_api.fetch_orders(p_user_id => :user_id, p_order_date => :order_date); END;',
    p_items_per_page => 0);

  ORDS.define_template(
   p_module_name    => 'api',
   p_pattern        => 'get-orders/:order_date');

  ORDS.define_handler(
    p_module_name    => 'api',
    p_pattern        => 'get-orders/:order_date',
    p_method         => 'GET',
    p_source_type    => ORDS.source_type_plsql,
    p_source         => 'BEGIN stlunch_api.fetch_orders(p_user_id => null, p_order_date => :order_date); END;',
    p_items_per_page => 0);

  ORDS.define_module(
    p_module_name    => 'login',
    p_base_path      => 'login/',
    p_items_per_page => 0);
  
  ORDS.define_template(
   p_module_name    => 'login',
   p_pattern        => 'user/');

  ORDS.define_handler(
    p_module_name    => 'login',
    p_pattern        => 'user/',
    p_method         => 'POST',
    p_source_type    => ORDS.source_type_plsql,
    p_source         => 'BEGIN stlunch_api.login(p_body_text => :body_text); END;',
    p_items_per_page => 0);

  ORDS.define_template(
   p_module_name    => 'login',
   p_pattern        => 'reset/');

  ORDS.define_handler(
    p_module_name    => 'login',
    p_pattern        => 'reset/',
    p_method         => 'POST',
    p_source_type    => ORDS.source_type_plsql,
    p_source         => 'BEGIN stlunch_api.email_new_password(p_body_text => :body_text); END;',
    p_items_per_page => 0);

  ORDS.define_template(
   p_module_name    => 'api',
   p_pattern        => 'change-password/');

  ORDS.define_handler(
    p_module_name    => 'api',
    p_pattern        => 'change-password/',
    p_method         => 'POST',
    p_source_type    => ORDS.source_type_plsql,
    p_source         => 'BEGIN stlunch_api.change_password(p_body_text => :body_text); END;',
    p_items_per_page => 0);

  COMMIT;
END;
/
