"use strict";
/**
 * PostgreSQL implementation of IDeadlineRepository
 *
 * Handles deadline persistence with PostgreSQL database.
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.PostgresDeadlineRepository = void 0;
const Deadline_1 = require("../../../domain/entities/Deadline");
const Result_1 = require("../../../shared/Result");
class PostgresDeadlineRepository {
    constructor(pool) {
        this.pool = pool;
    }
    async getByUser(userId) {
        try {
            const query = `
        SELECT id, user_id, title, description, subject, due_date, status,
               completed_at, created_at, updated_at
        FROM deadlines
        WHERE user_id = $1
        ORDER BY due_date ASC
      `;
            const result = await this.pool.query(query, [userId]);
            const deadlines = result.rows.map((row) => this.mapRowToDeadline(row));
            return Result_1.Result.ok(deadlines);
        }
        catch (error) {
            console.error("Error getting deadlines by user:", error);
            return Result_1.Result.fail("Failed to get deadlines");
        }
    }
    async findById(id) {
        try {
            const query = `
        SELECT id, user_id, title, description, subject, due_date, status,
               completed_at, created_at, updated_at
        FROM deadlines
        WHERE id = $1
      `;
            const result = await this.pool.query(query, [id]);
            if (result.rows.length === 0) {
                return undefined;
            }
            return this.mapRowToDeadline(result.rows[0]);
        }
        catch (error) {
            console.error("Error finding deadline by id:", error);
            return undefined;
        }
    }
    async save(deadline) {
        try {
            const query = `
        INSERT INTO deadlines (id, user_id, title, description, subject, due_date, status,
                              completed_at, created_at, updated_at)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
      `;
            await this.pool.query(query, [
                deadline.id,
                deadline.userId,
                deadline.title,
                deadline.description,
                deadline.subject || null,
                deadline.dueDate,
                deadline.status,
                deadline.completedAt || null,
                deadline.createdAt,
                deadline.updatedAt,
            ]);
            return Result_1.Result.ok();
        }
        catch (error) {
            console.error("Error saving deadline:", error);
            return Result_1.Result.fail("Failed to save deadline");
        }
    }
    async update(deadline) {
        try {
            const query = `
        UPDATE deadlines
        SET title = $2,
            description = $3,
            subject = $4,
            due_date = $5,
            status = $6,
            completed_at = $7,
            updated_at = NOW()
        WHERE id = $1
      `;
            await this.pool.query(query, [
                deadline.id,
                deadline.title,
                deadline.description,
                deadline.subject || null,
                deadline.dueDate,
                deadline.status,
                deadline.completedAt || null,
            ]);
            return Result_1.Result.ok();
        }
        catch (error) {
            console.error("Error updating deadline:", error);
            return Result_1.Result.fail("Failed to update deadline");
        }
    }
    /**
     * Map database row to Deadline entity
     */
    mapRowToDeadline(row) {
        return new Deadline_1.Deadline(row.id, row.title, row.description, new Date(row.due_date), row.user_id, row.status, new Date(row.created_at), new Date(row.updated_at), row.completed_at ? new Date(row.completed_at) : undefined, row.subject);
    }
}
exports.PostgresDeadlineRepository = PostgresDeadlineRepository;
