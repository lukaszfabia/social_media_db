from ..model import Model
from ..media import Media
from typing import Optional
from bson import ObjectId


class Message(Model, Media):
    author: ObjectId
    content: Optional[str] = None

    class Config:
        orm_mode = True
        arbitrary_types_allowed = True
