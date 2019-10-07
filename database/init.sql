CREATE user st_lunch identified BY st_lunch;
GRANT connect, resource TO st_lunch;
ALTER USER st_lunch quota unlimited ON users;

CONN st_lunch/st_lunch@//localhost:1539/xepdb1

DROP SEQUENCE stlunch_seq;
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
, passwd_enc VARCHAR2(40 CHAR)  -- future use
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
, supplier_email VARCHAR2(40) NOT NULL
, supplier_name VARCHAR2(40) NOT NULL
, supplier_phone VARCHAR2(40) NOT NULL
, CONSTRAINT stlunch_supplier_pk PRIMARY KEY (supplier_id)
);

CREATE TABLE stlunch_supplier_menus (
  supplier_menu_id NUMBER(10)
, supplier_id NUMBER(10) NOT NULL
, category_id NUMBER(10) NOT NULL
, description VARCHAR2(40) NOT NULL
, price NUMBER(6,2)
, CONSTRAINT stlunch_supplier_menu_pk PRIMARY KEY (supplier_menu_id)
, CONSTRAINT stlunch_sup_supp_menu_it_fk FOREIGN KEY (supplier_id) REFERENCES stlunch_suppliers (supplier_id)
, CONSTRAINT stlunch_cat_supp_menu_it_fk FOREIGN KEY (category_id) REFERENCES stlunch_categories (category_id)
);

CREATE TABLE stlunch_menu_options (
  menu_option_id NUMBER(10)
, supplier_menu_id NUMBER(10) NOT NULL
, mandatory_yn CHAR(1) DEFAULT 'N' NOT NULL
, multiple__yn CHAR(1) DEFAULT 'N' NOT NULL
, additional_price NUMBER(6,2)
, selections VARCHAR2(4000) NOT NULL
, CONSTRAINT stlunch_menu_option_pk PRIMARY KEY (menu_option_id)
, CONSTRAINT stlunch_menu_option_fk FOREIGN KEY (supplier_menu_id) REFERENCES stlunch_supplier_menus (supplier_menu_id)
);

CREATE TABLE stlunch_orders (
  order_id NUMBER(10)
, user_id NUMBER(10) NOT NULL
, order_date DATE NOT NULL
, supplier_email VARCHAR2(40) NOT NULL
, supplier_name VARCHAR2(40) NOT NULL
, menu_category VARCHAR2(40) NOT NULL
, menu_description VARCHAR2(40) NOT NULL
, menu_options VARCHAR2(4000)
, price NUMBER(6,2) NOT NULL
, user_comment VARCHAR2(255)
, CONSTRAINT stlunch_order_pk PRIMARY KEY (order_id)
, CONSTRAINT stlunch_user_order_fk FOREIGN KEY (user_id) REFERENCES stlunch_users (user_id)
);

CREATE OR REPLACE TRIGGER stlunch_user_bir 
BEFORE INSERT 
ON stlunch_users
REFERENCING new AS new
FOR EACH ROW
BEGIN
  IF :new.user_id IS NULL THEN
    :new.user_id := stlunch_seq.nextval;
  END IF;
END;
/

CREATE OR REPLACE TRIGGER stlunch_category_bir 
BEFORE INSERT 
ON stlunch_categories
REFERENCING new AS new
FOR EACH ROW
BEGIN
  IF :new.category_id IS NULL THEN
    :new.category_id := stlunch_seq.nextval;
  END IF;
END;
/

CREATE OR REPLACE TRIGGER stlunch_supplier_bir 
BEFORE INSERT 
ON stlunch_suppliers
REFERENCING new AS new
FOR EACH ROW
BEGIN
  IF :new.supplier_id IS NULL THEN
    :new.supplier_id := stlunch_seq.nextval;
  END IF;
END;
/

CREATE OR REPLACE TRIGGER stlunch_supplier_menu_bir 
BEFORE INSERT 
ON stlunch_supplier_menus
REFERENCING new AS new
FOR EACH ROW
BEGIN
  IF :new.supplier_menu_id IS NULL THEN
    :new.supplier_menu_id := stlunch_seq.nextval;
  END IF;
END;
/

CREATE OR REPLACE TRIGGER stlunch_menu_option_bir 
BEFORE INSERT 
ON stlunch_menu_options
REFERENCING new AS new
FOR EACH ROW
BEGIN
  IF :new.menu_option_id IS NULL THEN
    :new.menu_option_id := stlunch_seq.nextval;
  END IF;
END;
/

CREATE OR REPLACE TRIGGER stlunch_order_bir 
BEFORE INSERT 
ON stlunch_orders
REFERENCING new AS new
FOR EACH ROW
BEGIN
  IF :new.order_id IS NULL THEN
    :new.order_id := stlunch_seq.nextval;
  END IF;
END;
/
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

    ORDS.ENABLE_SCHEMA(p_enabled => TRUE,
                       p_schema => 'ST_LUNCH',
                       p_url_mapping_type => 'BASE_PATH',
                       p_url_mapping_pattern => 'st_lunch',
                       p_auto_rest_auth => FALSE);

    commit;

    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'ST_LUNCH',
                       p_object => 'STLUNCH_CATEGORIES',
                       p_object_type => 'TABLE',
                       p_object_alias => 'stlunch_categories',
                       p_auto_rest_auth => FALSE);

    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'ST_LUNCH',
                       p_object => 'STLUNCH_USERS',
                       p_object_type => 'TABLE',
                       p_object_alias => 'stlunch_users',
                       p_auto_rest_auth => FALSE);

    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'ST_LUNCH',
                       p_object => 'STLUNCH_SUPPLIERS',
                       p_object_type => 'TABLE',
                       p_object_alias => 'stlunch_suppliers',
                       p_auto_rest_auth => FALSE);

    commit;

END;