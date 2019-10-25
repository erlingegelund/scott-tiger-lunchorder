BEGIN
  DBMS_NETWORK_ACL_ADMIN.CREATE_ACL(
    acl         => 'smtp.xml',
    description => 'SMTP ACL',
    principal   => 'ST_LUNCH',
    is_grant    => true,
    privilege   => 'connect');
 
  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(
    acl       => 'smtp.xml',
    principal => 'ST_LUNCH',
    is_grant  => true,
    privilege => 'resolve');
 
  DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL(
    acl  => 'smtp.xml',
    host => '192.168.122.1');

/*
  DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE (
    host         => '192.168.122.1', 
    lower_port   => 9025,
    upper_port   => 9025,
    ace          => ace_definition);                                     
*/
END;
/
COMMIT;