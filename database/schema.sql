-- Movified database schema
-- Run this first, before seed.sql

CREATE DATABASE IF NOT EXISTS movified;
USE movified;

CREATE TABLE IF NOT EXISTS moods (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    color_hex VARCHAR(7)
);

CREATE TABLE IF NOT EXISTS movies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    release_year INT,
    runtime_minutes INT,
    overview TEXT,
    poster_url VARCHAR(512)
);

CREATE TABLE IF NOT EXISTS movie_moods (
    movie_id INT NOT NULL,
    mood_id INT NOT NULL,
    intensity FLOAT DEFAULT 1.0,
    PRIMARY KEY (movie_id, mood_id),
    FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE CASCADE,
    FOREIGN KEY (mood_id) REFERENCES moods(id) ON DELETE CASCADE
);

INSERT INTO moods (name, description, color_hex) VALUES
('Cozy', 'Warm, comforting, low-stakes watching', '#E8A87C'),
('Mind-bending', 'Twists, nonlinear plots, makes you think', '#6C5CE7'),
('Gut-punch', 'Heavy emotional weight, will make you cry', '#2D3436'),
('Feel-good', 'Uplifting, leaves you smiling', '#FFD93D'),
('Tense', 'Edge-of-seat, high anxiety, thriller energy', '#C0392B'),
('Nostalgic', 'Wistful, throwback energy, hits like a memory', '#A29BFE');
