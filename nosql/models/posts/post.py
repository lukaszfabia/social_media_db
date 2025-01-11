from ..model import Model
from ..persons.user import UserReadOnly
from pydantic import Field, HttpUrl
from bson import ObjectId
from typing import List, Set
from ..events.location import ShortLocation
from ..media import Media


class Post(Model, Media):
    user: UserReadOnly
    title: str = Field(..., max_length=128)
    content: str = Field(..., max_length=512)
    is_public: bool = True
    hashtags: Set[str] = {}

    group_id: ObjectId
    location: ShortLocation

    class Config:
        orm_mode = True
        arbitrary_types_allowed = True
