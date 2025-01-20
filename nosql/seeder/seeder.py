from calendar import month
from typing import List

from pydantic import EmailStr, HttpUrl
from pymongo.database import Database
from bson import ObjectId
from datetime import datetime, timezone, timedelta, tzinfo

from ..models.articles.section import Section
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

def add_user(db: Database) -> None:
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
        if should_event_occur(0.7):
            birthday = faker.date_of_birth(minimum_age=13,
                                           maximum_age=50,
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

    # generating external_links
    external_links = []
    if should_event_occur(0.7):
        for i in range(faker.random_int(min=1, max=5)):
            external_links.append(faker.url())

    user = User(
        user_read_only=user_read_only,
        user_auth=user_auth,
        background_url=background_url,
        birthday=birthday,
        bio=bio,
        external_links=external_links,
        friends=[],
        friend_requests=[],
        followed_users=[],
        posts=[],
        articles=[],
        reactions=[],
        conversations=[],
        groups=[],
        events=[]
    )

    db[collection.USERS].insert_one(user.model_dump(by_alias=True))
    print("User created successfully.")

def add_article(db: Database) -> None:
    faker = Faker()

    user = db[collection.USERS].find_one()

    title = faker.text(max_nb_chars=32)

    if should_event_occur(0.7):
        is_public = True
    else:
        is_public = False

    # generating hashtags
    if should_event_occur(0.9):
        hashtags = faker.words(nb=faker.random_int(min=1, max=5), ext_word_list=None)
    else:
        hashtags = None

    # generating sections
    sections = []
    if should_event_occur(0.5):
        for i in range(faker.random_int(min=1, max=5)):
            sections.append(Section(header=faker.text(max_nb_chars=32),
                                    content=faker.text(max_nb_chars=256))
            )

    article = Article(
        user=user["user_read_only"],
        title=title,
        is_public=is_public,
        hashtags=hashtags,
        sections=sections,
    )

    db[collection.ARTICLES].insert_one(article.model_dump(by_alias=True))

    if 'articles' not in user or user['articles'] is None:
        db[collection.USERS].update_one(
            {"_id": user["_id"]},
            {"$set": {"articles": []}}
        )
    db[collection.USERS].update_one({"_id": user["_id"]}, {"$push": {"articles": article.model_dump(by_alias=True)}})
    print("Article created successfully.")
