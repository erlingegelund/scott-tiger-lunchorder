CREATE OR REPLACE PACKAGE stlunch_api AS
  PROCEDURE fetch_supplier_categories(
    p_user_id          IN stlunch_users.user_id%type
  );
  PROCEDURE fetch_supplier_cat_menus(
    p_supplier_id      IN stlunch_suppliers.supplier_id%type
  , p_category_id      IN stlunch_categories.category_id%type
  );
  PROCEDURE fetch_orders (
    p_user_id          IN stlunch_orders.user_id%TYPE
  , p_order_date       IN VARCHAR2
  );
  PROCEDURE create_order (
    p_body             IN BLOB
  );
  
  PROCEDURE login (
    p_body_text        IN CLOB
  );
  
  PROCEDURE encrypt_password (
    p_email            IN stlunch_users.user_email%TYPE
  , p_passwd_enc   IN OUT stlunch_users.passwd_enc%TYPE
  , p_passwd_salt     OUT stlunch_users.passwd_salt%TYPE
  );
  
  PROCEDURE email_new_password (
    p_body_text        IN CLOB
  );

  PROCEDURE change_password(
    p_body_text        IN CLOB
  );
END;
/

CREATE OR REPLACE PACKAGE BODY stlunch_api AS
  PROCEDURE fetch_supplier_categories(
    p_user_id          IN stlunch_users.user_id%type
  ) IS
    l_cursor              SYS_REFCURSOR;
    l_last_supplier_id    stlunch_suppliers.supplier_id%type := 0;
    l_last_category_id    stlunch_categories.category_id%type := 0;
  BEGIN
    -- Find leverandør og kategori for brugers seneste ordre
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
        AND user_id = p_user_id
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
                    , supcm.supplier_id AS "supplier_id"
               FROM stlunch_supplier_menus supcm, stlunch_categories mcat
               WHERE supcm.supplier_id = supp.supplier_id
               AND mcat.category_id = supcm.category_id
               ORDER BY mcat.category_name) AS "categories"
      FROM stlunch_suppliers supp
      ORDER BY supplier_name;

    APEX_JSON.open_object;
    APEX_JSON.write('suppliers', l_cursor);
    APEX_JSON.close_object;
  END fetch_supplier_categories;
  
  PROCEDURE fetch_supplier_cat_menus(
    p_supplier_id      IN stlunch_suppliers.supplier_id%type
  , p_category_id      IN stlunch_categories.category_id%type
  ) IS
    l_cursor              SYS_REFCURSOR;
  BEGIN
    OPEN l_cursor FOR
      SELECT supplier_menu_id AS "id"
           , menu_name AS "name"
           , description AS "description"
           , price AS "price"
           , 0 AS "items_ordered"
           , '' AS "comment"
           , CURSOR(
               SELECT mopt.menu_option_id AS "id"
                    , mopt.description AS "description"
                    , mopt.mandatory_yn AS "mandatory_yn"
                    , mopt.multiple_yn AS "multiple_yn"
                    , mopt.additional_price AS "additional_price"
                    , replace(mopt.selectables, chr(13), '') AS "selectables"
               FROM stlunch_menu_options mopt
               WHERE mopt.supplier_menu_id = supm.supplier_menu_id
               ORDER BY mopt.sort_order, mopt.description) AS "options"
      FROM stlunch_supplier_menus supm
      WHERE supm.supplier_id = p_supplier_id
      AND supm.category_id = p_category_id
      ORDER BY menu_name, price;

    APEX_JSON.open_object;
    APEX_JSON.write('menu_items', l_cursor);
    APEX_JSON.close_object;
  END fetch_supplier_cat_menus;
  
  FUNCTION fetch_orders_cursor (
    p_user_id             stlunch_orders.user_id%TYPE
  , p_order_date          stlunch_orders.order_date%TYPE
  ) RETURN SYS_REFCURSOR
  IS
    l_cursor              SYS_REFCURSOR;
  BEGIN
    OPEN l_cursor FOR
      SELECT order_id AS "order_id"
      , ord.user_id AS "user_id"
      , to_char(
          SYS_EXTRACT_UTC(cast (ord.order_date as timestamp with time zone))
       , 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z') AS "order_date" -- Format ISO 8601 - Jumping through hoops to get UTC time 
      , ord.supplier_email AS "supplier_email"
      , ord.supplier_name AS "supplier_name"
      , ord.menu_category AS "menu_category"
      , ord.menu_name AS "menu_name"
      , ord.items_ordered AS "items_ordered"
      , ord.price AS "price"
      , ord.user_comment AS "user_comment"
      , CURSOR(
          SELECT opt.description AS "description"
          , opt.selected AS "selected"
          FROM stlunch_order_options opt
          WHERE opt.order_id = ord.order_id
          ORDER BY opt.sort_order, opt.description
        ) AS "options"
      , stlunch_users.user_name AS "user_name"
      FROM stlunch_orders ord
      , stlunch_users
      WHERE stlunch_users.user_id = ord.user_id
      AND ord.user_id = nvl(p_user_id, ord.user_id)
      AND trunc(order_date) = trunc(p_order_date)
      ORDER BY stlunch_users.user_name, supplier_name, menu_category, menu_name;
    RETURN l_cursor;
  END;
  
  PROCEDURE fetch_orders (
    p_user_id          IN stlunch_orders.user_id%TYPE
  , p_order_date       IN VARCHAR2
  ) IS
    l_order_date          DATE;
    l_cursor              SYS_REFCURSOR;
  BEGIN
    if p_order_date is null then
      l_order_date := trunc(sysdate);
    else 
      l_order_date := to_date(p_order_date, 'YYYY-MM-DD');
    end if;
    l_cursor := fetch_orders_cursor(p_user_id, l_order_date);
    
    APEX_JSON.open_object;
    APEX_JSON.write('orders', l_cursor);
    APEX_JSON.close_object;
  EXCEPTION
    WHEN OTHERS THEN
      HTP.print(SQLERRM);
  END fetch_orders; 
  
  PROCEDURE fetch_orders (
    p_user_id          IN stlunch_orders.user_id%TYPE
  , p_order_date       IN stlunch_orders.order_date%TYPE
  ) IS
    l_cursor              SYS_REFCURSOR;
  BEGIN
    l_cursor := fetch_orders_cursor(p_user_id, p_order_date);
    
    APEX_JSON.open_object;
    APEX_JSON.write('orders', l_cursor);
    APEX_JSON.close_object;
  EXCEPTION
    WHEN OTHERS THEN
      HTP.print(SQLERRM);
  END fetch_orders; 
  
  PROCEDURE create_order(
    p_body             IN BLOB
  ) IS
    TYPE t_order_tab   IS TABLE OF stlunch_orders%ROWTYPE;
    TYPE t_option_tab  IS TABLE OF stLunch_order_options%ROWTYPE;
    
    l_order_obj        JSON_OBJECT_T;
    l_items_arr        JSON_ARRAY_T;
    l_item_obj         JSON_OBJECT_T;
    l_options_arr      JSON_ARRAY_T;
    l_option_obj       JSON_OBJECT_T;
    l_selected_arr     JSON_ARRAY_T;
    
    l_order_tab        t_order_tab := t_order_tab();
    l_option_tab       t_option_tab := t_option_tab();
    
    l_order_date       DATE := trunc(sysdate);
    l_user_id          stlunch_users.user_id%TYPE;
    
    l_menu_id          stlunch_supplier_menus.supplier_menu_id%TYPE;
    l_items_ordered    NUMBER;
    l_comment          stlunch_orders.user_comment%TYPE;
    l_price            stlunch_supplier_menus.price%TYPE;
    
    l_option_id        stlunch_menu_options.menu_option_id%TYPE;
    l_selected         stlunch_order_options.selected%TYPE;
    
    l_body             BLOB := p_body;
  BEGIN 
    -- Hvis bestillingen er efter kl 12:00 er det til næste hverdag
    IF to_number(to_char(sysdate, 'HH24MM')) > 1200 THEN
      IF to_char(l_order_date, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') = 'FRI' THEN
        l_order_date := l_order_date+3;
      ELSIF to_char(l_order_date, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') = 'SAT' THEN
        l_order_date := l_order_date+1;
      ELSE
        l_order_date := trunc(sysdate+1);
      END IF;
      -- TODO: Håndter helligdage
    END IF;

    l_order_obj := JSON_OBJECT_T(l_body);
    l_user_id := l_order_obj.get_number('user_id');
    
    l_items_arr := l_order_obj.get_array('items');
    FOR i IN 0..l_items_arr.get_size -1 LOOP
      l_item_obj := TREAT(l_items_arr.get(i) AS JSON_OBJECT_T);
      l_menu_id := l_item_obj.get_number('menu_id');
      l_items_ordered := l_item_obj.get_number('items_ordered');
      l_comment := l_item_obj.get_string('comment');
      
      l_order_tab.extend;
      l_order_tab(l_order_tab.LAST).order_id := stlunch_seq.nextval;
      l_order_tab(l_order_tab.count).user_id := l_user_id;
      l_order_tab(l_order_tab.count).order_date := l_order_date;
      l_order_tab(l_order_tab.count).items_ordered := l_items_ordered;
      l_order_tab(l_order_tab.count).user_comment := l_comment;
      FOR m IN (
           SELECT supp.supplier_email, supp.supplier_name, cat.category_name, supm.menu_name, supm.price
           FROM stlunch_suppliers supp, stlunch_categories cat, stlunch_supplier_menus supm
           WHERE supp.supplier_id = supm.supplier_id
           AND supm.category_id = cat.category_id
           AND supm.supplier_menu_id = l_menu_id
      ) LOOP
        l_order_tab(l_order_tab.LAST).supplier_email := m.supplier_email;
        l_order_tab(l_order_tab.LAST).supplier_name := m.supplier_name;
        l_order_tab(l_order_tab.LAST).menu_category := m.category_name;
        l_order_tab(l_order_tab.LAST).menu_name := m.menu_name;
        l_price := m.price;
      END LOOP;
      
      -- Håndter valg
      l_options_arr := l_item_obj.get_array('options');
      FOR j IN 0..l_options_arr.get_size - 1 LOOP
        l_option_obj := TREAT(l_options_arr.get(j) AS JSON_OBJECT_T);
        l_option_id := l_option_obj.get_number('option_id');
        
        l_selected_arr := l_option_obj.get_array('selected');
        l_selected := '';
        FOR k IN 0..l_selected_arr.get_size - 1 LOOP
          IF length(l_selected) > 0 THEN
            l_selected := l_selected||CHR(10);
          END IF;
          l_selected := l_selected||l_selected_arr.get(k).to_string;
        END LOOP;
        IF l_selected IS NOT NULL THEN
          l_option_tab.extend;
          l_option_tab(l_option_tab.last).order_option_id := stlunch_seq.nextval;
          l_option_tab(l_option_tab.last).order_id := l_order_tab(l_order_tab.LAST).order_id;
          l_option_tab(l_option_tab.last).selected := REPLACE(l_selected,'"','');
          FOR rec IN (
              SELECT description, additional_price, sort_order FROM stlunch_menu_options WHERE menu_option_id = l_option_id
          ) LOOP
            l_option_tab(l_option_tab.last).description := rec.description;
            l_option_tab(l_option_tab.last).sort_order := rec.sort_order;
            l_price := l_price + nvl(rec.additional_price,0);
          END LOOP;
        END IF;
      END LOOP;
      
      l_order_tab(l_order_tab.LAST).price := l_price;
    END LOOP;
    
    FORALL i IN l_order_tab.FIRST..l_order_tab.LAST
      INSERT INTO stlunch_orders VALUES l_order_tab(i);
    FORALL i IN l_option_tab.FIRST..l_option_tab.LAST
      INSERT INTO stlunch_order_options VALUES l_option_tab(i);
      
    fetch_orders(l_user_id, l_order_date);
  EXCEPTION
    WHEN OTHERS THEN
      HTP.print(SQLERRM);
  END create_order;
  
  PROCEDURE get_encrypted_password(
    p_user_rec IN OUT NOCOPY stlunch_users%ROWTYPE
  , p_password            stlunch_users.passwd_enc%TYPE
  ) IS 
    l_enc_buf             RAW(4000);
    l_hash_buf            RAW(4000);
    l_base64_buf          RAW(4000);
  BEGIN
    IF p_user_rec.passwd_salt IS NOT NULL THEN
      l_enc_buf := UTL_RAW.CAST_TO_RAW(p_user_rec.user_email||p_user_rec.passwd_salt||p_password);
      l_hash_buf := DBMS_CRYPTO.HASH(
        l_enc_buf
      , DBMS_CRYPTO.HASH_SH256);
      l_base64_buf := UTL_ENCODE.BASE64_ENCODE(l_hash_buf);
      p_user_rec.passwd_enc := UTL_RAW.CAST_TO_VARCHAR2(l_base64_buf);
    END IF;
  END get_encrypted_password;
  
  PROCEDURE login (
    p_body_text        IN CLOB
  ) IS
    l_body_text           CLOB := p_body_text;
    l_user_obj            JSON_OBJECT_T;   
    
    l_user_email          stlunch_users.user_email%TYPE;
    l_password            stlunch_users.passwd_enc%TYPE;
    l_user_rec            stlunch_users%ROWTYPE;
    
    l_user_cursor         SYS_REFCURSOR;
    l_oauth_cursor        SYS_REFCURSOR;
  BEGIN
    l_user_obj := JSON_OBJECT_T(l_body_text);
    l_user_email := l_user_obj.get_string('user_email');
    l_password := l_user_obj.get_string('password');
    
    SELECT *
    INTO l_user_rec
    FROM stlunch_active_users
    WHERE user_email = l_user_email;
    
    get_encrypted_password(l_user_rec, l_password);
    
    OPEN l_user_cursor FOR 
    SELECT user_id AS "user_id", user_name AS "user_name", user_email AS "user_email", administrator_yn AS "administrator_yn"
    FROM stlunch_active_users 
    WHERE user_email = l_user_email
    AND passwd_enc = l_user_rec.passwd_enc;
    
    -- Hent client ID og secret fra OAuth dictionary
    OPEN l_oauth_cursor FOR
    SELECT client_id AS "client_id", client_secret AS "client_secret"
    FROM user_ords_clients
    WHERE name = 'stlunch_client';
    
    apex_json.open_object;
    apex_json.write('user', l_user_cursor);
    apex_json.write('oauth',l_oauth_cursor);    
    apex_json.close_object;
    
  END login;
  
  PROCEDURE encrypt_password(
    p_email            IN stlunch_users.user_email%TYPE
  , p_passwd_enc   IN OUT stlunch_users.passwd_enc%TYPE
  , p_passwd_salt     OUT stlunch_users.passwd_salt%TYPE
  ) 
  IS
    l_user_rec            stlunch_users%ROWTYPE;
  BEGIN
    l_user_rec.user_email := p_email;
    l_user_rec.passwd_salt := DBMS_RANDOM.string('p',10);    
    
    get_encrypted_password(l_user_rec, p_passwd_enc);
    
    p_passwd_salt := l_user_rec.passwd_salt;
    p_passwd_enc := l_user_rec.passwd_enc;
  END encrypt_password;

  PROCEDURE email_new_password (
    p_body_text        IN CLOB
  ) IS
    l_body_text           CLOB := p_body_text;
    l_user_obj            JSON_OBJECT_T;   

    l_user_email          stlunch_users.user_email%TYPE;
    l_user_rec            stlunch_users%ROWTYPE;
    l_new_passwd          stlunch_users.passwd_enc%type;
  BEGIN
    l_user_obj := JSON_OBJECT_T(l_body_text);
    l_user_email := l_user_obj.get_string('user_email');

    SELECT *
    INTO l_user_rec
    FROM stlunch_active_users
    WHERE user_email = l_user_email;
    
    l_new_passwd := DBMS_RANDOM.string('a',12);
    l_user_rec.passwd_enc := l_new_passwd;
    
    encrypt_password(l_user_rec.user_email, l_user_rec.passwd_enc, l_user_rec.passwd_salt);
    
    UPDATE stlunch_users 
    SET passwd_enc = l_user_rec.passwd_enc, passwd_salt = l_user_rec.passwd_salt
    WHERE user_id = l_user_rec.user_id;
    
    stlunch_mails.send_new_password(l_user_rec.user_email, l_new_passwd);
  END email_new_password;
  
  PROCEDURE change_password(
    p_body_text        IN CLOB
  ) IS
    l_body_text           CLOB := p_body_text;
    l_user_obj            JSON_OBJECT_T;   

    l_user_rec            stlunch_users%ROWTYPE;

    l_old_passwd          stlunch_users.passwd_enc%type;
    l_new_passwd          stlunch_users.passwd_enc%type;

    l_old_stored          stlunch_users.passwd_enc%type;

  BEGIN
    l_user_obj := JSON_OBJECT_T(l_body_text);
    l_user_rec.user_id := l_user_obj.get_number('user_id');
    l_old_passwd := l_user_obj.get_string('old_password');
    l_new_passwd := l_user_obj.get_string('new_password');

    SELECT *
    INTO l_user_rec
    FROM stlunch_active_users
    WHERE user_id = l_user_rec.user_id;
    
    l_old_stored := l_user_rec.passwd_enc;
    
    get_encrypted_password(l_user_rec, l_old_passwd);
    
    IF l_old_stored != l_user_rec.passwd_enc THEN
      raise_application_error(-21001, 'Gammelt kodeord ikke genkendt');
    END IF;
    l_user_rec.passwd_enc := l_new_passwd;
    encrypt_password(l_user_rec.user_email, l_user_rec.passwd_enc, l_user_rec.passwd_salt);
    
    UPDATE stlunch_users 
    SET passwd_enc = l_user_rec.passwd_enc, passwd_salt = l_user_rec.passwd_salt
    WHERE user_id = l_user_rec.user_id;
  END change_password;
END stlunch_api;
/



