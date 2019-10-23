# scott-tiger-lunchorder
## Scott/Tiger Frokostbestilling i VueJS og Java backend

Nyt forkostbestillingssystem bygget med VueJS som front-end og Oracle ORDS backend.
Vi anvender en top-down model, hvor vi bygger front-end først og mock'er data.

Authentication eksempel: [https://github.com/cornflourblue/vue-basic-authentication-example]

Der udestår:
  * OAuth2 
  * Rapport for bruger over en periode
  * Månedrapport på e-mail til administratorer
  * e-mail til leverandørerne

## Installer Oracle 18c XE:
firewall-cmd --zone=public --permanent --add-port=1521/tcp

## Installer Apache HTTP Server og start som service
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd

## Opret reverse proxy konfiguration
opret fil /etc/httpd/conf.d/default-site.conf med inhold:
```
<VirtualHost *:80>
    ProxyPreserveHost On

    ProxyPass /ords http://127.0.0.1:8080/ords/ retry=0
    ProxyPassReverse /ords http://127.0.0.1:8080/ords/
</VirtualHost>
```
## tillad Apache at fungere som reverse proxy i SELinux
/usr/sbin/setsebool -P httpd_can_network_connect 1

## �ben firewall for HTTP og Oracle Enterprise Manager:
sudo firewall-cmd --zone=public --permanent --add-service=http

## Build front-end og flyt til http doc dir