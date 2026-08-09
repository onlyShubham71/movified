# Movified — Development Log

A record of what was wanted, what was decided, what was built, what broke,
and what fixed it. Kept so future changes don't have to be re-figured-out
from scratch.

---

## 1. The Vision

**What Movified is:** a movie discovery app that surfaces films by emotional
vibe — Cozy, Mind-bending, Gut-punch, Feel-good, Tense, Nostalgic — instead
of by genre.

**Explicit requirements given, in order:**

1. Full-stack project, built from scratch.
2. Stack: **HTML, CSS, JS** (frontend) + **Python** (backend) + **MySQL**
   (database) — chosen because these were already known, not because they're
   objectively optimal.
   The reasoning: zero ramp-up time means more actual
   shipping. (Postgres was considered and explicitly rejected for now —
   the SQL is close enough to MySQL that switching later, if ever needed,
   is a small lift, not a rebuild.)
3. Build order: **database → backend → frontend**, in that sequence, each
   phase proven working before moving to the next.
4. A structure that "doesn't corrupt" while working on it or modifying it
   later.
5. Later, the target feature set for a movie's detail page was defined:
   poster, title, trailer (plays on open), mood tags, brief mood
   description, cast, creators, ratings from IMDb/Rotten Tomatoes, and a
   public comment section.
6. Movie catalog growth strategy: **manual entry**, not automated import.
   TMDB auto-import was offered as an option and explicitly declined —
   mood-tagging is subjective, so manual curation was judged to be the
   product's strength, not a bottleneck to eliminate.

---

## 2. Recommendations Made (and the reasoning)

- **FastAPI + MySQL over other combinations** — matches existing skills
  exactly, removes the "learn a new tool" excuse to stall.
- **Backend built as a Python package** (`app/` with a `routers/`
  subfolder, one file per resource) rather than one flat `main.py` — so
  adding new resources later (users, comments, ratings) means adding a new
  router file, not growing a single file indefinitely.
- **Git from day one** — this is the actual mechanism behind "doesn't corrupt".
- **Real, external data sources for factual movie data** (not manual entry)
  once that phase arrives:
  - **TMDB** — poster, trailer link, cast/crew, overview, genres.
  - **OMDb** — IMDb rating, Rotten Tomatoes score, Metacritic score.
  - Both free, both need an API key. Not implemented yet.
- **Public "chat" clarified as in-app comments**, not scraped
  Reddit/Twitter discussion — the latter is fragile, largely against
  platform terms of service, and not realistic for a solo project to
  moderate.
- **Future schema, designed but deliberately not applied yet:**

  ```sql
  -- added to movies
  ALTER TABLE movies ADD COLUMN trailer_url VARCHAR(512);
  ALTER TABLE movies ADD COLUMN imdb_id VARCHAR(20);
  ALTER TABLE movies ADD COLUMN imdb_rating FLOAT;
  ALTER TABLE movies ADD COLUMN rotten_tomatoes_score INT;

  CREATE TABLE cast_members (
      id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(255) NOT NULL,
      photo_url VARCHAR(512)
  );

  CREATE TABLE movie_cast (
      movie_id INT NOT NULL,
      cast_member_id INT NOT NULL,
      character_name VARCHAR(255),
      role ENUM('actor','director','writer','creator') NOT NULL,
      PRIMARY KEY (movie_id, cast_member_id, role),
      FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE CASCADE,
      FOREIGN KEY (cast_member_id) REFERENCES cast_members(id) ON DELETE CASCADE
  );

  CREATE TABLE users (
      id INT AUTO_INCREMENT PRIMARY KEY,
      username VARCHAR(100) UNIQUE NOT NULL,
      email VARCHAR(255) UNIQUE NOT NULL,
      password_hash VARCHAR(255) NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );

  CREATE TABLE comments (
      id INT AUTO_INCREMENT PRIMARY KEY,
      movie_id INT NOT NULL,
      user_id INT NOT NULL,
      content TEXT NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE CASCADE,
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
  );
  ```

  **Rule attached to this:** it goes into `database/migrations/` as a
  numbered file only once the current backend is confirmed running —
  never edit `schema.sql` directly after real data exists. This was
  deliberately withheld from being run or committed while the backend
  was still unproven, to avoid stacking new planning on top of
  unfinished work.

---

## 3. Folder Structure (current)

```
movified/
├── database/
│   ├── schema.sql          # tables + 6 seeded moods
│   ├── seed.sql            # 8 sample movies + mood mappings
│   └── migrations/
│       └── README.md       # convention notes for future schema changes
│
├── backend/
│   ├── app/
│   │   ├── __init__.py
│   │   ├── main.py         # FastAPI app, mounts routers
│   │   ├── database.py     # SQLAlchemy engine/session
│   │   ├── models.py       # Movie, Mood ORM models
│   │   ├── schemas.py      # Pydantic request/response shapes
│   │   └── routers/
│   │       ├── __init__.py
│   │       ├── movies.py   # /movies endpoints
│   │       └── moods.py    # /moods endpoints
│   ├── venv/                # local Python environment (not in git)
│   ├── requirements.txt
│   ├── .env                 # real credentials (not in git)
│   └── .env.example         # committed placeholder
│
├── frontend/
│   ├── index.html           # placeholder — "Coming in Phase 3"
│   ├── pages/                (empty, reserved)
│   ├── css/
│   │   ├── base.css
│   │   └── pages/             (empty, reserved)
│   ├── js/
│   │   ├── api.js           # fetch wrapper, already points at the backend
│   │   ├── main.js           (empty entry point)
│   │   └── components/        (empty, reserved)
│   └── assets/
│       ├── images/
│       └── icons/
│
├── docs/
│   └── DEVLOG.md            # this file
│
|__LICENSE
├── .gitignore
└── README.md
```

---

## 4. Setup Log — What Was Actually Done

### Phase 1 — Database

1. Ran `database/schema.sql` to create the `movified` database and its
   three tables (`movies`, `moods`, `movie_moods`), plus insert the 6 seed
   moods.
2. Ran `database/seed.sql` to insert 8 sample movies and their mood
   mappings.
   ```
   Get-Content database\schema.sql -Raw | mysql -u root -p
   Get-Content database\seed.sql -Raw | mysql -u root -p
   ```
4. **Verification (this is what actually proved it worked, not assumption):**
   ```sql
   USE movified;
   SELECT COUNT(*) FROM movies;   -- returned 8
   SELECT COUNT(*) FROM moods;    -- returned 6
   ```
        Phase 1 status: confirmed complete.

### Phase 2 — Backend

1. `cd backend`, then `python -m venv venv` to create an isolated Python
   environment, then `venv\Scripts\activate` — confirmed by the prompt
   changing to start with `(venv)`.
2. `pip install -r requirements.txt` — installed FastAPI, SQLAlchemy,
   uvicorn, pymysql, python-dotenv, pydantic and their dependencies.
   Completed cleanly, no errors.
3. `copy .env.example .env`, then edited `.env` to replace the placeholder
   password with the real MySQL root password.
4. First run: `uvicorn app.main:app --reload`
   Snag #1:
   ```
   RuntimeError: 'cryptography' package is required for sha256_password
   or caching_sha2_password auth methods
   ```
   MySQL 8's default authentication method needs a package not listed in
   the original `requirements.txt`.
   **Fix:** `pip install cryptography`, then added
   `cryptography==50.0.0` to `requirements.txt` so this doesn't recur for
   anyone else who sets the project up from the repo.
5. Second run: `uvicorn app.main:app --reload`
   Snag #2:
   ```
   sqlalchemy.exc.OperationalError: (pymysql.err.OperationalError)
   (1045, "Access denied for user 'root'@'localhost' (using password: YES)")
   ```
   Misleading error — the account and password were both correct.
   **Actual cause:** a stray space after `root` in the `DATABASE_URL` line
   in `.env`, which broke the connection string parsing.
   **Fix:** removed the space, saved the file.
6. Third run: `uvicorn app.main:app --reload`
   ```
   INFO:     Application startup complete.
   ```
   **Verification:** opened `http://localhost:8000/docs`, used "Try it
   out" → "Execute" on `GET /movies/` and `GET /moods/`. Both returned
   real JSON — actual titles (`Uncut Gems`, `La La Land`, `Whiplash`, etc.)
   and actual moods (`Cozy`, `Mind-bending`, `Gut-punch`, etc.) pulled live
   from MySQL through the API.


   Phase 2 status: confirmed complete — real server, real database, real data, verified through the browser.

### Phase 3 — Frontend

**Not started.** `frontend/index.html` is a placeholder that says "Coming
in Phase 3." `frontend/js/api.js` already has a fetch wrapper written and
pointed at `http://localhost:8000`, ready to be used once real pages are
built.

---

## 5. Current Status Summary

| Phase | Status | Proof |
|---|---|---|
| Database | ✅ Complete | `SELECT COUNT(*)` returned 8 movies, 6 moods |
| Backend | ✅ Complete | `/docs` → Execute → real JSON from live DB |
| Frontend | ⬜ Not started | Placeholder page only |
| Extended schema (cast/ratings/users/comments) | ⬜ Designed, not applied | Sitting in this log, not yet a migration file |

---
