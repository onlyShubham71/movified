from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List

from .. import models, schemas
from ..database import get_db

router = APIRouter(prefix="/moods", tags=["moods"])


@router.get("/", response_model=List[schemas.MoodBase])
def list_moods(db: Session = Depends(get_db)):
    return db.query(models.Mood).all()
