from .database.connect import MongoDB
from .seeder.seeder import example_seed, addUser
from pymongo.database import Database

def generate_users(db: Database, how_many: int):
    for i in range(how_many):
        addUser(db=db)


if __name__ == "__main__":
    client = MongoDB()

    client.health()

    generate_users(db=client.db, how_many=5000)