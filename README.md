# Setup bazy danych w PostgreSQL

## Skrypt `setup.sh`

_jeśli ktoś umie w `batcha` to można sobie przepisać :blush:_

### Co robi skrypt

- sprawdza czy macie zainstalowane kolejno `docker`, `docker-compose`

- jak nie macie to instaluje
- sprawdza czy macie plik `.env` (zmienne środowiskowe) jak nie to tworzy template

Jak wypełnić sobie plik

### Co do czego jest w pliku `.env`

```plaintext
// passy do zalogowania na głównej stronie 
PGADMIN_DEFAULT_EMAIL=
PGADMIN_DEFAULT_PASSWORD=

// set up to bazy
POSTGRES_USER=
POSTGRES_PASSWORD=
POSTGRES_DB=
```

### Co dalej

No re-run skryptu i lecimy na **<http://localhost:5050>**, powinno przekierować do strony z logowaniem, po zalogowaniu, add new server.

1. General/Name -> POSTGRES_DB

2. `docker inspect social_media_postgres`, szukamy ipv4 (172.0*)
3. Connection/Host name -> to jest ipv4 tego kontenera
4. Connection/Username -> POSTGRES_USER
5. Connection/Password -> POSTGRES_PASSWORD
6. Port w Connection zostwiamy w spokoju niech będzie _5432_
