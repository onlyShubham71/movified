from fastapi import FastAPI

from .database import engine, Base
from .routers import movies, moods

Base.metadata.create_all(bind=engine)

app = FastAPI(title="Movified API", version="0.1.0")

app.include_router(movies.router)
app.include_router(moods.router)


@app.get("/")
def root():
    return {"status": "Movified API is alive"}
