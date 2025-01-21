from calendar import month
from typing import List

from pydantic import EmailStr, HttpUrl
from pymongo.database import Database
from bson import ObjectId
from datetime import datetime, timezone, timedelta, tzinfo

from ..models.articles.section import Section
from ..models.events.event import Event
from ..models.persons.user import User, UserAuth, UserReadOnly
from ..models.events.location import ShortLocation, Location, Address
from ..models.articles.article import Article
from ..models.posts.comment import Comment
from ..models.posts.post import Post
from ..models.communication.message import Message
from ..models.enums import UserPrivilege, FriendRequestStatus
from .collection import collection
from faker import Faker

from ..models.posts.reaction import REACTION_TYPE_LIST, ReactionType, Reaction


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

    user = db[collection.USERS].aggregate([{"$sample": {"size": 1}}]).next()

    title = faker.text(max_nb_chars=32)

    if should_event_occur(0.7):
        is_public = True
    else:
        is_public = False

    # generating hashtags
    if should_event_occur(0.9):
        hashtags = faker.words(nb=faker.random_int(min=1, max=5), ext_word_list=None)
    else:
        hashtags = []

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

    result = db[collection.ARTICLES].insert_one(article.model_dump(by_alias=True))
    article_id = result.inserted_id
    db[collection.USERS].update_one({"_id": user["_id"]}, {"$push": {"articles": article_id}})
    print("Article created successfully.")

def add_group(db: Database) -> None:
    faker = Faker()

    name = faker.text(max_nb_chars=32)
    members = []

    random_users = db[collection.USERS].aggregate([{"$sample": {"size": faker.random_int(min=1, max=200)}}])
    for user in random_users:
        members.append(user)

    members_ids = [member["_id"] for member in members]
    group = {
        "name": name,
        "members": members_ids,
        "posts": []
    }

    result_group = db[collection.GROUP].insert_one(group)
    group_id = result_group.inserted_id
    for member_id in members_ids:
        db[collection.USERS].update_one({"_id": member_id}, {"$push": {"groups": group_id}})

    # generating posts
    for i in range(faker.random_int(min=0, max=20)):
        user = members[faker.random_int(min=0, max=len(members) - 1)]
        title = faker.text(max_nb_chars=128)
        content = faker.text(max_nb_chars=512)
        is_public = True
        if should_event_occur(0.9):
            hashtags = faker.words(nb=faker.random_int(min=1, max=5), ext_word_list=None)
        else:
            hashtags = []
        if should_event_occur(0.2):
            location = ShortLocation(latitude=faker.random.uniform(0, 90), longitude=faker.random.uniform(-180, 180))
        else:
            location = ShortLocation(latitude=0, longitude=0)
        post = Post(
            user=user["user_read_only"],
            title=title,
            content=content,
            is_public=is_public,
            hashtags=hashtags,
            group_id=group_id,
            location=location
        )
        result_post = db[collection.POSTS].insert_one(post.model_dump(by_alias=True))
        post_id = result_post.inserted_id
        db[collection.GROUP].update_one({"_id": group["_id"]}, {"$push": {"posts": post_id}})
        db[collection.USERS].update_one({"_id": user["_id"]}, {"$push": {"posts": post_id}})

        # generating reactions
        for i in range(faker.random_int(min=0, max=20)):
            user = members[faker.random_int(min=0, max=len(members) - 1)]
            reaction_type = ReactionType(faker.random_element(elements=REACTION_TYPE_LIST))
            reaction = Reaction(
                user=user["user_read_only"],
                post_id=post_id,
                reaction=reaction_type
            )
            result_reaction = db[collection.REACTIONS].insert_one(reaction.model_dump(by_alias=True))
            reaction_id = result_reaction.inserted_id
            db[collection.USERS].update_one({"_id": user["_id"]}, {"$push": {"reactions": reaction_id}})

        # generating comments
        for i in range(faker.random_int(min=0, max=10)):
            user = members[faker.random_int(min=0, max=len(members) - 1)]
            content = faker.text(max_nb_chars=256)
            media = []
            if should_event_occur(0.5):
                for i in range(faker.random_int(min=1, max=5)):
                    media.append(faker.image_url())
            comment = Comment(
                user=user["user_read_only"],
                post_id=post_id,
                content=content,
                media=media
            )
            result_comment = db[collection.COMMENTS].insert_one(comment.model_dump(by_alias=True))
            comment_id = result_comment.inserted_id
            db[collection.USERS].update_one({"_id": user["_id"]}, {"$push": {"comments": comment_id}})

    print("Group created successfully.")

def add_friends_requests_and_friends(db: Database, max_number_of_requests: int = 20) -> None:
    faker = Faker()

    users = list(db[collection.USERS].find())
    for user in users:
        for i in range(faker.random_int(min=0, max=max_number_of_requests)):
            friend = db[collection.USERS].aggregate([{"$sample": {"size": 1}}]).next()
            if friend["_id"] != user["_id"] and friend["_id"] not in user["friends"] and friend["_id"] not in user["friend_requests"]:
                status = FriendRequestStatus(faker.random_element(elements=["pending", "rejected", "accepted"]))
                friend_request = {
                    "sender_id": user["_id"],
                    "receiver_id": friend["_id"],
                    "status": status
                }
                result_request = db[collection.FRIEND_REQUESTS].insert_one(friend_request)
                request_id = result_request.inserted_id
                db[collection.USERS].update_one({"_id": user["_id"]}, {"$push": {"friend_requests": request_id}})
                if status == "accepted":
                    db[collection.USERS].update_one({"_id": user["_id"]}, {"$push": {"friends": friend["_id"]}})
                    db[collection.USERS].update_one({"_id": friend["_id"]}, {"$push": {"friends": user["_id"]}})
        print("Friend requests and friends created successfully.")

def add_post(db: Database):
    faker = Faker()

    user = db[collection.USERS].aggregate([{"$sample": {"size": 1}}]).next()
    title = faker.text(max_nb_chars=128)
    content = faker.text(max_nb_chars=512)
    if should_event_occur(0.9):
        is_public = True
    else:
        is_public = False
    if should_event_occur(0.9):
        hashtags = faker.words(nb=faker.random_int(min=1, max=5), ext_word_list=None)
    else:
        hashtags = []
    if should_event_occur(0.2):
        location = ShortLocation(latitude=faker.random.uniform(0, 90), longitude=faker.random.uniform(-180, 180))
    else:
        location = ShortLocation(latitude=0, longitude=0)
    post = Post(
        user=user["user_read_only"],
        title=title,
        content=content,
        is_public=is_public,
        hashtags=hashtags,
        group_id=None,
        location=location
    )
    result_post = db[collection.POSTS].insert_one(post.model_dump(by_alias=True))
    post_id = result_post.inserted_id
    db[collection.USERS].update_one({"_id": user["_id"]}, {"$push": {"posts": post_id}})
    print("Post created successfully.")

    # generating reactions
    for i in range(faker.random_int(min=0, max=20)):
        if is_public:
            reaction_user = db[collection.USERS].aggregate([{"$sample": {"size": 1}}]).next()
        else:
             reaction_user = db[collection.USERS].find_one({"_id": user["friends"][faker.random_int(min=0, max=len(user["friends"]) - 1)]})
        reaction_type = ReactionType(faker.random_element(elements=REACTION_TYPE_LIST))
        reaction = Reaction(
            user=reaction_user["user_read_only"],
            post_id=post_id,
            reaction=reaction_type
        )
        result_reaction = db[collection.REACTIONS].insert_one(reaction.model_dump(by_alias=True))
        reaction_id = result_reaction.inserted_id
        db[collection.USERS].update_one({"_id": reaction_user["_id"]}, {"$push": {"reactions": reaction_id}})

    # generating comments
    for i in range(faker.random_int(min=0, max=10)):
        if is_public:
            comment_user = db[collection.USERS].aggregate([{"$sample": {"size": 1}}]).next()
        else:
            comment_user = db[collection.USERS].find_one({"_id": user["friends"][faker.random_int(min=0, max=len(user["friends"]) - 1)]})
        content = faker.text(max_nb_chars=256)
        media = []
        if should_event_occur(0.5):
            for i in range(faker.random_int(min=1, max=5)):
                media.append(faker.image_url())
        comment = Comment(
            user=comment_user["user_read_only"],
            post_id=post_id,
            content=content,
            media=media
        )
        result_comment = db[collection.COMMENTS].insert_one(comment.model_dump(by_alias=True))
        comment_id = result_comment.inserted_id
        db[collection.USERS].update_one({"_id": comment_user["_id"]}, {"$push": {"comments": comment_id}})

def add_followed_users(db: Database, max_number_of_followed_users: int = 10) -> None:
    faker = Faker()

    users = list(db[collection.USERS].find())
    for user in users:
        for i in range(faker.random_int(min=0, max=max_number_of_followed_users)):
            followed_user = db[collection.USERS].aggregate([{"$sample": {"size": 1}}]).next()
            if followed_user["_id"] != user["_id"] and followed_user["_id"] not in user["followed_users"]:
                db[collection.USERS].update_one({"_id": user["_id"]}, {"$push": {"followed_users": followed_user["_id"]}})
        print("Followed users created successfully.")

def add_event(db: Database, max_members: int = 100):
    faker = Faker()

    user = db[collection.USERS].aggregate([{"$sample": {"size": 1}}]).next()
    name = faker.text(max_nb_chars=32)
    desc = faker.text(max_nb_chars=512)
    s_date = faker.date_time_between_dates(datetime_start=datetime.now(tz=timezone.utc) - timedelta(days=365),
                                               datetime_end=datetime.now(tz=timezone.utc) + timedelta(days=365))
    if should_event_occur(0.5):
        f_date = s_date + timedelta(hours=faker.random_int(min=1, max=24))
    else:
        if should_event_occur(0.5):
            f_date = s_date + timedelta(days=faker.random_int(min=1, max=7))
        else:
            f_date = None

    members = []
    random_users = db[collection.USERS].aggregate([{"$sample": {"size": faker.random_int(min=0, max=max_members)}}])
    for user in random_users:
        members.append(user["_id"])

    short_location = ShortLocation(latitude=faker.random.uniform(0, 90), longitude=faker.random.uniform(-180, 180))

    city = None
    if should_event_occur(0.95):
        city = faker.city()

    country = None
    if should_event_occur(0.95):
        country = faker.country()

    postal_code = None
    if should_event_occur(0.95):
        postal_code = faker.postcode()

    street_name = None
    if should_event_occur(0.95):
        street_name = faker.street_name()

    building = None
    if should_event_occur(0.95):
        building = faker.building_number()

    gate = None
    if should_event_occur(0.3):
        gate = faker.building_number()

    floor = None
    if should_event_occur(0.3):
        if should_event_occur(0.1):
            floor = str(faker.random_int(min=0, max=50))
        else:
            floor = str(faker.random_int(min=0, max=4))

    apartment = None
    if should_event_occur(0.3):
        apartment = faker.building_number()

    address = Address(
        city=city,
        country=country,
        postal_code=postal_code,
        street_name=street_name,
        building=building,
        gate=gate,
        floor=floor,
        apartment=apartment
    )

    location = Location(coords=short_location, address=address)

    event = Event(
        organizer=user["user_read_only"],
        name=name,
        desc=desc,
        s_date=s_date,
        f_date=f_date,
        members=members,
        location=location
    )
    result_event = db[collection.EVENTS].insert_one(event.model_dump(by_alias=True))
    event_id = result_event.inserted_id
    for member_id in members:
        db[collection.USERS].update_one({"_id": member_id}, {"$push": {"events": event_id}})
    print("Event created successfully.")
