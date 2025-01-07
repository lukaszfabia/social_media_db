from typing import List, Optional
from pydantic import HttpUrl


class Media:
    """Contains list with medias"""

    media: Optional[List[HttpUrl]] = None

    class Config:
        orm_mode = True
