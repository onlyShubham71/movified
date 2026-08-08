# Migrations

Once the database has real data in it, don't hand-edit `schema.sql` directly —
that's how tables get out of sync with what's actually deployed.

Instead, drop new numbered files here for every change:

```
0001_add_users_table.sql
0002_add_watchlist_table.sql
0003_add_rating_column_to_movies.sql
```

Each file is a small, one-purpose SQL script. Apply them in order, and note
which ones you've already run somewhere (a simple `applied_migrations` table
works fine, or just track it in this README as you go).

This folder is empty until the schema needs its first change after go-live.
