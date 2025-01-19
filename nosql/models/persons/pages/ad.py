from typing import Optional
from ...model import Model
from pydantic import Field, HttpUrl
from bson import ObjectId
from ...media import Media


class Ad(Model, Media):
    content: str = Field(..., max_length=512)
    link: HttpUrl
    page_id: ObjectId
