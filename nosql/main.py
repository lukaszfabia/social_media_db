from nosql.database.connect import MongoDB
from nosql.seeder.seeder import example_seed


if __name__ == "__main__":
    client = MongoDB()

    client.health()

    example_seed(client.db)
