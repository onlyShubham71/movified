from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from .. import models, schemas
from ..database import get_db

router = APIRouter(prefix="/movies", tags=["movies"])


@router.get("/", response_model=List[schemas.MovieBase])
def list_movies(skip: int = 0, limit: int = 20, db: Session = Depends(get_db)):
    return db.query(models.Movie).offset(skip).limit(limit).all()


@router.get("/{movie_id}", response_model=schemas.MovieDetail)
def get_movie(movie_id: int, db: Session = Depends(get_db)):
    movie = db.query(models.Movie).filter(models.Movie.id == movie_id).first()
    if not movie:
        raise HTTPException(status_code=404, detail="Movie not found")
    return movie


@router.get("/mood/{mood_id}", response_model=List[schemas.MovieBase])
def movies_by_mood(mood_id: int, db: Session = Depends(get_db)):
    mood = db.query(models.Mood).filter(models.Mood.id == mood_id).first()
    if not mood:
        raise HTTPException(status_code=404, detail="Mood not found")
    return mood.movies


@router.post("/", response_model=schemas.MovieDetail)
def create_movie(payload: schemas.MovieCreate, db: Session = Depends(get_db)):
    movie = models.Movie(
        title=payload.title,
        release_year=payload.release_year,
        runtime_minutes=payload.runtime_minutes,
        overview=payload.overview,
        poster_url=payload.poster_url,
    )
    if payload.mood_ids:
        movie.moods = db.query(models.Mood).filter(models.Mood.id.in_(payload.mood_ids)).all()
    db.add(movie)
    db.commit()
    db.refresh(movie)
    return movie
