from typing import Optional
from pydantic import BaseModel, Field
from geojson import Point


class ShortLocation(BaseModel):
    latitude: float = Field(
        ..., ge=0, le=90, description="Latitude must be between 0 and 90"
    )
    longitude: float = Field(
        ..., ge=-180, le=180, description="Longitude must be between -180 and 180"
    )


class Address(BaseModel):
    city: Optional[str] = Field(None, max_length=100)
    country: Optional[str] = Field(None, max_length=100)
    postal_code: Optional[str] = Field(None, max_length=20)
    street_name: Optional[str] = Field(None, max_length=255)
    building: Optional[str] = Field(None, max_length=20)
    gate: Optional[str] = Field(None, max_length=20)
    floor: Optional[str] = Field(None, max_length=20)
    apartment: Optional[str] = Field(None, max_length=20)

    class Config:
        from_attributes = True


class Location(BaseModel):
    coords: ShortLocation
    address: Address

    class Config:
        from_attributes = True
