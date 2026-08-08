// Thin wrapper around the Movified backend API.
// Update BASE_URL once the backend is deployed somewhere other than localhost.

const BASE_URL = "http://localhost:8000";

async function getMoods() {
  const res = await fetch(`${BASE_URL}/moods/`);
  if (!res.ok) throw new Error("Failed to fetch moods");
  return res.json();
}

async function getMoviesByMood(moodId) {
  const res = await fetch(`${BASE_URL}/movies/mood/${moodId}`);
  if (!res.ok) throw new Error("Failed to fetch movies for mood");
  return res.json();
}

async function getMovie(movieId) {
  const res = await fetch(`${BASE_URL}/movies/${movieId}`);
  if (!res.ok) throw new Error("Failed to fetch movie");
  return res.json();
}
