from sqlalchemy import Column, Integer, String, Text, ForeignKey, Table, Float
from sqlalchemy.orm import relationship

from .database import Base

movie_moods = Table(
    "movie_moods",
    Base.metadata,
    Column("movie_id", Integer, ForeignKey("movies.id"), primary_key=True),
    Column("mood_id", Integer, ForeignKey("moods.id"), primary_key=True),
    Column("intensity", Float, default=1.0),
)


class Movie(Base):
    __tablename__ = "movies"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(255), nullable=False, index=True)
    release_year = Column(Integer)
    runtime_minutes = Column(Integer)
    overview = Column(Text)
    poster_url = Column(String(512))

    moods = relationship("Mood", secondary=movie_moods, back_populates="movies")


class Mood(Base):
    __tablename__ = "moods"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), unique=True, nullable=False)
    description = Column(Text)
    color_hex = Column(String(7))

    movies = relationship("Movie", secondary=movie_moods, back_populates="moods")
