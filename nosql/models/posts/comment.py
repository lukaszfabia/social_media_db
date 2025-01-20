from typing import List
from ..model import Model
from ..persons.user import UserReadOnly
from pydantic import HttpUrl, Field
from bson import ObjectId


class Comment(Model):
    user: UserReadOnly
    post_id: ObjectId
    content: str = Field(..., max_length=256)
    media: List[HttpUrl] = None
    # hashtags could be included in content

    class Config:
        from_attributes = True
