/*
CREATE user st_lunch identified BY st_lunch;
GRANT connect, resource, create view TO st_lunch;
ALTER USER st_lunch quota unlimited ON users;

grant execute on sys.dbms_crypto to st_lunch;

CONN st_lunch/st_lunch@//localhost:1539/xepdb1
*/

DROP SEQUENCE stlunch_seq;
DROP TABLE stlunch_order_options PURGE;
DROP TABLE stlunch_orders PURGE;
DROP TABLE stlunch_menu_options PURGE;
DROP TABLE stlunch_supplier_menus PURGE;
DROP TABLE stlunch_suppliers PURGE;
DROP TABLE stlunch_categories PURGE;
DROP TABLE stlunch_users PURGE;

CREATE SEQUENCE stlunch_seq;

CREATE TABLE stlunch_users (
  user_id NUMBER(10)
, user_email VARCHAR2(40 CHAR) NOT NULL
, user_name VARCHAR2(40 CHAR) NOT NULL
, administrator_yn CHAR(1) DEFAULT 'N' NOT NULL
, passwd_salt VARCHAR2(10 CHAR) -- future use
, passwd_enc VARCHAR2(255 CHAR)  -- future use
, inactive_yn CHAR(1)
, CONSTRAINT stlunch_user_pk PRIMARY KEY (user_id)
);

CREATE TABLE stlunch_categories (
  category_id NUMBER(10)
, category_name VARCHAR2(40) NOT NULL
, CONSTRAINT stlunch_category_pk PRIMARY KEY (category_id)
);

CREATE TABLE stlunch_suppliers (
  supplier_id NUMBER(10)
, supplier_email VARCHAR2(40 CHAR) NOT NULL
, supplier_name VARCHAR2(40 CHAR) NOT NULL
, supplier_phone VARCHAR2(40 CHAR)
, order_memo VARCHAR2(255 CHAR)
, CONSTRAINT stlunch_supplier_pk PRIMARY KEY (supplier_id)
);

CREATE TABLE stlunch_supplier_menus (
  supplier_menu_id NUMBER(10)
, supplier_id NUMBER(10) NOT NULL
, category_id NUMBER(10) NOT NULL
, menu_name VARCHAR2(40 CHAR) NOT NULL
, description VARCHAR2(255 CHAR)
, price NUMBER(6,2)
, CONSTRAINT stlunch_supplier_menu_pk PRIMARY KEY (supplier_menu_id)
, CONSTRAINT stlunch_sup_supp_menu_it_fk FOREIGN KEY (supplier_id) REFERENCES stlunch_suppliers (supplier_id)
, CONSTRAINT stlunch_cat_supp_menu_it_fk FOREIGN KEY (category_id) REFERENCES stlunch_categories (category_id)
);

CREATE TABLE stlunch_menu_options (
  menu_option_id NUMBER(10)
, supplier_menu_id NUMBER(10) NOT NULL
, description VARCHAR2(40 CHAR) NOT NULL
, mandatory_yn CHAR(1) DEFAULT 'N' NOT NULL
, multiple_yn CHAR(1) DEFAULT 'N' NOT NULL
, additional_price NUMBER(6,2)
, selectables VARCHAR2(4000 CHAR) NOT NULL
, sort_order NUMBER(10)
, CONSTRAINT stlunch_menu_option_pk PRIMARY KEY (menu_option_id)
, CONSTRAINT stlunch_menu_option_fk FOREIGN KEY (supplier_menu_id) 
    REFERENCES stlunch_supplier_menus (supplier_menu_id) 
    ON DELETE CASCADE
);

CREATE TABLE stlunch_orders (
  order_id NUMBER(10)
, user_id NUMBER(10) NOT NULL
, order_date DATE NOT NULL
, supplier_email VARCHAR2(40 CHAR) NOT NULL
, supplier_name VARCHAR2(40 CHAR) NOT NULL
, menu_category VARCHAR2(40 CHAR) NOT NULL
, menu_name VARCHAR2(40 CHAR) NOT NULL
, items_ordered NUMBER(4) NOT NULL
, price NUMBER(6,2) NOT NULL
, user_comment VARCHAR2(255 CHAR)
, CONSTRAINT stlunch_order_pk PRIMARY KEY (order_id)
, CONSTRAINT stlunch_user_order_fk FOREIGN KEY (user_id) REFERENCES stlunch_users (user_id)
);

CREATE TABLE stlunch_order_options (
  order_option_id NUMBER(10)
, order_id NUMBER(10) NOT NULL
, description VARCHAR(40 CHAR) NOT NULL
, selected VARCHAR2(255 CHAR) NOT NULL
, sort_order NUMBER(10)
, CONSTRAINT stlunch_order_option_pk PRIMARY KEY (order_option_id)
, CONSTRAINT stlunch_order_order_option_fk FOREIGN KEY (order_id) 
    REFERENCES stlunch_orders (order_id) 
    ON DELETE CASCADE
);

CREATE OR REPLACE VIEW stlunch_active_users AS
  SELECT * FROM stlunch_users WHERE nvl(inactive_yn,'N') = 'N';
