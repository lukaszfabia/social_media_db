from .database.connect import MongoDB
from .seeder.seeder import *
from pymongo.database import Database


def generate(db: Database, how_many: int, add_function):
    for _ in range(how_many):
        add_function(db=db)


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
