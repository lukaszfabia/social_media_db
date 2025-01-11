from ..model import Model
from pydantic import EmailStr, Field, BaseModel, HttpUrl
from typing import List, Optional, Set
from datetime import datetime
from ..enums import UserPrivilege
from bson import ObjectId


class UserReadOnly(BaseModel):
    """Denormalization of user"""
    name: str = Field(..., max_length=50)
    picture_url: Optional[str] = None


class UserAuth(BaseModel):
    email: EmailStr
    password: Optional[str] = None
    provider: Optional[str] = None
    last_login: datetime
    user_privilege: UserPrivilege = UserPrivilege.User
    is_verified: bool = False


class User(Model):
    user_read_only: UserReadOnly
    user_auth: UserAuth
    background_url: Optional[HttpUrl] = None
    birthday: Optional[datetime] = None
    bio: str = Field("Edit bio", max_length=512)

    # only links cuz in link we have platform (preprocess on fronted)
    external_links: Optional[Set[HttpUrl]] = None

    # ids to other collections
    friends: Optional[Set[ObjectId]] = None
    friend_requests: Optional[Set[ObjectId]] = None
    followed_users: Optional[Set[ObjectId]] = None

    posts: Optional[Set[ObjectId]] = None
    articles: Optional[Set[ObjectId]] = None
    reactions: Optional[Set[ObjectId]] = None
    conversations: Optional[Set[ObjectId]] = None
    groups: Optional[Set[ObjectId]] = None
    events: Optional[Set[ObjectId]] = None

    class Config:
        orm_mode = True
        arbitrary_types_allowed = True
