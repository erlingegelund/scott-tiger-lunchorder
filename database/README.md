# Oprettelse af database objekter til frokostbetillingssystemet

Opret schema og tildel rettigheder angivet i kommentar øverst i init.sql

## Rækkefølge for afvikling af scripts i denne folder:
1. init.sql
2. seed-data.sql
3. stlunch_mails.sql
4. stlunch_api.sql
5. trigger.sql
6. ords.sql
7. oauth.sql

Hver gang der ændres i ords.sql skal oauth.sql afvikles efterfølgende.
