CREATE OR REPLACE TRIGGER stlunch_user_bir 
BEFORE INSERT 
ON stlunch_users
REFERENCING new AS new
FOR EACH ROW
BEGIN
  IF :new.user_id IS NULL OR :new.user_id < 0 THEN
    :new.user_id := stlunch_seq.nextval;
  END IF;
  :new.passwd_enc := 'nisse';
  stlunch_api.encrypt_password(:new.user_email, :new.passwd_enc, :new.passwd_salt);
END;
/

CREATE OR REPLACE TRIGGER stlunch_category_bir 
BEFORE INSERT 
ON stlunch_categories
REFERENCING new AS new
FOR EACH ROW
BEGIN
  IF :new.category_id IS NULL OR :new.category_id < 0 THEN
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
  IF :new.supplier_id IS NULL OR :new.supplier_id < 0 THEN
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
  IF :new.supplier_menu_id IS NULL OR :new.supplier_menu_id < 0 THEN
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
  IF :new.menu_option_id IS NULL OR :new.menu_option_id < 0 THEN
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
  IF :new.order_id IS NULL OR :new.order_id < 0 THEN
    :new.order_id := stlunch_seq.nextval;
  END IF;
END;
/

  
