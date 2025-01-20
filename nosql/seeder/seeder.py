from calendar import month

from pydantic import EmailStr
from pymongo.database import Database
from bson import ObjectId
from datetime import datetime, timezone, timedelta, tzinfo
from ..models.persons.user import User, UserAuth, UserReadOnly
from ..models.events.location import ShortLocation
from ..models.articles.article import Article
from ..models.posts.post import Post
from ..models.communication.message import Message
from ..models.enums import UserPrivilege
from .collection import collection
from faker import Faker

def should_event_occur(probability: float) -> bool:
    faker = Faker()
    return faker.random.random() < probability

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

def addUser(db: Database) -> None:
    faker = Faker()

    # generating user_read_only
    if should_event_occur(0.7):
        user_read_only = UserReadOnly(name=faker.name(),
                                      picture_url=faker.image_url())
    else:
        user_read_only = UserReadOnly(name=faker.name())

    # generating user_auth
    email = faker.email()
    password = faker.password()
    provider = email.split('@')[1]
    if should_event_occur(0.7):
        last_login = faker.date_time_between_dates(datetime_start=datetime.now(tz=timezone.utc) - timedelta(days=7),
                                                   datetime_end=datetime.now(tz=timezone.utc))
    else:
        last_login = faker.date_time_between_dates(datetime_start=datetime(2024, 1, 1),
                                                   datetime_end=datetime.now(tz=timezone.utc))
    if should_event_occur(0.999):
        user_privilege = UserPrivilege.User
    else:
        if should_event_occur(0.9):
            user_privilege = UserPrivilege.Mod
        else:
            user_privilege = UserPrivilege.Admin

    if should_event_occur(0.99):
        is_verified = True
    else:
        is_verified = False

    user_auth = UserAuth(
        email=email,
        password=password,
        provider=provider,
        last_login=last_login,
        user_privilege=user_privilege,
        is_verified=is_verified,
    )

    # generating background_url
    if should_event_occur(0.5):
        background_url = faker.image_url()
    else:
        background_url = None

    # generating birthday
    if should_event_occur(0.9):
        if should_event_occur(0.9):
            birthday = faker.date_of_birth(minimum_age=13,
                                           maximum_age=40,
                                           tzinfo=timezone.utc)
        else:
            birthday = faker.date_of_birth(minimum_age=13,
                                           maximum_age=100,
                                           tzinfo=timezone.utc)
    else:
        birthday = None

    # generating bio
    if should_event_occur(0.4):
        bio = faker.text(max_nb_chars=512)
    else:
        bio = ""

    user = User(
        user_read_only=user_read_only,
        user_auth=user_auth,
        background_url=background_url,
        birthday=birthday,
        bio=bio,
    )

    db[collection.USERS].insert_one(user.model_dump(by_alias=True))
    print("User created successfully.")
