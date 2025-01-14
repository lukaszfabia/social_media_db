from typing import List, Optional
from pydantic import Field
from nosql.models.model import Model
from bson import ObjectId


class Group(Model):
    name: str = Field(..., max_length=32)
    members: Optional[List[ObjectId]] = None
    posts: Optional[List[ObjectId]] = None
