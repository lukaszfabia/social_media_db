from bson import ObjectId

from ...model import Model
from typing import List, Optional
from ....models.persons.user import UserReadOnly
from pydantic import Field, HttpUrl


class Page(Model):
    author: UserReadOnly
    title: str = Field(..., max_length=64)
    picture_url: Optional[HttpUrl] = None
    background_url: Optional[HttpUrl] = None

    # changed remove table with tags, take only strings
    tags: List[str] = None
    advertisements: Optional[List[ObjectId]] = None

    # id who like it
    likes: Optional[List[ObjectId]] = None
    views: int = 0
