from pymongo import MongoClient
from bson import ObjectId
from datetime import datetime, timezone
from models.persons.user import User, UserAuth, UserReadOnly
from models.articles.article import Article
from models.posts.post import Post
from models.communication.message import Message
from models.enums import UserPrivilege


def seed(db: MongoClient) -> None:
    # Create sample users
    user1 = User(
        user_read_only=UserReadOnly(
            name="John Doe",
            picture_url=None
        ),
        user_auth=UserAuth(
            email="john.doe@example.com",
            password="password123",
            provider=None,
            last_login=datetime.now(tz=timezone.utc),
            user_privilege=UserPrivilege.User,
            is_verified=True
        ),
        background_url=None,
        birthday=datetime(1990, 1, 1, tzinfo=timezone.utc),
        bio="This is John's bio",
        external_links=None,
        friends=None,
        friend_requests=None,
        followed_users=None,
        posts=None,
        articles=None,
        reactions=None,
        conversations=None,
        groups=None,
        events=None
    )

    user2 = User(
        user_read_only=UserReadOnly(
            name="Jane Smith",
            picture_url=None
        ),
        user_auth=UserAuth(
            email="jane.smith@example.com",
            password="password123",
            provider=None,
            last_login=datetime.now(tz=timezone.utc),
            user_privilege=UserPrivilege.Admin,
            is_verified=True
        ),
        background_url=None,
        birthday=datetime(1992, 2, 2, tzinfo=timezone.utc),
        bio="This is Jane's bio",
        external_links=None,
        friends=None,
        friend_requests=None,
        followed_users=None,
        posts=None,
        articles=None,
        reactions=None,
        conversations=None,
        groups=None,
        events=None
    )

    # Insert users into the database
    db.users.insert_one(user1.dict(by_alias=True))
    db.users.insert_one(user2.dict(by_alias=True))

    # Create sample articles
    article1 = Article(
        id=ObjectId(),
        user=user1,
        title="Sample Article 1",
        is_public=True,
        hashtags=["sample", "article"],
        sections=None
    )

    article2 = Article(
        id=ObjectId(),
        user=user2,
        title="Sample Article 2",
        is_public=False,
        hashtags=["example", "article"],
        sections=None
    )

    # Insert articles into the database
    db.articles.insert_many([article1.dict(), article2.dict()])

    # Create sample posts
    post1 = Post(
        id=ObjectId(),
        user=user1,
        title="Sample Post 1",
        content="This is the content of sample post 1",
        is_public=True,
        hashtags={"sample", "post"},
        group_id=ObjectId(),
        location=None
    )

    post2 = Post(
        id=ObjectId(),
        user=user2,
        title="Sample Post 2",
        content="This is the content of sample post 2",
        is_public=False,
        hashtags={"example", "post"},
        group_id=ObjectId(),
        location=None
    )

    # Insert posts into the database
    db.posts.insert_many([post1.dict(), post2.dict()])

    # Create sample messages
    message1 = Message(
        id=ObjectId(),
        author=user1.id,
        content="This is a sample message"
    )

    message2 = Message(
        id=ObjectId(),
        author=user2.id,
        content="This is another sample message"
    )

    # Insert messages into the database
    db.messages.insert_many([message1.dict(), message2.dict()])

    print("Seeding completed successfully.")
