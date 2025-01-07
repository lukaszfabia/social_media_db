from model import Model
from typing import Set, Optional
from models.persons.user import UserReadOnly
from pydantic import Field, HttpUrl


class Page(Model):
    author: UserReadOnly
    title: str = Field(..., max_length=64)
    picture_url: Optional[HttpUrl] = None
    background_url: Optional[HttpUrl] = None

    # changed remove table with tags, take only strings
    tags: Set[str] = {}
    advertisements: Set[str] = {}

    # id who like it
    likes: Set[str] = {}
    views: int = 0

    class Config:
        orm_mode = True
