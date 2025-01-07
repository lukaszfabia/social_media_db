from pydantic import BaseModel, Field
from datetime import datetime, timezone
from typing import Optional


class Model(BaseModel):
    created_at: datetime = Field(default_factory=lambda: datetime.now(tz=timezone.utc))
    updated_at: datetime = Field(default_factory=lambda: datetime.now(tz=timezone.utc))
    deleted_at: Optional[datetime] = None

    class Config:
        orm_mode = True

    def update(self):
        self.updated_at = datetime.now(tz=timezone.utc)
