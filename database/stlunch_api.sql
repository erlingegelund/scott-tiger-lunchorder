CREATE OR REPLACE PACKAGE stlunch_api AS
  PROCEDURE fetch_supplier_categories(user_id stlunch_users.user_id%type);
END;
/

CREATE OR REPLACE PACKAGE BODY stlunch_api AS
  PROCEDURE fetch_supplier_categories(user_id stlunch_users.user_id%type) IS
    l_cursor SYS_REFCURSOR;
  BEGIN  
    OPEN l_cursor FOR
      SELECT supplier_id AS "id"
           , supplier_name AS "name"
           , supplier_email AS "email"
           , 'N' AS "display"
           , CURSOR(
               SELECT DISTINCT 
                      mcat.category_id AS "id"
                    , mcat.category_name AS "name"
                    , 'N' AS "display"
               FROM stlunch_supplier_menus supcm, stlunch_categories mcat
               WHERE supcm.supplier_id = supp.supplier_id
               AND mcat.category_id = supcm.category_id
               ORDER BY mcat.category_name) AS "menu"
      FROM stlunch_suppliers supp
      ORDER BY supplier_name;

    APEX_JSON.open_object;
    APEX_JSON.write('suppliers', l_cursor);
    APEX_JSON.close_object;
  END fetch_supplier_categories;
END stlunch_api;
/

BEGIN
  ORDS.define_module(
    p_module_name    => 'order_supp_cat',
    p_base_path      => 'order/',
    p_items_per_page => 0);
  
  ORDS.define_template(
   p_module_name    => 'order_supp_cat',
   p_pattern        => 'supp_cat/:user_id');

  ORDS.define_handler(
    p_module_name    => 'order_supp_cat',
    p_pattern        => 'supp_cat/:user_id',
    p_method         => 'GET',
    p_source_type    => ORDS.source_type_plsql,
    p_source         => 'BEGIN stlunch_api.fetch_supplier_categories(:user_id); END;',
    p_items_per_page => 0);
    
  COMMIT;
END;
/