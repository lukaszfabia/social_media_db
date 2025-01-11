from typing import List, Optional
from pydantic import Field
from ..model import Model
from ..persons.user import UserReadOnly
from ..media import Media
from .section import Section


class Article(Model, Media):
    user: UserReadOnly
    title: str = Field(..., max_length=32)
    is_public: bool = False
    hashtags: Optional[List[str]] = None
    sections: Optional[List[Section]] = None

    class Config:
        orm_mode = True
        arbitrary_types_allowed = True
