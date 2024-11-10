# gORM

## Opis plików i modułów

`main.go` - główny plik, który kompilujemy

`models/` - moduł z tabelami z bazy danych oraz enumami używanymi w bazie

`database` - moduł zawierający funkcje służące do łączenia się z bazą danych, migracją tabel oraz funkcjami zawierającymi surowy **SQL**.

`seeder` - moduł zawierający funkcje do generowania fake danych

`faker` - moduł zawierający funckje umożliwiające tworzenie własnych sztucznych danych np. Tytuł strony

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