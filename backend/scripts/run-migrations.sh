#!/bin/bash
# ============================================================================
# Migration Runner Script
# ============================================================================
# Runs database migrations in order
# Usage: ./run-migrations.sh [database_url]
# ============================================================================

set -e  # Exit on error

# Database connection parameters
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-primakov_app}"
DB_USER="${DB_USER:-postgres}"
DB_PASSWORD="${DB_PASSWORD:-postgres}"

# Use provided database URL or construct from environment variables
if [ -n "$1" ]; then
    DATABASE_URL="$1"
else
    DATABASE_URL="postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}"
fi

echo "============================================================================"
echo "PrimakovApp Database Migration Runner"
echo "============================================================================"
echo "Database: ${DB_NAME}"
echo "Host: ${DB_HOST}:${DB_PORT}"
echo ""

# Check if psql is available
if ! command -v psql &> /dev/null; then
    echo "Error: psql command not found. Please install PostgreSQL client."
    exit 1
fi

# Test database connection
echo "Testing database connection..."
if ! psql "${DATABASE_URL}" -c "SELECT 1" > /dev/null 2>&1; then
    echo "Error: Cannot connect to database. Please check your connection parameters."
    exit 1
fi
echo "✓ Database connection successful"
echo ""

# Run migrations
MIGRATIONS_DIR="$(dirname "$0")/migrations"

echo "Running migrations from: ${MIGRATIONS_DIR}"
echo ""

# Migration 001: Initial Schema
echo "→ Running 001_initial_schema.sql..."
psql "${DATABASE_URL}" -f "${MIGRATIONS_DIR}/001_initial_schema.sql"
echo "✓ Migration 001 completed"
echo ""

# Migration 002: Seed Test Data
echo "→ Running 002_seed_test_data.sql..."
psql "${DATABASE_URL}" -f "${MIGRATIONS_DIR}/002_seed_test_data.sql"
echo "✓ Migration 002 completed"
echo ""

echo "============================================================================"
echo "All migrations completed successfully!"
echo "============================================================================"
echo ""
echo "Database schema version:"
psql "${DATABASE_URL}" -c "SELECT version, description, applied_at FROM schema_version ORDER BY version;"
