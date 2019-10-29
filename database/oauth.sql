--https://oracle-base.com/articles/misc/oracle-rest-data-services-ords-authentication#first-party-authentication
DECLARE
  l_role_arr OWA.vc_arr;
  l_pattern_arr OWA.vc_arr;
  l_module_arr OWA.vc_arr;
  l_privilege_name CONSTANT VARCHAR2(20) := 'stlunch_priv';
  l_client_name CONSTANT VARCHAR2(20) := 'stlunch_client';
BEGIN
  l_role_arr(1) := 'stlunch_role';
  l_role_arr(2) := 'oracle.dbtools.role.autorest.ST_LUNCH.STLUNCH_CATEGORIES';
  l_role_arr(3) := 'oracle.dbtools.role.autorest.ST_LUNCH.STLUNCH_SUPPLIERS';
  l_role_arr(4) := 'oracle.dbtools.role.autorest.ST_LUNCH.STLUNCH_ACTIVE_USERS';
  l_role_arr(5) := 'oracle.dbtools.role.autorest.ST_LUNCH.STLUNCH_SUPPLIER_MENUS';
  l_role_arr(6) := 'oracle.dbtools.role.autorest.ST_LUNCH.STLUNCH_MENU_OPTIONS';
  l_role_arr(7) := 'oracle.dbtools.role.autorest.ST_LUNCH.STLUNCH_ORDERS';
  --l_pattern_arr(1) := '/stlunch/api/*';
  l_module_arr(1) := 'create_order';
  l_module_arr(2) := 'get_user_order';
  l_module_arr(3) := 'menu_options';
  l_module_arr(4) := 'orders_period';
  l_module_arr(5) := 'prep_order_menu';
  l_module_arr(6) := 'prep_order_supp_cat';
  l_module_arr(7) := 'supplier_menus';
  
  
  ORDS.create_role(
    p_role_name => l_role_arr(1)
  );
  
  COMMIT;
  
/*  
  FOR i in l_role_arr.first..l_role_arr.last LOOP
    OAUTH.revoke_client_role(
      p_client_name => 'stlunch_client',
      p_role_name   => l_role_arr(i)
    );
  END LOOP;
  OAUTH.delete_client(
    p_name => l_client_name
  );
  commit;
*/
  
  ORDS.define_privilege (
    p_privilege_name => l_privilege_name,
    p_roles          => l_role_arr,
    p_patterns       => l_pattern_arr,
    p_modules        => l_module_arr,
    p_label          => 'STLUNCH Data',
    p_description    => 'Allow access to the STLUNCH data.'
  );
  
  COMMIT;
  
  OAUTH.create_client(
    p_name            => l_client_name,
    p_grant_type      => 'client_credentials',
    p_owner           => 'Scott/Tiger A/S',
    p_description     => 'A client for STLunch',
    p_support_email   => 'martin.vegeberg@scott-tiger.dk',
    p_privilege_names => l_privilege_name
  );
  
  FOR i in l_role_arr.first..l_role_arr.last LOOP
    OAUTH.grant_client_role(
      p_client_name => 'stlunch_client',
      p_role_name   => l_role_arr(i)
    );
  END LOOP;
  
  COMMIT;
END;
/

column name format a20
column client_id format a25
column client_secret format a25
SELECT id, name, client_id, client_secret
FROM   user_ords_clients;