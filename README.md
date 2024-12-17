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

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Launch Package",
      "type": "go",
      "request": "launch",
      "mode": "auto",
      "program": "${workspaceFolder}/sql/db_manager/main.go"
    }
  ]
}
```

w pierwszej kolejności warto

> cd db_manager

uwaga na zapisanie pliku .env jako "UTF with BOM" - trzeba zwykły UTF

jeśli chcecie jeszcze raz zasetupować bazę, to należy najpierw wykonać

> make clear
> do wyczyszczenia potrzebnych danych

aby w ogóle działało, trzeba pamiętać, aby WSL 2 działał i docker desktop był włączony

jeśli jest błąd migracji, to trzeba w main.go odkomentować linijkę z dodawaniem enumów
