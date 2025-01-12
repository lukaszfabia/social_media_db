from enum import Enum


class collection(str, Enum):
    USERS = "users"
    POSTS = "posts"
    COMMENTS = "comments"
    FRIEND_REQUESTS = "friend_requests"
    ADS = "ads"
    REACTIONS = "reactions"
    PAGES = "pages"
    LOCATIONS = "locations"
    EVENTS = "events"
    MESSAGES = "messages"
    GROUP = "groups"
    ARTICLES = "articles"
    CONVERSATIONS = "conversations"
