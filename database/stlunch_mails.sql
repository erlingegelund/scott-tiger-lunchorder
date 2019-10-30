CREATE OR REPLACE PACKAGE stlunch_mails AS
-- ********************************************************************
-- | DESCRIPTION: Used for lunch system mails
-- |
-- | CHANGE HISTORY:
-- |
-- | VERSION   DATE        AUTHOR     	     DESCRIPTION
-- | -------   --------    --------   	     --------------------------
-- | 1.0       2019-10-24  Erling Egelund   Initial version
-- *********************************************************************
    PROCEDURE send_daily_mails;

    PROCEDURE send_month_report;
    
    PROCEDURE send_new_password(
      p_email             stlunch_users.user_email%type
    , p_new_password      stlunch_users.passwd_enc%type
    );

END stlunch_mails;
/

CREATE OR REPLACE PACKAGE BODY stlunch_mails AS
   -- ********************************************************************
   -- | DESCRIPTION: Used for lunch system mails
   -- |
   -- | CHANGE HISTORY:
   -- |
   -- | VERSION   DATE        AUTHOR     	     DESCRIPTION
   -- | -------   --------    --------   	     --------------------------
   -- | 1.0       2019-10-24  Erling Egelund   Initial version
   -- *********************************************************************
   -- -----------------------------
   -- Global variables
   -- -----------------------------
   g_smtp_server VARCHAR2(30) := '192.168.122.1'; -- TODO: Erstat med ST-DDC-POSTFIX-01
   g_smtp_port   NUMBER := 9025;                 -- TODO: Erstat med port 25
   -- --------------------------------
   -- Private procedures and functions
   -- --------------------------------
   PROCEDURE send_mail (
     p_subject   IN VARCHAR2
   , p_body_html IN VARCHAR2
   , p_recipient IN VARCHAR2
   , p_cc_admin  IN BOOLEAN DEFAULT TRUE
   ) IS
      c UTL_SMTP.CONNECTION;
      l_cc VARCHAR2(4000); 
      l_recipient VARCHAR2(4000) := p_recipient; 
 
      PROCEDURE send_header(name IN VARCHAR2, header IN VARCHAR2) AS
      BEGIN
         IF header IS NOT NULL THEN
            utl_smtp.write_raw_data(c, utl_raw.cast_to_raw(name || ': ' || header || utl_tcp.crlf));
         END IF;
      END;
   BEGIN
      c := UTL_SMTP.OPEN_CONNECTION(g_smtp_server,g_smtp_port);
      UTL_SMTP.EHLO(c, 'scott-tiger.dk');
      UTL_SMTP.MAIL(c, 'info@scott-tiger.dk');
      
      IF p_recipient IS NULL OR p_cc_admin THEN
         FOR r_cc IN (SELECT user_email FROM stlunch_users WHERE administrator_yn = 'Y' AND nvl(inactive_yn,'N') = 'N') LOOP
            UTL_SMTP.RCPT(c, r_cc.user_email);
            IF l_cc IS NULL THEN
               l_cc := r_cc.user_email;
            ELSE
               l_cc := l_cc||';'||r_cc.user_email;
            END IF;
         END LOOP;
      END IF;

      IF p_recipient IS NULL THEN
         l_recipient := l_cc;
         l_cc := null;
      ELSE
         UTL_SMTP.RCPT(c, p_recipient);
      END IF;
     
      UTL_SMTP.OPEN_DATA(c);
      send_header('Date',         to_char(sysdate, 'Dy, DD Mon YYYY hh24:mi:ss'));
      send_header('From',         'info@scott-tiger.dk');
      send_header('To',           l_recipient);
      send_header('CC',           l_cc);
      send_header('Subject',      REPLACE(utl_encode.mimeheader_encode(p_subject, 'utf8'),'?='||CHR(13)||CHR(10)||'=?utf8?Q?',''));
      send_header('Content-Type', 'text/html; charset=utf-8');
      utl_smtp.write_raw_data(c, utl_raw.cast_to_raw(utl_tcp.crlf || p_body_html));
      UTL_SMTP.CLOSE_DATA(c);
      UTL_SMTP.QUIT(c);
      EXCEPTION
   WHEN utl_smtp.transient_error OR utl_smtp.permanent_error THEN
      BEGIN
         UTL_SMTP.QUIT(c);
      EXCEPTION
         WHEN UTL_SMTP.TRANSIENT_ERROR OR UTL_SMTP.PERMANENT_ERROR THEN
            NULL; -- When the SMTP server is down or unavailable, we don't have
                  -- a connection to the server. The QUIT call raises an
                  -- exception that we can ignore.
      END;
      raise_application_error(-20000,'Failed to send mail due to the following error: ' || sqlerrm);
   END send_mail;
   -- -------------------------------
   -- Public procedures and functions
   -- -------------------------------
   PROCEDURE send_daily_mails IS
      TYPE tbl_order_options IS TABLE OF stlunch_order_options%ROWTYPE;
      l_order_options tbl_order_options;
--      l_id NUMBER;
      l_body_html VARCHAR2(4000);
      l_order_date VARCHAR2(10) := TO_CHAR(sysdate,'DD.MM.YYYY');
--      l_supplier stlunch_suppliers.supplier_name%TYPE := 'FirstRecord';
--      l_supplier_id stlunch_suppliers.supplier_id%TYPE;
      l_order_memo stlunch_suppliers.order_memo%TYPE;
      l_total NUMBER;
   BEGIN
      FOR c1 IN (
         SELECT DISTINCT supplier_email, supplier_name, order_date
         FROM stlunch_orders
         WHERE order_date = TRUNC(sysdate)
         ORDER BY supplier_email
      ) LOOP
         l_total := 0;
--         l_supplier_id := 0;
         l_order_memo := null;
         
         FOR rec IN (
            SELECT supplier_id, order_memo 
            FROM stlunch_suppliers
            WHERE stlunch_suppliers.supplier_email = c1.supplier_email
        ) LOOP
--           l_supplier_id := rec.supplier_id;
           l_order_memo := rec.order_memo;
        END LOOP;
         
         l_body_html := '<html><head><style>'||utl_tcp.crlf;
         l_body_html := l_body_html||'table {font-family: arial, sans-serif;font-size:	10px; border-collapse:  collapse; width: 595px;}'||utl_tcp.crlf;
         l_body_html := l_body_html||'td, th {border: 1px solid #dddddd;text-align: left;padding: 8px;width: auto; overflow: hidden; word-wrap: break-word;}'||utl_tcp.crlf;
         l_body_html := l_body_html||'tr:nth-child(even) {background-color: #dddddd;}'||utl_tcp.crlf;
         l_body_html := l_body_html||'.opttable table {width: auto;}'||utl_tcp.crlf;
         l_body_html := l_body_html||'.opttable td {border: none; padding: 0px;}'||utl_tcp.crlf;
         l_body_html := l_body_html||'.opttable tr {background-color: transparent;}'||utl_tcp.crlf;
         l_body_html := l_body_html||'</style></head>'||utl_tcp.crlf;
         l_body_html := l_body_html||'<body>'||utl_tcp.crlf;
         l_body_html := l_body_html||'<b>Her er scott/tigers frokostbestilling for '||l_order_date||'</b><br>'||utl_tcp.crlf;
         IF l_order_memo IS NOT NULL THEN
            l_body_html := l_body_html||'<b>'||l_order_memo||'</b><br>';
         END IF;

         l_body_html := l_body_html||'<table><tr><th>Bestilling</th><th>Antal</th><th>Pris</th><th>Valg</th><th>Bestilt af</th><th>Note</th></tr>';
         FOR rec_order IN (
            SELECT u1.user_name
            , o1.menu_category
            , o1.menu_name
            , o1.items_ordered
            , o1.price
            , o1.user_comment
            , o1.order_id
            FROM stlunch_users u1
            , stlunch_orders o1
            WHERE u1.user_id = o1.user_id
            AND o1.order_date = c1.order_date
            AND o1.supplier_email = c1.supplier_email
            ORDER BY 2, 3, 1
         ) LOOP
           SELECT * 
           BULK COLLECT INTO l_order_options
           FROM stlunch_order_options oo 
           WHERE oo.order_id = rec_order.order_id
           ORDER BY sort_order, description;
           l_body_html := l_body_html||'<tr>';
           l_body_html := l_body_html||'<td>'||rec_order.menu_name||'</td>';
           l_body_html := l_body_html||'<td>'||rec_order.items_ordered||'</td>';
           l_body_html := l_body_html||'<td>'||to_char(rec_order.items_ordered*rec_order.price)||'</td>';
           l_body_html := l_body_html||'<td>';
           IF l_order_options.count > 0 THEN
              l_body_html := l_body_html||'<div class="opttable"><table>';
              FOR i IN l_order_options.first..l_order_options.last LOOP
                 l_body_html := l_body_html||'<tr><td style="width: 75px;">'||l_order_options(i).description||'</td><td>'||l_order_options(i).selected||'</td></tr>';
              END LOOP;
              l_body_html := l_body_html||'</table></div>';
           END IF;
           l_body_html := l_body_html||'</td>';
           l_body_html := l_body_html||'<td>'||rec_order.user_name||'</td>';
           l_body_html := l_body_html||'<td>'||rec_order.user_comment||'</td>';
           l_body_html := l_body_html||'</tr>';
           
           l_total := l_total + (rec_order.items_ordered*rec_order.price);
         END LOOP;
         l_body_html := l_body_html||'</table>';
         l_body_html := l_body_html||'<br><b>Total for bestilling: '||TO_CHAR(l_total,'999G999D00')||' kr.</b><br>';
         l_body_html := l_body_html||'<br><b>Med venlig hilsen<br><br>Scott-Tiger</b></body></html>';
         
         send_mail(
           p_subject => c1.supplier_name||' - scott/tiger frokostbestilling til '||l_order_date
         , p_body_html => l_body_html
         , p_recipient => c1.supplier_email
      );

      END LOOP;
   END send_daily_mails;

   PROCEDURE send_month_report IS
      l_id NUMBER;
      l_body_html VARCHAR2(4000);
      l_order_date VARCHAR2(20) := TO_CHAR(LAST_DAY(ADD_MONTHS(TRUNC(sysdate),-1)),'MONTH YYYY');
      l_supplier stlunch_suppliers.supplier_name%TYPE := 'FirstRecord';
      l_total NUMBER;
   BEGIN
      l_body_html := '<html><head><meta charset="utf-8"><meta content=''text/html; charset=utf-8'' http-equiv=''Content-Type''></head><style>'||utl_tcp.crlf;
      l_body_html := l_body_html||'table {font-family: arial, sans-serif; border-collapse:  collapse; width: 100%;}'||utl_tcp.crlf;
      l_body_html := l_body_html||'td, th {border: 1px solid #dddddd;text-align: left;padding: 8px;}'||utl_tcp.crlf;
      l_body_html := l_body_html||'tr:nth-child(even) {background-color: #dddddd;}'||utl_tcp.crlf;
      l_body_html := l_body_html||'</style></head>'||utl_tcp.crlf;
      l_body_html := l_body_html||'<body>'||utl_tcp.crlf;
      l_body_html := l_body_html||'<b>Oversigt over scott/tigers frokostbestilling for '||l_order_date||'</b><br>'||utl_tcp.crlf;
      l_total     := 0;
      
      FOR c1 IN (
        SELECT supplier_name
        , to_char(order_date, 'DD.MM.YYYY') order_date
        , sum(items_ordered * price) price
        FROM stlunch_orders
        WHERE order_date BETWEEN LAST_DAY(ADD_MONTHS(TRUNC(sysdate), -2))+1 AND LAST_DAY(ADD_MONTHS(TRUNC(sysdate), -1))
        GROUP BY supplier_name, to_char(order_date, 'DD.MM.YYYY')
        ORDER BY supplier_name, order_date
      ) LOOP
         IF c1.supplier_name <> l_supplier  THEN
            IF l_supplier <> 'FirstRecord' THEN
               l_body_html := l_body_html||'</table>'||utl_tcp.crlf;
               l_body_html := l_body_html||'<br><b>Total for leverandør: '||TO_CHAR(l_total,'999G999D00')||' kr.</b><br>'||utl_tcp.crlf;
            END IF;
            l_body_html := l_body_html||'<br><b><u>Leverandør: '||c1.supplier_name||'</u></b><br>'||utl_tcp.crlf;
            l_body_html := l_body_html||'<table><tr><th>Bestilt dato</th><th>Beløb</th></tr>'||utl_tcp.crlf;
            l_supplier  := c1.supplier_name;
            l_total     := 0;
         END IF;
         l_body_html := l_body_html||'<tr><td>'||c1.order_date||'</td><td>'||c1.price||'</td></tr>'||utl_tcp.crlf;
         l_total     := l_total + c1.price;
      END LOOP;
      IF l_supplier <> 'FirstRecord' THEN
         l_body_html := l_body_html||'</table>'||utl_tcp.crlf;
         l_body_html := l_body_html|| '<br><b>Total for leverandør: '|| to_char(l_total, '999G999D00')|| ' kr.</b><br>'||utl_tcp.crlf;
      END IF;
      l_body_html := l_body_html || '<br><b>Med venlig hilsen<br><br>Frokost bestilling systemet</b>'||utl_tcp.crlf;
      l_body_html := l_body_html||'</body></html>';
      
      send_mail(
        p_subject => 'scott/tiger månedlig oversigt over frokostbestillinger for ' || l_order_date
      , p_body_html => l_body_html
      , p_recipient => null
      );
   END send_month_report;
   
   PROCEDURE send_new_password(
      p_email             stlunch_users.user_email%type
    , p_new_password      stlunch_users.passwd_enc%type
   ) IS
       l_body_html VARCHAR2(4000);
  BEGIN
      l_body_html := '<html><head><meta charset="utf-8"><meta content=''text/html; charset=utf-8'' http-equiv=''Content-Type''></head>'||utl_tcp.crlf;
      l_body_html := l_body_html||'<body>'||utl_tcp.crlf;
      l_body_html := l_body_html||'<p>Dit nye kodeord til scott/tiger frokostbestilling er: <b>'||p_new_password||'</b></p>'||utl_tcp.crlf;
      l_body_html := l_body_html || '<p>Med venlig hilsen<br>Frokost bestilling systemet</p>'||utl_tcp.crlf;
      l_body_html := l_body_html||'</body></html>';
     
      send_mail(
        p_subject => 'scott/tiger frokostbestilling nyt kodeord'
      , p_body_html => l_body_html
      , p_recipient => p_email
      , p_cc_admin  => FALSE
      );
  END send_new_password;

END stlunch_mails;
/