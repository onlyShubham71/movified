# Movified

Mood-based movie discovery. Find something to watch by how you want to feel,
not by genre.

## Build order

- [x] **Phase 1 — Database** (`database/`)
- [ ] **Phase 2 — Backend** (`backend/`)
- [ ] **Phase 3 — Frontend** (`frontend/`)

Each phase is built and tested before moving to the next.

## Structure

```
movified/
├── database/
│   ├── schema.sql        # tables — run this first
│   ├── seed.sql           # sample data for local dev
│   └── migrations/        # schema changes, added after go-live
│
├── backend/
│   ├── app/
│   │   ├── main.py         # FastAPI app, mounts routers
│   │   ├── database.py     # DB connection/session
│   │   ├── models.py       # SQLAlchemy ORM models
│   │   ├── schemas.py      # Pydantic request/response shapes
│   │   └── routers/        # one file per resource (movies, moods, ...)
│   ├── requirements.txt
│   └── .env.example        # copy to .env, fill in your real DB password
│
└── frontend/
    ├── index.html
    ├── pages/               # additional HTML pages
    ├── css/                 # base.css + one file per page/component
    ├── js/
    │   ├── api.js           # fetch wrapper for the backend
    │   └── components/
    └── assets/
```

## Setup

**Database:**
```bash
mysql -u root -p < database/schema.sql
mysql -u root -p < database/seed.sql
```

**Backend:**
```bash
cd backend
python -m venv venv
source venv/bin/activate      # Windows: venv\Scripts\activate
pip install -r requirements.txt
cp .env.example .env          # then edit .env with your real DB password
uvicorn app.main:app --reload
```
Visit `http://localhost:8000/docs` for the interactive API.

**Frontend:**
Open `frontend/index.html` in a browser once Phase 3 starts, or serve it with
any static server (`python -m http.server` from inside `frontend/`).

## Development Guidelines

1. **Never edit `schema.sql` directly once real data exists.** Add a numbered
   file to `database/migrations/` instead.
2. **`.env` is never committed.** Only `.env.example` is. If you change a
   config value, update the example file too.
3. **One resource, one router file** in `backend/app/routers/`. Don't let
   `main.py` grow into a dumping ground.
4. **Commit often, in small chunks.** A broken half-finished feature committed
   on its own branch/commit is recoverable. Hours of uncommitted changes are
   not.
