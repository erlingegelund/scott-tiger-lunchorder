CREATE OR REPLACE PACKAGE stlunch_api AS
  PROCEDURE fetch_supplier_categories(
    p_user_id stlunch_users.user_id%type
  );
  PROCEDURE fetch_supplier_cat_menus(
    p_supplier_id stlunch_suppliers.supplier_id%type
  , p_category_id stlunch_categories.category_id%type
  );
END;
/

CREATE OR REPLACE PACKAGE BODY stlunch_api AS
  PROCEDURE fetch_supplier_categories(
    p_user_id stlunch_users.user_id%type
  ) IS
    l_cursor SYS_REFCURSOR;
    l_last_supplier_id stlunch_suppliers.supplier_id%type := 0;
    l_last_category_id stlunch_categories.category_id%type := 0;
  BEGIN
    -- Find senest bestilt leverandør og kategori
    FOR rec IN (
        SELECT 
          ord.order_date
          , max(supp.supplier_id) AS last_supplier_id
          , max(cat.category_id) AS last_category_id
        FROM stlunch_orders ord, stlunch_suppliers supp, stlunch_supplier_menus menu, stlunch_categories cat
        WHERE ord.supplier_email = supp.supplier_email
        AND ord.menu_name = menu.menu_name
        AND ord.menu_category = cat.category_name
        AND supp.supplier_id = menu.supplier_id
        AND menu.category_id = cat.category_id
        AND user_id = p_user
        GROUP BY ord.order_date
        ORDER BY ord.order_date desc
    ) LOOP
      l_last_supplier_id := rec.last_supplier_id;
      l_last_category_id := rec.last_category_id;
      EXIT;
    END LOOP;

    OPEN l_cursor FOR
      SELECT supplier_id AS "id"
           , supplier_name AS "name"
           , supplier_email AS "email"
           , CASE WHEN supplier_id = l_last_supplier_id THEN 'Y' ELSE 'N' END AS "display"
           , 0 AS "items_ordered"
           , CURSOR(
               SELECT DISTINCT 
                      mcat.category_id AS "id"
                    , mcat.category_name AS "category"
                    , CASE WHEN supcm.supplier_id = l_last_supplier_id AND mcat.category_id = l_last_category_id THEN 'Y' ELSE 'N' END AS "display"
                    , supcm.supplier_id||':'||mcat.category_id AS "vkey"
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
  
  PROCEDURE fetch_supplier_cat_menus(
    p_supplier_id stlunch_suppliers.supplier_id%type
  , p_category_id stlunch_categories.category_id%type
  ) IS
    l_cursor SYS_REFCURSOR;
  BEGIN
    OPEN l_cursor FOR
      SELECT supplier_menu_id AS "id"
           , menu_name AS "name"
           , description AS "description"
           , price AS "price"
           , 0 AS "items_ordered"
           , CURSOR(
               SELECT mopt.menu_option_id AS "id"
                    , mopt.description AS "description"
                    , mopt.mandatory_yn AS "mandatory_yn"
                    , mopt.multiple_yn AS "multiple_yn"
                    , mopt.additional_price AS "additional_price"
                    , mopt.selectables AS "selectables"
               FROM stlunch_menu_options mopt
               WHERE mopt.supplier_menu_id = supm.supplier_menu_id
               ORDER BY mopt.description) AS "options"
      FROM stlunch_supplier_menus supm
      WHERE supm.supplier_id = p_supplier_id
      AND supm.category_id = p_category_id
      ORDER BY menu_name;

    APEX_JSON.open_object;
    APEX_JSON.write('items', l_cursor);
    APEX_JSON.close_object;
  END fetch_supplier_cat_menus;
  
END stlunch_api;
/

BEGIN
  ORDS.define_module(
    p_module_name    => 'prep_order_supp_cat',
    p_base_path      => 'suppliers_categories/',
    p_items_per_page => 0);
  
  ORDS.define_template(
   p_module_name    => 'prep_order_supp_cat',
   p_pattern        => 'prep_order/:user_id');

  ORDS.define_handler(
    p_module_name    => 'prep_order_supp_cat',
    p_pattern        => 'prep_order/:user_id',
    p_method         => 'GET',
    p_source_type    => ORDS.source_type_plsql,
    p_source         => 'BEGIN stlunch_api.fetch_supplier_categories(:user_id); END;',
    p_items_per_page => 0);
 
  ORDS.define_module(
    p_module_name    => 'prep_order_menu',
    p_base_path      => 'menus_options/',
    p_items_per_page => 0);
  
  ORDS.define_template(
   p_module_name    => 'prep_order_menu',
   p_pattern        => 'prep_order/:supplier_id/:category_id');

  ORDS.define_handler(
    p_module_name    => 'prep_order_menu',
    p_pattern        => 'prep_order/:supplier_id/:category_id',
    p_method         => 'GET',
    p_source_type    => ORDS.source_type_plsql,
    p_source         => 'BEGIN stlunch_api.fetch_supplier_cat_menus(:supplier_id, :category_id); END;',
    p_items_per_page => 0);

  COMMIT;
END;
/


