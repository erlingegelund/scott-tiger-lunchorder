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
      
      FOR r_cc IN (SELECT user_email FROM stlunch_users WHERE administrator_yn = 'Y' AND nvl(inactive_yn,'N') = 'N') LOOP
         UTL_SMTP.RCPT(c, r_cc.user_email);
         IF l_cc IS NULL THEN
            l_cc := r_cc.user_email;
         ELSE
            l_cc := l_cc||';'||r_cc.user_email;
         END IF;
      END LOOP;

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
      l_id NUMBER;
      l_body_html VARCHAR2(4000);
      l_order_date VARCHAR2(10) := TO_CHAR(sysdate,'DD.MM.YYYY');
      l_supplier stlunch_suppliers.supplier_name%TYPE := 'FirstRecord';
      l_total NUMBER;
   BEGIN
      null;
/*      
      FOR c1 in (
      SELECT sup.supplier_id,
         sup.supplier_name,
         sup.mail_address
      FROM suppliers sup,
         sm_group_lookup sgl,
         smoerebrod smb,
         lunch_order lo,
         lo_row lr
      WHERE sup.supplier_id = sgl.supplier_id
      AND sgl.sm_group_id = smb.sm_group_id
      AND lr.lo_row_item  = smb.sm_id
      AND lo.order_id     = lr.lo_order_id
      AND TRUNC(lo.order_date) = TRUNC(sysdate)
      GROUP BY sup.supplier_id,
         sup.supplier_name,
         sup.mail_address
      ) LOOP
         l_body_html := '<html><head><style>';
         l_body_html := l_body_html||'table {font-family: arial, sans-serif;font-size:	10px; border-collapse:  collapse; width: 500px;}';
         l_body_html := l_body_html||'td, th {border: 1px solid #dddddd;text-align: left;padding: 8px;width: auto; overflow: hidden; word-wrap: break-word;}';
         l_body_html := l_body_html||'tr:nth-child(even) {background-color: #dddddd;}';
         l_body_html := l_body_html||'</style></head>';
         l_body_html := l_body_html||'<body>';
         l_body_html := l_body_html||'<b>Her er Scott/Tigers frokostbestilling for '||l_order_date||'</b><br>';
         IF c1.supplier_id = 1 THEN
         l_body_html := l_body_html||'<b>Husk grovbrød til salaterne</b><br>';
         l_body_html := l_body_html||'<table><tr><th>Bestilling</th><th>Antal</th><th>Pris</th><th>Note</th></tr>';
         ELSIF c1.supplier_id = 2 THEN
         l_body_html := l_body_html||'<table><tr><th>Bestilling</th><th>Antal</th><th>Pris</th><th>Brød</th><th>Bund</th><th>Dressing</th><th>Kød</th><th>Tilbehør</th></tr>';
         ELSE
         l_body_html := l_body_html||'<table><tr><th>Bestilling</th><th>Antal</th><th>Pris</th><th>Note</th></tr>';
         END IF;
         l_total := 0;
         FOR c2 IN (
            SELECT smb.name,
               APEX_UTIL.GET_FIRST_NAME(p_username => APEX_UTIL.GET_USERNAME(lo.ordered_by)) || ' '||APEX_UTIL.GET_LAST_NAME(p_username => APEX_UTIL.GET_USERNAME(lo.ordered_by)) ordered_by,
               lr.lo_row_qty,
               lr.stor price,
               lr.lo_adm note,
               lr.attribute1,
               lr.attribute2,
               lr.attribute3,
               lr.attribute4,
               lr.attribute5
            FROM suppliers sup,
               sm_group_lookup sgl,
               smoerebrod smb,
               lunch_order lo,
               lo_row lr
            WHERE sup.supplier_id = sgl.supplier_id
            AND sgl.sm_group_id = smb.sm_group_id
            AND lr.lo_row_item  = smb.sm_id
            AND lo.order_id     = lr.lo_order_id
            AND TRUNC(lo.order_date) = TRUNC(sysdate)
            AND sup.supplier_id = c1.supplier_id
            ORDER BY sgl.sm_group,1,4
         ) LOOP
            IF c1.supplier_id = 1 THEN
               l_body_html := l_body_html||'<tr><td>'||c2.name||'</td><td>'||c2.lo_row_qty||'</td><td>'||c2.price||'</td><td>'||c2.note||'</td></tr>';
            ELSIF c1.supplier_id = 2 THEN
               l_body_html := l_body_html||'<tr><td>'||c2.name||' til '||c2.ordered_by||'</td><td>'||c2.lo_row_qty||'</td><td>'||c2.price||'</td><td>'||c2.attribute1||'</td><td>'||c2.attribute2||'</td><td>'||c2.attribute3||'</td><td>'||c2.attribute4||'</td><td>'||c2.attribute5||'</td></tr>';
            ELSE
               l_body_html := l_body_html||'<tr><td>'||c2.name||' til '||c2.ordered_by||'</td><td>'||c2.lo_row_qty||'</td><td>'||c2.price||'</td><td>'||c2.attribute1||'</td><td>'||c2.attribute2||'</td><td>'||c2.attribute3||'</td><td>'||c2.attribute4||'</td><td>'||c2.attribute5||'</td></tr>';
            END IF;
            l_total     := l_total + c2.price;
         END LOOP;
         l_body_html := l_body_html||'</table></body>';
         l_body_html := l_body_html||'<br><b>Total for bestilling: '||TO_CHAR(l_total,'999G999D00')||' kr.</b><br>';
         l_body_html := l_body_html||'<br><b>Med venlig hilsen<br><br>Scott-Tiger</b></html>';
         wwv_flow_api.set_security_group_id;
         l_id := APEX_MAIL.SEND(
            p_to        =>  c1.mail_address,
            p_from      => 'info@scott-tiger.dk',
            p_cc        => 'helle.bohn@scott-tiger.dk,pia.molgaard@scott-tiger.dk, maria.Kragh@scott-tiger.dk',
            p_subj      => c1.supplier_name||' - Scott/Tiger frokostbestilling til '||l_order_date,
            p_body      => 'Fejl i mail layout. Venligst send mail retur til Helle Bohn, Scott/Tiger',
            p_body_html => l_body_html
         );
         APEX_MAIL.PUSH_QUEUE;
         COMMIT;
      END LOOP;
      l_body_html := '<html><head><style>';
      l_body_html := l_body_html||'table {font-family: arial, sans-serif; border-collapse:  collapse; width: 100%;}';
      l_body_html := l_body_html||'td, th {border: 1px solid #dddddd;text-align: left;padding: 8px;}';
      l_body_html := l_body_html||'tr:nth-child(even) {background-color: #dddddd;}';
      l_body_html := l_body_html||'</style></head>';
      l_body_html := l_body_html||'<body>';
      l_body_html := l_body_html||'<b>Oversigt over Scott/Tigers frokostbestilling for '||l_order_date||'</b><br>';
      l_total     := 0;
      FOR c3 IN (
         SELECT supplier_name,
            APEX_UTIL.GET_FIRST_NAME(p_username => APEX_UTIL.GET_USERNAME(lo.ordered_by)) || ' '||APEX_UTIL.GET_LAST_NAME(p_username => APEX_UTIL.GET_USERNAME(lo.ordered_by)) ordered_by,
            sgl.sm_group name,
            SUM(lr.lo_row_qty) lo_row_qty,
            SUM(lr.stor) price
         FROM suppliers sup,
            sm_group_lookup sgl,
            smoerebrod smb,
            lunch_order lo,
            lo_row lr
            -- ,sidedish sd
         WHERE sup.supplier_id = sgl.supplier_id
         AND sgl.sm_group_id = smb.sm_group_id
         AND lr.lo_row_item  = smb.sm_id
         AND lo.order_id     = lr.lo_order_id
         AND TRUNC(lo.order_date) = TRUNC(sysdate)
         GROUP BY  supplier_name,
            APEX_UTIL.GET_FIRST_NAME(p_username => APEX_UTIL.GET_USERNAME(ordered_by)) || ' '||APEX_UTIL.GET_LAST_NAME(p_username => APEX_UTIL.GET_USERNAME(ordered_by)),
            sgl.sm_group
         ORDER BY 1,2
      ) LOOP
         IF c3.supplier_name <> l_supplier  THEN
            IF l_supplier <> 'FirstRecord' THEN
               l_body_html := l_body_html||'</table>';
               l_body_html := l_body_html||'<br><b>Total for leverandør: '||TO_CHAR(l_total,'999G999D00')||' kr.</b><br>';
            END IF;
            l_body_html := l_body_html||'<br><b><u>leverandør: '||c3.supplier_name||'</u></b><br>';
            l_body_html := l_body_html||'<table><tr><th>Bestilt af</th><th>Bestilling</th><th>Antal</th><th>Pris</th></tr>';
            l_supplier  := c3.supplier_name;
            l_total     := 0;
         END IF;
         l_body_html := l_body_html||'<tr><td>'||c3.ordered_by||'</td><td>'||c3.name||'</td><td>'||c3.lo_row_qty||'</td><td>'||c3.price||'</td></tr>';
         l_total     := l_total + c3.price;
      END LOOP;
      l_body_html := l_body_html||'</table></body>';
      l_body_html := l_body_html||'<br><b>Total for leverandør: '||TO_CHAR(l_total,'999G999D00')||' kr.</b><br>';
      l_body_html := l_body_html||'<br><b>Med venlig hilsen<br><br>Frokost bestilling systemet</b></html>';
      wwv_flow_api.set_security_group_id;
      l_id := APEX_MAIL.SEND(
         p_to        => 'pia.molgaard@scott-tiger.dk',
         p_from      => 'info@scott-tiger.dk',
         p_subj      => 'Scott/Tiger oversigt over frokostbestilling for '||l_order_date,
         p_body      => 'Fejl i mail layout. Venligst send mail retur til Helle Bohn, Scott/Tiger',
         p_body_html => l_body_html
      );
      APEX_MAIL.PUSH_QUEUE;
      COMMIT;
*/      
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
      l_body_html := l_body_html||'<b>Oversigt over Scott/Tigers frokostbestilling for '||l_order_date||'</b><br>'||utl_tcp.crlf;
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
        p_subject => 'Scott/Tiger månedlig oversigt over frokostbestillinger for ' || l_order_date
      , p_body_html => l_body_html
      , p_recipient => null
      );
   END send_month_report;
END stlunch_mails;
/