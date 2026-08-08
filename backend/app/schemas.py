from pydantic import BaseModel
from typing import Optional, List


class MoodBase(BaseModel):
    id: int
    name: str
    description: Optional[str] = None
    color_hex: Optional[str] = None

    class Config:
        from_attributes = True


class MovieBase(BaseModel):
    id: int
    title: str
    release_year: Optional[int] = None
    runtime_minutes: Optional[int] = None
    overview: Optional[str] = None
    poster_url: Optional[str] = None

    class Config:
        from_attributes = True


class MovieDetail(MovieBase):
    moods: List[MoodBase] = []


class MovieCreate(BaseModel):
    title: str
    release_year: Optional[int] = None
    runtime_minutes: Optional[int] = None
    overview: Optional[str] = None
    poster_url: Optional[str] = None
    mood_ids: List[int] = []
