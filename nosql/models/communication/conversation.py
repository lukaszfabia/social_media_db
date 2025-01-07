from model import Model
from pydantic import Field, HttpUrl
from typing import List, Optional
from bson import ObjectId
from ..persons.user import UserReadOnly
from message import Message


class Conversation(Model):
    title: str = Field(..., max_length=32)
    icon: Optional[HttpUrl] = None
    author_id: ObjectId
    members: Optional[List[UserReadOnly]] = None
    message: Optional[List[Message]] = None

    class Config:
        orm_mode = True
