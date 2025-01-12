# NoSQL

W baza w MongoDB w atlas jak będzie brakować miejsca no to trzeba iść lokalnie.

You need to create file named ".env" in this directory, which will contain: 

```bash
MONGO_URI=
DATABASE_NAME=
```

example:

```sh
MONGO_URI=mongodb+srv://<username>:<password>@cluster0.gheyk.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0
DATABASE_NAME=cluster0
```

<div style="color: red">
    <h2>Ważne</h2>
</div>

Nadajemy `typy` oraz `docstringi`. **Wiem**, że **Python** jest dynamicznie typowany i interpretera "nie obchodzi" typ przypisany np. do zmiennej, ale aby zachować **integralność danych** oraz czytelności dodajemy typy.
