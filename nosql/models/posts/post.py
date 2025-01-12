from ..model import Model
from ..persons.user import UserReadOnly
from pydantic import Field
from bson import ObjectId
from typing import Optional, List
from ..events.location import ShortLocation
from ..media import Media


class Post(Model, Media):
    user: UserReadOnly
    title: str = Field(..., max_length=128)
    content: str = Field(..., max_length=512)
    is_public: bool = True
    hashtags: Optional[List[str]] = {}

    group_id: Optional[ObjectId] = None
    location: ShortLocation
