from pymongo.database import Database
from bson import ObjectId
from datetime import datetime, timezone
from nosql.models.persons.user import User, UserAuth, UserReadOnly
from nosql.models.events.location import ShortLocation
from nosql.models.articles.article import Article
from nosql.models.posts.post import Post
from nosql.models.communication.message import Message
from nosql.models.enums import UserPrivilege
from .collection import collection


def example_seed(db: Database) -> None:
    """Fill with example data

    Args:
        db (Database): db connection
    """
    user1 = User(
        user_read_only=UserReadOnly(name="John Doe"),
        user_auth=UserAuth(
            email="john.doe@example.com",
            password="password123",
            last_login=datetime.now(tz=timezone.utc),
            user_privilege=UserPrivilege.User,
            is_verified=True,
        ),
        birthday=datetime(1990, 1, 1, tzinfo=timezone.utc),
        bio="This is John's bio",
    )

    user2 = User(
        user_read_only=UserReadOnly(name="Jane Smith"),
        user_auth=UserAuth(
            email="jane.smith@example.com",
            password="password123",
            last_login=datetime.now(tz=timezone.utc),
            user_privilege=UserPrivilege.Admin,
            is_verified=True,
        ),
        birthday=datetime(1992, 2, 2, tzinfo=timezone.utc),
        bio="This is Jane's bio",
    )

    db[collection.USERS].insert_one(user1.model_dump(by_alias=True))
    db[collection.USERS].insert_one(user2.model_dump(by_alias=True))

    article1 = Article(
        user=user1.user_read_only,
        title="Sample Article 1",
        is_public=True,
        hashtags=["sample", "article"],
    )

    article2 = Article(
        user=user2.user_read_only,
        title="Sample Article 2",
        is_public=False,
        hashtags=["example", "article"],
    )

    db[collection.ARTICLES].insert_many(
        [article1.model_dump(by_alias=True),
         article2.model_dump(by_alias=True)]
    )

    post1 = Post(
        user=user1.user_read_only,
        title="Sample Post 1",
        content="This is the content of sample post 1",
        is_public=True,
        hashtags=["sample", "post"],
        group_id=ObjectId(),
        location=ShortLocation(longitude=21.37, latitude=3.13),
    )

    post2 = Post(
        user=user2.user_read_only,
        title="Sample Post 2",
        content="This is the content of sample post 2",
        is_public=False,
        hashtags=["example", "post"],
        group_id=ObjectId(),
        location=ShortLocation(longitude=21.37, latitude=3.13),
    )

    db[collection.POSTS].insert_many(
        [post1.model_dump(by_alias=True), post2.model_dump(by_alias=True)]
    )

    message1 = Message(user=user1.user_read_only,
                       content="This is a sample message")

    message2 = Message(
        user=user2.user_read_only, content="This is another sample message"
    )

    db[collection.MESSAGES].insert_many(
        [message1.model_dump(by_alias=True),
         message2.model_dump(by_alias=True)]
    )

    print("Seeding completed successfully.")
