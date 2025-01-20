from .database.connect import MongoDB
from .seeder.seeder import add_user, add_article, add_group
from pymongo.database import Database

def generate_users(db: Database, how_many: int):
    for i in range(how_many):
        add_user(db=db)

def generate_articles(db: Database, how_many: int):
    for i in range(how_many):
        add_article(db=db)

def generate_groups(db: Database, how_many: int):
    for i in range(how_many):
        add_group(db=db)


if __name__ == "__main__":
    client = MongoDB()

    client.health()

    # generate_users(db=client.db, how_many=1000)
    # generate_articles(db=client.db, how_many=1000)
    generate_groups(db=client.db, how_many=50)