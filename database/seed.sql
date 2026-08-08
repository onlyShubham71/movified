-- Sample data for local development
-- Run this after schema.sql

USE movified;

INSERT INTO movies (title, release_year, runtime_minutes, overview, poster_url) VALUES
('Paddington 2', 2017, 103, 'A wrongly imprisoned bear works to clear his name.', NULL),
('Everything Everywhere All at Once', 2022, 140, 'A multiverse-hopping laundromat owner saves reality.', NULL),
('Manchester by the Sea', 2016, 137, 'A man returns home to raise his nephew after tragedy.', NULL),
('The Grand Budapest Hotel', 2014, 99, 'A concierge and his protege navigate a stolen painting caper.', NULL),
('Uncut Gems', 2019, 135, 'A jeweler chases one big score against mounting debts.', NULL),
('La La Land', 2016, 128, 'A musician and an actress fall for each other in LA.', NULL),
('Whiplash', 2014, 106, 'A drummer is pushed to his limits by a ruthless instructor.', NULL),
('Grave of the Fireflies', 1988, 89, 'Two siblings struggle to survive in wartime Japan.', NULL);

INSERT INTO movie_moods (movie_id, mood_id, intensity)
SELECT m.id, md.id, 1.0 FROM movies m, moods md WHERE m.title = 'Paddington 2' AND md.name = 'Cozy';
INSERT INTO movie_moods (movie_id, mood_id, intensity)
SELECT m.id, md.id, 1.0 FROM movies m, moods md WHERE m.title = 'Everything Everywhere All at Once' AND md.name = 'Mind-bending';
INSERT INTO movie_moods (movie_id, mood_id, intensity)
SELECT m.id, md.id, 0.7 FROM movies m, moods md WHERE m.title = 'Everything Everywhere All at Once' AND md.name = 'Feel-good';
INSERT INTO movie_moods (movie_id, mood_id, intensity)
SELECT m.id, md.id, 1.0 FROM movies m, moods md WHERE m.title = 'Manchester by the Sea' AND md.name = 'Gut-punch';
INSERT INTO movie_moods (movie_id, mood_id, intensity)
SELECT m.id, md.id, 1.0 FROM movies m, moods md WHERE m.title = 'The Grand Budapest Hotel' AND md.name = 'Feel-good';
INSERT INTO movie_moods (movie_id, mood_id, intensity)
SELECT m.id, md.id, 0.6 FROM movies m, moods md WHERE m.title = 'The Grand Budapest Hotel' AND md.name = 'Nostalgic';
INSERT INTO movie_moods (movie_id, mood_id, intensity)
SELECT m.id, md.id, 1.0 FROM movies m, moods md WHERE m.title = 'Uncut Gems' AND md.name = 'Tense';
INSERT INTO movie_moods (movie_id, mood_id, intensity)
SELECT m.id, md.id, 1.0 FROM movies m, moods md WHERE m.title = 'La La Land' AND md.name = 'Nostalgic';
INSERT INTO movie_moods (movie_id, mood_id, intensity)
SELECT m.id, md.id, 0.8 FROM movies m, moods md WHERE m.title = 'La La Land' AND md.name = 'Feel-good';
INSERT INTO movie_moods (movie_id, mood_id, intensity)
SELECT m.id, md.id, 1.0 FROM movies m, moods md WHERE m.title = 'Whiplash' AND md.name = 'Tense';
INSERT INTO movie_moods (movie_id, mood_id, intensity)
SELECT m.id, md.id, 1.0 FROM movies m, moods md WHERE m.title = 'Grave of the Fireflies' AND md.name = 'Gut-punch';
