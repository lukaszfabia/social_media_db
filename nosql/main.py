from .database.connect import MongoDB
from .seeder.seeder import add_user, add_article
from pymongo.database import Database

def generate_users(db: Database, how_many: int):
    for i in range(how_many):
        add_user(db=db)

def generate_articles(db: Database, how_many: int):
    for i in range(how_many):
        add_article(db=db)


if __name__ == "__main__":
    client = MongoDB()

    client.health()


    #generate_users(db=client.db, how_many=10000)
    generate_articles(db=client.db, how_many=10000)