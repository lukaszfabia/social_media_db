from .database.connect import MongoDB
from .seeder.seeder import *
from pymongo.database import Database
from .queries.queries import *


def generate(db: Database, how_many: int, add_function):
    for _ in range(how_many):
        add_function(db=db)

if __name__ == "__main__":
    client = MongoDB()

    client.health()

    # generate(db=client.db, how_many=500, add_function=add_user)
    # add_followed_users(db=client.db, max_number_of_followed_users=10)
    # add_friends_requests_and_friends(db=client.db, max_number_of_requests=20)
    # generate(db=client.db, how_many=200, add_function=add_post)
    # generate(db=client.db, how_many=100, add_function=add_event)
    # generate(db=client.db, how_many=500, add_function=add_article)
    # generate(db=client.db, how_many=100, add_function=add_page)
    # add_conversations(db=client.db, max_conversations=10)
    # generate(db=client.db, how_many=10, add_function=add_group)

    
    print("\n1: User with most articles:\n", run_aggregation(client.db, *user_with_most_articles()))
    print("\n2: Articles of most popular author:\n", run_aggregation(client.db, *articles_of_most_popular_author()))
    print("\n3: Longest articles from last 10days:\n", run_aggregation(client.db, *longest_articles_from_last_10days()))
    print("\n4: Average number of friends:\n", run_aggregation(client.db, *avg_friends()))
    print("\n5: Average reaction of each type per post:\n", run_aggregation(client.db, *avg_each_reaction_per_post()))
    print("\n6: Events with friends going:\n", run_aggregation(client.db, *events_with_friends_going()))
    print("\n7: Users with mutual friends:\n", run_aggregation(client.db, *users_with_mutual_friends()))
    print("\n8: Most viewed tags:\n", run_aggregation(client.db, *tags_most_viewed()))
    print("\n9: User with most avg reactions per post:\n", run_aggregation(client.db, *user_with_most_avg_reactions_per_post()))
    print("\n10: Last message from each conversation of a user:\n", run_aggregation(client.db, *last_message_from_conversation()))
