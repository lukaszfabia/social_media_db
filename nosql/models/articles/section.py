from pydantic import Field


class Section:
    header: str = Field(..., max_length=32)
    content: str = Field(..., max_length=256)
