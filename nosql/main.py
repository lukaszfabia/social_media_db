from .database.connect import MongoDB
from .seeder.seeder import *
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

def generate_posts(db: Database, how_many: int):
    for i in range(how_many):
        add_post(db=db)

def generate_events(db: Database, how_many: int):
    for i in range(how_many):
        add_event(db=db)

def generate_pages(db: Database, how_many: int):
    for i in range(how_many):
        add_page(db=db)


if __name__ == "__main__":
    client = MongoDB()

    client.health()

    # generate_users(db=client.db, how_many=2000)
    # add_followed_users(db=client.db, max_number_of_followed_users=10)
    # generate_articles(db=client.db, how_many=2000)
    # generate_groups(db=client.db, how_many=100)
    # add_friends_requests_and_friends(db=client.db, max_number_of_requests=20)
    # generate_posts(db=client.db, how_many=1000)
    # generate_events(db=client.db, how_many=500)
    # generate_pages(db=client.db, how_many=200)
    # add_conversations(db=client.db, max_conversations=5)