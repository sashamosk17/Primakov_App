"use strict";
/**
 * PostgreSQL implementation of IRatingRepository
 *
 * Handles teacher rating persistence with PostgreSQL database.
 * Implements optimistic locking via version field.
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.PostgresRatingRepository = void 0;
const Rating_1 = require("../../../domain/entities/Rating");
const Result_1 = require("../../../shared/Result");
class PostgresRatingRepository {
    constructor(pool) {
        this.pool = pool;
    }
    async getByTeacher(teacherId) {
        try {
            const query = `
        SELECT id, teacher_id, user_id, value, comment, version, ip_hash, created_at, updated_at
        FROM ratings
        WHERE teacher_id = $1
        ORDER BY created_at DESC
      `;
            const result = await this.pool.query(query, [teacherId]);
            const ratings = result.rows.map((row) => this.mapRowToRating(row));
            return Result_1.Result.ok(ratings);
        }
        catch (error) {
            console.error("Error getting ratings by teacher:", error);
            return Result_1.Result.fail("Failed to get ratings");
        }
    }
    async save(rating) {
        try {
            const query = `
        INSERT INTO ratings (id, teacher_id, user_id, value, comment, version, ip_hash, created_at, updated_at)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
        ON CONFLICT (user_id, teacher_id) DO UPDATE
          SET value = EXCLUDED.value,
              comment = EXCLUDED.comment,
              version = ratings.version + 1,
              updated_at = EXCLUDED.updated_at
      `;
            const result = await this.pool.query(query, [
                rating.id,
                rating.teacherId,
                rating.userId,
                rating.value,
                rating.comment,
                rating.version,
                rating.ipHash || null,
                rating.createdAt,
                rating.updatedAt,
            ]);
            return Result_1.Result.ok();
        }
        catch (error) {
            console.error("Error saving rating:", error);
            return Result_1.Result.fail("Failed to save rating");
        }
    }
    async update(rating) {
        try {
            // Optimistic locking: only update if version matches
            const query = `
        UPDATE ratings
        SET value = $2,
            comment = $3,
            version = version + 1,
            ip_hash = $4,
            updated_at = NOW()
        WHERE id = $1 AND version = $5
      `;
            const result = await this.pool.query(query, [
                rating.id,
                rating.value,
                rating.comment,
                rating.ipHash || null,
                rating.version,
            ]);
            // Check if update was successful (version matched)
            if (result.rowCount === 0) {
                return Result_1.Result.fail("Rating was modified by another process. Please retry.");
            }
            return Result_1.Result.ok();
        }
        catch (error) {
            console.error("Error updating rating:", error);
            return Result_1.Result.fail("Failed to update rating");
        }
    }
    /**
     * Map database row to Rating entity
     */
    mapRowToRating(row) {
        return new Rating_1.Rating(row.id, row.teacher_id, row.user_id, row.value, new Date(row.created_at), row.comment || '', new Date(row.updated_at), row.version, row.ip_hash);
    }
}
exports.PostgresRatingRepository = PostgresRatingRepository;
