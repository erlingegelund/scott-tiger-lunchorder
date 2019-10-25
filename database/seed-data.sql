SET DEFINE OFF;

INSERT INTO stlunch_categories (category_id,category_name) VALUES (1,'Smørrebrød');
INSERT INTO stlunch_categories (category_id,category_name) VALUES (2,'Salater');
INSERT INTO stlunch_categories (category_id,category_name) VALUES (3,'Bagels');
INSERT INTO stlunch_categories (category_id,category_name) VALUES (4,'Sandwiches');
INSERT INTO stlunch_categories (category_id,category_name) VALUES (5,'Boller');
INSERT INTO stlunch_categories (category_id,category_name) VALUES (6,'Ostemadder');

INSERT INTO stlunch_suppliers (supplier_id,supplier_email,supplier_name,supplier_phone) VALUES (10,'slagterjohnoglise@live.dk','Slagter Lise og John','43990134');
INSERT INTO stlunch_suppliers (supplier_id,supplier_email,supplier_name,supplier_phone) VALUES (11,'kontakt@coffee-sandwich.dk','Coffee & Sandwich','43432630');
INSERT INTO stlunch_suppliers (supplier_id,supplier_email,supplier_name,supplier_phone) VALUES (12,'ibrahimelhaj@hotmail.com','Bagels n'' Cream','60790280');

INSERT INTO stlunch_users (user_id,user_email,user_name,administrator_yn,passwd_salt,passwd_enc,inactive_yn) VALUES (50,'helle.bohn@scott-tiger.dk','Helle Wittendorff Bohn','Y',null,'nisse',null);
INSERT INTO stlunch_users (user_id,user_email,user_name,administrator_yn,passwd_salt,passwd_enc,inactive_yn) VALUES (51,'maria.kragh@scott-tiger.dk','Maria Kragh','Y',null,'nisse',null);
INSERT INTO stlunch_users (user_id,user_email,user_name,administrator_yn,passwd_salt,passwd_enc,inactive_yn) VALUES (52,'pia.molgaard@scott-tiger.dk','Pia Mølgaard Sørensen','Y',null,'nisse',null);
INSERT INTO stlunch_users (user_id,user_email,user_name,administrator_yn,passwd_salt,passwd_enc,inactive_yn) VALUES (53,'lykke.luimes@scott-tiger.dk','Lykke Luimes','Y',null,'nisse',null);
INSERT INTO stlunch_users (user_id,user_email,user_name,administrator_yn,passwd_salt,passwd_enc,inactive_yn) VALUES (54,'torben.bolvig@scott-tiger.dk','Torben Bolvig','N',null,'nisse',null);
INSERT INTO stlunch_users (user_id,user_email,user_name,administrator_yn,passwd_salt,passwd_enc,inactive_yn) VALUES (55,'tom.slivsgaard@scott-tiger.dk','Tom Slivsgaard','N',null,'nisse',null);
INSERT INTO stlunch_users (user_id,user_email,user_name,administrator_yn,passwd_salt,passwd_enc,inactive_yn) VALUES (56,'maria.daugaard@scott-tiger.dk','Maria Daugaard','N',null,'nisse',null);
INSERT INTO stlunch_users (user_id,user_email,user_name,administrator_yn,passwd_salt,passwd_enc,inactive_yn) VALUES (57,'ole.kramer@scott-tiger.dk','Ole Kramer','N',null,'nisse',null);
INSERT INTO stlunch_users (user_id,user_email,user_name,administrator_yn,passwd_salt,passwd_enc,inactive_yn) VALUES (58,'kristian.hansen@scott-tiger.dk','Kristian Hansen','N',null,'nisse',null);
INSERT INTO stlunch_users (user_id,user_email,user_name,administrator_yn,passwd_salt,passwd_enc,inactive_yn) VALUES (59,'jeanette.hansen@scott-tiger.dk','Jeanette Hansen','N',null,'nisse',null);
INSERT INTO stlunch_users (user_id,user_email,user_name,administrator_yn,passwd_salt,passwd_enc,inactive_yn) VALUES (60,'ole.thomsen@scott-tiger.dk','Ole Thomsen','N',null,'nisse',null);
INSERT INTO stlunch_users (user_id,user_email,user_name,administrator_yn,passwd_salt,passwd_enc,inactive_yn) VALUES (61,'lars.baad@scott-tiger.dk','Lars Baad-Jensen','N',null,'nisse',null);
INSERT INTO stlunch_users (user_id,user_email,user_name,administrator_yn,passwd_salt,passwd_enc,inactive_yn) VALUES (62,'brian.peersen@scott-tiger.dk','Brian Pedersen','N',null,'nisse',null);
INSERT INTO stlunch_users (user_id,user_email,user_name,administrator_yn,passwd_salt,passwd_enc,inactive_yn) VALUES (63,'martin.vegeberg@scott-tiger.dk','Martin Vegeberg Nielsen','N',null,'nisse',null);
INSERT INTO stlunch_users (user_id,user_email,user_name,administrator_yn,passwd_salt,passwd_enc,inactive_yn) VALUES (64,'andreas.nielsen@scott-tiger.dk','Andreas Lund Nielsen','N',null,'nisse',null);
INSERT INTO stlunch_users (user_id,user_email,user_name,administrator_yn,passwd_salt,passwd_enc,inactive_yn) VALUES (65,'erling.friis.egelund@scott-tiger.dk','Erling Friis Egelund','N',null,'nisse',null);
INSERT INTO stlunch_users (user_id,user_email,user_name,administrator_yn,passwd_salt,passwd_enc,inactive_yn) VALUES (66,'rene.johansen@scott-tiger.dk','Rene Johansen','N',null,'nisse',null);
INSERT INTO stlunch_users (user_id,user_email,user_name,administrator_yn,passwd_salt,passwd_enc,inactive_yn) VALUES (67,'mickael.eriksson@scott-tiger.dk','Mickael Eriksson','N',null,'nisse',null);
INSERT INTO stlunch_users (user_id,user_email,user_name,administrator_yn,passwd_salt,passwd_enc,inactive_yn) VALUES (68,'morten.borges@scott-tiger.dk','Morten Borges','N',null,'nisse',null);
INSERT INTO stlunch_users (user_id,user_email,user_name,administrator_yn,passwd_salt,passwd_enc,inactive_yn) VALUES (69,'peter.roboz@scott-tiger.dk','Peter Roboz','N',null,'nisse',null);
INSERT INTO stlunch_users (user_id,user_email,user_name,administrator_yn,passwd_salt,passwd_enc,inactive_yn) VALUES (70,'mats.norreby@scott-tiger.dk','Mats Norreby','N',null,'nisse',null);
INSERT INTO stlunch_users (user_id,user_email,user_name,administrator_yn,passwd_salt,passwd_enc,inactive_yn) VALUES (71,'peter.gjelstrup@scott-tiger.dk','Peter Gjelstrup','N',null,'nisse',null);

DROP SEQUENCE stlunch_seq;
CREATE SEQUENCE stlunch_seq START WITH 100;

-- Slagterens smørrebørd
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,13,'Dyrlægens natmad');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,13,'Filet med røræg');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,15,'Fint hakket skinkesalat');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,39,'Fiskefilet med rejer');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,13,'Fiskefilet med remoulade');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,13,'Flæskesteg med rødkål og surt');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,13,'Frikadelle med rødkål og surt');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,15,'Grov skinkesalat');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,29,'Hakkebøf med bløde løg og surt');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,18,'Hakkebøf med rødbede og surt');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,39,'Hakkebøf med spejlæg');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,33,'Hønsesalat på franskbrød');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,13,'Kalkunbryst md italiensk salat');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,13,'Kalkunbryst med karrydressing og bacon');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,13,'Kartoffel med ristede løg');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,13,'Kartoffel med rå løg');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,33,'Krabbesalat på franskbrød');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,13,'Krydder rulle pølse med sky og løg');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,13,'Kødpølse med remoulade og ristede løg');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,13,'Levepostej med rødbede og surt');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,13,'Makrelsalat');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,39,'Mørbrad med bløde løg og surt');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,13,'Oksebryst med pickles');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,49,'Pariserbøf med tilbehør');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,35,'Rejer på franskbrød');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,33,'Rejesalat på franskbrød');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,13,'Roastbeef med remoulade og ristede løg');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,45,'Røget ål');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,49,'Røget/Graved laks');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,15,'Skinke med italiensk');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,15,'Sommeresalat');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,13,'Spegepølse med sky og rå løg');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,29,'Stegt lever med bløde løg og surt');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,13,'Stegt rullepølse med rødkål og surt');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,59,'Stjerneskud');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,45,'Tatar');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,13,'Tomat med mayonnise og rå løg');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,13,'Tunge med peberrodssalat');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,15,'Tunsalat');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,15,'Wienersalat');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,15,'Æg med karrysalat');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,15,'Æg med rejer');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,15,'Æg med sild');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,15,'Æg med tomat');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,15,'Æggesalat');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,25,'Dyrlægens natmad');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,25,'Filet med røræg');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,26,'Fint hakket skinkesalat');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,33,'Fiskefilet med remoulade');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,25,'Flæskesteg med rødkål og surt');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,25,'Frikadelle med rødkål og surt');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,26,'Grov skinkesalat');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,25,'Hakkebøf med rødbede og surt');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,25,'Kalkunbryst md italiensk salat');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,25,'Kalkunbryst med karrydressing og bacon');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,25,'Kartoffel med ristede løg');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,25,'Kartoffel med rå løg');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,25,'Krydder rulle pølse med sky og løg');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,25,'Kødpølse med remoulade og ristede løg');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,25,'Levepostej med rødbede og surt');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,25,'Makrelsalat');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,25,'Oksebryst med pickles');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,25,'Roastbeef med remoulade og ristede løg');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,26,'Skinke med italiensk');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,26,'Sommeresalat');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,25,'Spegepølse med sky og rå løg');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,25,'Stegt rullepølse med rødkål og surt');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,25,'Tomat med mayonnise og rå løg');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,25,'Tunge med peberrodssalat');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,26,'Tunsalat');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,26,'Wienersalat');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,26,'Æg med karrysalat');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,26,'Æg med rejer');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,26,'Æg med sild');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,26,'Æg med tomat');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,1,null,26,'Æggesalat');

-- Slagterens salater
DECLARE
  l_id stlunch_supplier_menus.supplier_menu_id%TYPE;
BEGIN 
  INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,2,null,25,'Grøn salat uden kød');
  INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,2,null,26,'Pastasalat uden kød');
  INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,2,null,35,'Grøn salat med kød') RETURNING supplier_menu_id INTO l_id;
  INSERT INTO stlunch_menu_options (menu_option_id,supplier_menu_id,description,mandatory_yn,multiple_yn,additional_price,selectables) VALUES (stlunch_seq.NEXTVAL,l_id,'Kød','Y','N',null,'Kylling'||CHR(10)||'Skinke'||CHR(10)||'Tun');
  INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,2,null,30,'Pastasalat med kød') RETURNING supplier_menu_id INTO l_id;
  INSERT INTO stlunch_menu_options (menu_option_id,supplier_menu_id,description,mandatory_yn,multiple_yn,additional_price,selectables) VALUES (stlunch_seq.NEXTVAL,l_id,'Kød','Y','N',null,'Kylling'||CHR(10)||'Skinke'||CHR(10)||'Tun');
END;
/

-- Slagterens boller
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,5,null,18,'Almindelig trekant sandwich med pålæg');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,5,null,35,'Bolle med pålæg');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,5,null,40,'Bolle med salat');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,5,null,20,'Dobbel trekant sandwich med pålæg');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,5,null,15,'Rugbrød snitter med pålæg');
DECLARE
  l_id stlunch_supplier_menus.supplier_menu_id%type;
BEGIN 
  INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,5,null,35,'Bolle') RETURNING supplier_menu_id INTO l_id;
  INSERT INTO stlunch_menu_options (menu_option_id,supplier_menu_id,description,mandatory_yn,multiple_yn,additional_price,selectables) VALUES (stlunch_seq.NEXTVAL, l_id, 'Fyld','Y','N',null,'Kylling'||CHR(10)||'Skinke'||CHR(10)||'Kalkun og bacon');
END;
/
-- Slagterens ostemadder
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,6,null,25,'Brie på franskbrød');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,6,null,25,'Danablue på franskbrød');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,6,null,25,'Gorgonzola på franskbrød');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,6,null,25,'Mild ost på franskbrød');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,6,null,13,'Ost på rugbrød');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,10,6,null,25,'Stærk ost på franskbrød');

-- Coffee and Sandwich
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,11,4,'Grov brød med mayonnaise, avocado, æg, fint hakket salat løg, salt og peber',49,'Manhattan Lady');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,11,4,'Mørkt brød, mozzarella, frisk basilikum, parmaskinke, rucolla og hjemmelavet pesto.',49,'Italiano');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,11,4,'Mørkt brød, chorizopølse, rucola, løg, semidried tomater, oliven, urtedressing',49,'Chorizo');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,11,4,'Marineret kyllingebryst, sprød bacon og hjemmelavet karrydressing',49,'Clubsandwich');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,11,4,'Røget laks, urte Philadelphia ost, rødløg og dilddressing',49,'Røget laks');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,11,4,'Parmaskinke, urte Philadelphia ost, hjemmelavet basilikum og hjemmelavet pesto',49,'Parmaskinke');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,11,4,'Kyllingebryst, salatmix, majs, avocadomos og sød chili dressing',49,'Chilli’s');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,11,4,'Hjemmelavet tunmousse, semidried tomater, jalapenos, rødløg, rucola, frisk basilikum og creme fraiche',49,'Tunmousse');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,11,4,'Kyllingebryst, hummus, semidried tomater, pesto, jalapenos oliven og mozzarellaost',49,'Hummus');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,11,4,'Æg, bacon, rødløg, hjemmelavet basilikum og creme fraiche',49,'Æg og bacon');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,11,4,'Hjemmelavede okse kød frikadeller, løg og tzatziki',49,'Frikadeller');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,11,4,'Mozzarellaost, jalapenos, semidried tomater, rødløg og pesto',49,'Vegetar');
INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,11,4,'Salat, tomater, agurk, rødløg & creme fraiche',49,'Kebab sandwich');
DECLARE
    l_id stlunch_supplier_menus.supplier_menu_id%TYPE;
BEGIN 
    INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,11,2,null,35,'Mix&Match') RETURNING SUPPLIER_MENU_ID INTO l_id;
    INSERT INTO stlunch_menu_options (menu_option_id,supplier_menu_id,description,mandatory_yn,multiple_yn,additional_price,selectables) VALUES (stlunch_seq.NEXTVAL,l_id,'Salat','Y','Y',null,'Broccolisalat'||CHR(10)||'Couscous'||CHR(10)||'Kikærter'||CHR(10)||'Rødbets'||CHR(10)||'Coleslaw'||CHR(10)||'Kartoffel'||CHR(10)||'Pasta'||CHR(10)||'Hummus'||CHR(10)||'Revet gulerødder'||CHR(10)||'Tomater'||CHR(10)||'Agurker'||CHR(10)||'Feta'||CHR(10)||'Peberfrugt'||CHR(10)||'Icebergsalat'||CHR(10)||'Ruccola salat');
    INSERT INTO stlunch_menu_options (menu_option_id,supplier_menu_id,description,mandatory_yn,multiple_yn,additional_price,selectables) VALUES (stlunch_seq.NEXTVAL,l_id,'Dressing','N','N',null,'Karry'||CHR(10)||'Creme Fraiche'||CHR(10)||'Chili Mayo'||CHR(10)||'Grøn Pesto'||CHR(10)||'Sød Chili'||CHR(10)||'Tzaziki'||CHR(10)||'Humus'||CHR(10)||'Chili');
    INSERT INTO stlunch_menu_options (menu_option_id,supplier_menu_id,description,mandatory_yn,multiple_yn,additional_price,selectables) VALUES (stlunch_seq.NEXTVAL,l_id,'Kød','N','N',null,'Kylling');
    INSERT INTO stlunch_menu_options (menu_option_id,supplier_menu_id,description,mandatory_yn,multiple_yn,additional_price,selectables) VALUES (stlunch_seq.NEXTVAL,l_id,'Brød','N','N',8,'Ja');
END;
/

-- Bagel shoppen
DECLARE
    l_id stlunch_supplier_menus.supplier_menu_id%type;
BEGIN 
    -- Lille salat
    INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,12,2,null,30,'Lille salat') RETURNING SUPPLIER_MENU_ID INTO l_id;
    INSERT INTO stlunch_menu_options (menu_option_id,supplier_menu_id,description,mandatory_yn,multiple_yn,additional_price,selectables) VALUES (stlunch_seq.NEXTVAL,l_id,'Dressing','N','N',null,'Yoghurt'||CHR(10)||'Karry'||CHR(10)||'Creme fraiche'||CHR(10)||'Thousand Island'||CHR(10)||'Fransk sennep'||CHR(10)||'Hvidløg'||CHR(10)||'Pesto'||CHR(10)||'Chili'||CHR(10)||'Sød Chili');
    INSERT INTO stlunch_menu_options (menu_option_id,supplier_menu_id,description,mandatory_yn,multiple_yn,additional_price,selectables) VALUES (stlunch_seq.NEXTVAL,l_id,'Kød','N','N',null,'Kylling'||CHR(10)||'Karry kylling'||CHR(10)||'Tandori kylling'||CHR(10)||'Tun'||CHR(10)||'Kalkun'||CHR(10)||'Roastbeef'||CHR(10)||'Æggesalat'||CHR(10)||'Krabbesalat');
    INSERT INTO stlunch_menu_options (menu_option_id,supplier_menu_id,description,mandatory_yn,multiple_yn,additional_price,selectables) VALUES (stlunch_seq.NEXTVAL,l_id,'Fyld','N','Y',null,'Pasta'||CHR(10)||'Tomat'||CHR(10)||'Bønnespirer'||CHR(10)||'Gulerod'||CHR(10)||'Soltørrede tomater'||CHR(10)||'Rød peber'||CHR(10)||'Majs'||CHR(10)||'Oliven'||CHR(10)||'Jalapenos'||CHR(10)||'Feta'||CHR(10)||'Iceberg'||CHR(10)||'Rucola salat'||CHR(10)||'Agurk'||CHR(10)||'Krøl salat');
    INSERT INTO stlunch_menu_options (menu_option_id,supplier_menu_id,description,mandatory_yn,multiple_yn,additional_price,selectables) VALUES (stlunch_seq.NEXTVAL,l_id,'Nødder','N','N',5,'Ja');
    -- Stor salat
    INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,12,2,null,40,'Stor salat') RETURNING SUPPLIER_MENU_ID INTO l_id;
    INSERT INTO stlunch_menu_options (menu_option_id,supplier_menu_id,description,mandatory_yn,multiple_yn,additional_price,selectables) VALUES (stlunch_seq.NEXTVAL,l_id,'Dressing','N','N',null,'Yoghurt'||CHR(10)||'Karry'||CHR(10)||'Creme fraiche'||CHR(10)||'Thousand Island'||CHR(10)||'Fransk sennep'||CHR(10)||'Hvidløg'||CHR(10)||'Pesto'||CHR(10)||'Chili'||CHR(10)||'Sød Chili');
    INSERT INTO stlunch_menu_options (menu_option_id,supplier_menu_id,description,mandatory_yn,multiple_yn,additional_price,selectables) VALUES (stlunch_seq.NEXTVAL,l_id,'Kød','N','N',null,'Kylling'||CHR(10)||'Karry kylling'||CHR(10)||'Tandori kylling'||CHR(10)||'Tun'||CHR(10)||'Kalkun'||CHR(10)||'Roastbeef'||CHR(10)||'Æggesalat'||CHR(10)||'Krabbesalat');
    INSERT INTO stlunch_menu_options (menu_option_id,supplier_menu_id,description,mandatory_yn,multiple_yn,additional_price,selectables) VALUES (stlunch_seq.NEXTVAL,l_id,'Fyld','N','Y',null,'Pasta'||CHR(10)||'Tomat'||CHR(10)||'Bønnespirer'||CHR(10)||'Gulerod'||CHR(10)||'Soltørrede tomater'||CHR(10)||'Rød peber'||CHR(10)||'Majs'||CHR(10)||'Oliven'||CHR(10)||'Jalapenos'||CHR(10)||'Feta'||CHR(10)||'Iceberg'||CHR(10)||'Rucola salat'||CHR(10)||'Agurk'||CHR(10)||'Krøl salat');
    INSERT INTO stlunch_menu_options (menu_option_id,supplier_menu_id,description,mandatory_yn,multiple_yn,additional_price,selectables) VALUES (stlunch_seq.NEXTVAL,l_id,'Nødder','N','N',5,'Ja');
    -- Bagel
    INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,12,3,null,45,'Bagel') RETURNING SUPPLIER_MENU_ID INTO l_id;
    INSERT INTO stlunch_menu_options (menu_option_id,supplier_menu_id,description,mandatory_yn,multiple_yn,additional_price,selectables) VALUES (stlunch_seq.NEXTVAL,l_id,'Brød','Y','N',null,'Lyst brød med ost'||CHR(10)||'Mørkt brød');
    INSERT INTO stlunch_menu_options (menu_option_id,supplier_menu_id,description,mandatory_yn,multiple_yn,additional_price,selectables) VALUES (stlunch_seq.NEXTVAL,l_id,'Bund','Y','N',null,'Miracle Whip'||CHR(10)||'Chesse natural'||CHR(10)||'Chesse urter'||CHR(10)||'Hummus'||CHR(10)||'Chesse Chili'||CHR(10)||'Guacamole');
    INSERT INTO stlunch_menu_options (menu_option_id,supplier_menu_id,description,mandatory_yn,multiple_yn,additional_price,selectables) VALUES (stlunch_seq.NEXTVAL,l_id,'Dressing','N','N',null,'Yoghurt'||CHR(10)||'Karry'||CHR(10)||'Creme fraiche'||CHR(10)||'Thousand Island'||CHR(10)||'Fransk sennep'||CHR(10)||'Hvidløg'||CHR(10)||'Pesto'||CHR(10)||'Chili'||CHR(10)||'Sød Chili');
    INSERT INTO stlunch_menu_options (menu_option_id,supplier_menu_id,description,mandatory_yn,multiple_yn,additional_price,selectables) VALUES (stlunch_seq.NEXTVAL,l_id,'Kød','N','N',null,'Kylling'||CHR(10)||'Karry kylling'||CHR(10)||'Tandori kylling'||CHR(10)||'Tun'||CHR(10)||'Kalkun'||CHR(10)||'Roastbeef'||CHR(10)||'Æggesalat'||CHR(10)||'Krabbesalat');
    INSERT INTO stlunch_menu_options (menu_option_id,supplier_menu_id,description,mandatory_yn,multiple_yn,additional_price,selectables) VALUES (stlunch_seq.NEXTVAL,l_id,'Fyld','N','Y',null,'Pasta'||CHR(10)||'Tomat'||CHR(10)||'Bønnespirer'||CHR(10)||'Gulerod'||CHR(10)||'Soltørrede tomater'||CHR(10)||'Rød peber'||CHR(10)||'Majs'||CHR(10)||'Oliven'||CHR(10)||'Jalapenos'||CHR(10)||'Feta'||CHR(10)||'Iceberg'||CHR(10)||'Rucola salat'||CHR(10)||'Agurk'||CHR(10)||'Krøl salat');
    -- Sandwich
    INSERT INTO stlunch_supplier_menus (supplier_menu_id,supplier_id,category_id,description,price,menu_name) VALUES (stlunch_seq.NEXTVAL,12,4,null,40,'Sandwich') RETURNING SUPPLIER_MENU_ID INTO l_id;
    INSERT INTO stlunch_menu_options (menu_option_id,supplier_menu_id,description,mandatory_yn,multiple_yn,additional_price,selectables) VALUES (stlunch_seq.NEXTVAL,l_id,'Brød','Y','N',null,'Lyst brød med ost'||CHR(10)||'Mørkt brød');
    INSERT INTO stlunch_menu_options (menu_option_id,supplier_menu_id,description,mandatory_yn,multiple_yn,additional_price,selectables) VALUES (stlunch_seq.NEXTVAL,l_id,'Bund','Y','N',null,'Miracle Whip'||CHR(10)||'Chesse natural'||CHR(10)||'Chesse urter'||CHR(10)||'Hummus'||CHR(10)||'Chesse Chili'||CHR(10)||'Guacamole');
    INSERT INTO stlunch_menu_options (menu_option_id,supplier_menu_id,description,mandatory_yn,multiple_yn,additional_price,selectables) VALUES (stlunch_seq.NEXTVAL,l_id,'Dressing','N','N',null,'Yoghurt'||CHR(10)||'Karry'||CHR(10)||'Creme fraiche'||CHR(10)||'Thousand Island'||CHR(10)||'Fransk sennep'||CHR(10)||'Hvidløg'||CHR(10)||'Pesto'||CHR(10)||'Chili'||CHR(10)||'Sød Chili');
    INSERT INTO stlunch_menu_options (menu_option_id,supplier_menu_id,description,mandatory_yn,multiple_yn,additional_price,selectables) VALUES (stlunch_seq.NEXTVAL,l_id,'Kød','N','N',null,'Kylling'||CHR(10)||'Karry kylling'||CHR(10)||'Tandori kylling'||CHR(10)||'Tun'||CHR(10)||'Kalkun'||CHR(10)||'Roastbeef'||CHR(10)||'Æggesalat'||CHR(10)||'Krabbesalat');
    INSERT INTO stlunch_menu_options (menu_option_id,supplier_menu_id,description,mandatory_yn,multiple_yn,additional_price,selectables) VALUES (stlunch_seq.NEXTVAL,l_id,'Fyld','N','Y',null,'Pasta'||CHR(10)||'Tomat'||CHR(10)||'Bønnespirer'||CHR(10)||'Gulerod'||CHR(10)||'Soltørrede tomater'||CHR(10)||'Rød peber'||CHR(10)||'Majs'||CHR(10)||'Oliven'||CHR(10)||'Jalapenos'||CHR(10)||'Feta'||CHR(10)||'Iceberg'||CHR(10)||'Rucola salat'||CHR(10)||'Agurk'||CHR(10)||'Krøl salat');
END;
/
COMMIT;
