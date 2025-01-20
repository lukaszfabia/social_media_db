from pydantic import Field, BaseModel


class Section(BaseModel):
    header: str = Field(..., max_length=32)
    content: str = Field(..., max_length=256)
