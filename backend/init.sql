-- PrimakovApp Database Initialization Script
-- Execute this script directly on the PostgreSQL server

-- Ensure user exists with correct password
ALTER USER primakov WITH PASSWORD 'primakov';

-- Create migrations tracking table
CREATE TABLE IF NOT EXISTS migrations (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) UNIQUE NOT NULL,
  executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 001_CreateUsersTable.sql
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  role VARCHAR(50) NOT NULL,
  group_name VARCHAR(50),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);

INSERT INTO migrations (name) VALUES ('001_CreateUsersTable.sql') ON CONFLICT (name) DO NOTHING;

-- 002_CreateSchedulesTable.sql
CREATE TABLE IF NOT EXISTS schedules (
  id UUID PRIMARY KEY,
  group_name VARCHAR(50) NOT NULL,
  date DATE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  UNIQUE(group_name, date)
);

CREATE INDEX IF NOT EXISTS idx_schedules_group_date ON schedules(group_name, date);

INSERT INTO migrations (name) VALUES ('002_CreateSchedulesTable.sql') ON CONFLICT (name) DO NOTHING;

-- 002a_CreateLessonsTable.sql
CREATE TABLE IF NOT EXISTS lessons (
  id UUID PRIMARY KEY,
  schedule_id UUID NOT NULL REFERENCES schedules(id) ON DELETE CASCADE,
  subject VARCHAR(255) NOT NULL,
  teacher VARCHAR(255) NOT NULL,
  room VARCHAR(50) NOT NULL,
  time_slot VARCHAR(50) NOT NULL,
  lesson_order INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_lessons_schedule_id ON lessons(schedule_id);
CREATE INDEX IF NOT EXISTS idx_lessons_order ON lessons(schedule_id, lesson_order);

INSERT INTO migrations (name) VALUES ('002a_CreateLessonsTable.sql') ON CONFLICT (name) DO NOTHING;

-- 003_CreateDeadlinesTable.sql
CREATE TABLE IF NOT EXISTS deadlines (
  id UUID PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  due_date TIMESTAMP WITH TIME ZONE NOT NULL,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  status VARCHAR(50) NOT NULL,
  subject VARCHAR(255),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  completed_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX IF NOT EXISTS idx_deadlines_user_id ON deadlines(user_id);
CREATE INDEX IF NOT EXISTS idx_deadlines_due_date ON deadlines(due_date);

INSERT INTO migrations (name) VALUES ('003_CreateDeadlinesTable.sql') ON CONFLICT (name) DO NOTHING;

-- 004_CreateRatingsTable.sql
CREATE TABLE IF NOT EXISTS ratings (
  id UUID PRIMARY KEY,
  teacher_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  value INTEGER NOT NULL CHECK (value >= 1 AND value <= 5),
  version INTEGER NOT NULL DEFAULT 0,
  ip_hash VARCHAR(255),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  UNIQUE(teacher_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_ratings_teacher_id ON ratings(teacher_id);

INSERT INTO migrations (name) VALUES ('004_CreateRatingsTable.sql') ON CONFLICT (name) DO NOTHING;

-- 005_CreateAnnouncementsTable.sql
CREATE TABLE IF NOT EXISTS announcements (
  id UUID PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  category VARCHAR(100) NOT NULL,
  author_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  published_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_announcements_category ON announcements(category);
CREATE INDEX IF NOT EXISTS idx_announcements_published_at ON announcements(published_at DESC);

INSERT INTO migrations (name) VALUES ('005_CreateAnnouncementsTable.sql') ON CONFLICT (name) DO NOTHING;

-- 006_CreateStoriesTable.sql
CREATE TABLE IF NOT EXISTS stories (
  id UUID PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  image_url TEXT NOT NULL,
  content TEXT NOT NULL,
  author_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS story_views (
  id UUID PRIMARY KEY,
  story_id UUID NOT NULL REFERENCES stories(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  viewed_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  UNIQUE(story_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_stories_expires_at ON stories(expires_at);
CREATE INDEX IF NOT EXISTS idx_story_views_story_id ON story_views(story_id);
CREATE INDEX IF NOT EXISTS idx_story_views_user_id ON story_views(user_id);

INSERT INTO migrations (name) VALUES ('006_CreateStoriesTable.sql') ON CONFLICT (name) DO NOTHING;

-- Verification
SELECT 'Database initialized successfully!' as status;
SELECT name, executed_at FROM migrations ORDER BY executed_at;
