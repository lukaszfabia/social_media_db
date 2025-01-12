from ..model import Model
from ..media import Media
from typing import Optional
from ..persons.user import UserReadOnly


class Message(Model, Media):
    user: UserReadOnly
    content: Optional[str] = None
