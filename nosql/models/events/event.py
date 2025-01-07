from model import Model
from ..persons.user import UserReadOnly
from pydantic import Field
from datetime import datetime
from typing import Set, Optional
from bson import ObjectId
from location import Location
from ..media import Media


class Event(Model, Media):
    organizer: UserReadOnly
    name: str = Field(..., max_length=32)
    desc: str = Field(..., max_length=512)
    s_date: datetime
    f_date: Optional[datetime] = None

    members: Optional[Set[ObjectId]] = None
    location: Location