from .database.connect import MongoDB
from .seeder.seeder import *
from pymongo.database import Database


def generate(db: Database, how_many: int, add_function):
    for _ in range(how_many):
        add_function(db=db)


if __name__ == "__main__":
    client = MongoDB()

    client.health()

    generate(db=client.db, how_many=2000, add_function=add_user)
    add_followed_users(db=client.db, max_number_of_followed_users=10)
    generate(db=client.db, how_many=2000, add_function=add_article)
    generate(db=client.db, how_many=100, add_function=add_group)
    add_friends_requests_and_friends(db=client.db, max_number_of_requests=20)
    generate(db=client.db, how_many=1000, add_function=add_post)
    generate(db=client.db, how_many=500, add_function=add_event)
    generate(db=client.db, how_many=200, add_function=add_page)
    add_conversations(db=client.db, max_conversations=10)
