# gORM

## Wymagania

- docker
- docker-compose

Do odpalenia polecam użyć **db_manager/Makefile**:

```bash
make docker-run
make run
```

## Opis plików i modułów

`models/` - moduł z tabelami z bazy danych oraz enumami używanymi w bazie

`database/` - moduł zawierający funkcje służące do łączenia się z bazą danych, migracją tabel oraz funkcjami zawierającymi surowy **SQL** oraz zawierający service generujący dane do bazy.

`faker/` - moduł zawierający funckje umożliwiające tworzenie własnych sztucznych danych np. Tytuł strony

## Porady

można użyć takiego launch.json:

```
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Launch Package",
            "type": "go",
            "request": "launch",
            "mode": "auto",
            "program": "${workspaceFolder}/db_manager/main.go"
        }
    ]
}
```
