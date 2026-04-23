"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.DeadlineRepository = void 0;
const Result_1 = require("../../../shared/Result");
const Deadline_1 = require("../../../domain/entities/Deadline");
class DeadlineRepository {
    constructor(pool) {
        this.pool = pool;
    }
    async getByUser(userId) {
        try {
            const result = await this.pool.query("SELECT * FROM deadlines WHERE user_id = $1", [userId]);
            const deadlines = result.rows.map(this.mapRowToDeadline);
            return Result_1.Result.ok(deadlines);
        }
        catch (error) {
            return Result_1.Result.fail("Database error: " + error.message);
        }
    }
    async findById(id) {
        try {
            const result = await this.pool.query("SELECT * FROM deadlines WHERE id = $1", [id]);
            if (result.rows.length === 0)
                return undefined;
            return this.mapRowToDeadline(result.rows[0]);
        }
        catch (error) {
            return undefined;
        }
    }
    async save(deadline) {
        try {
            await this.pool.query("INSERT INTO deadlines (id, title, description, due_date, user_id, status, created_at, updated_at, completed_at, subject) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) ON CONFLICT (id) DO UPDATE SET title = $2, description = $3, due_date = $4, status = $6, updated_at = $8, completed_at = $9, subject = $10", [deadline.id, deadline.title, deadline.description, deadline.dueDate, deadline.userId, deadline.status, deadline.createdAt, deadline.updatedAt, deadline.completedAt, deadline.subject]);
            return Result_1.Result.ok();
        }
        catch (error) {
            return Result_1.Result.fail("Database error: " + error.message);
        }
    }
    async update(deadline) {
        return this.save(deadline);
    }
    mapRowToDeadline(row) {
        return new Deadline_1.Deadline(row.id, row.title, row.description, new Date(row.due_date), row.user_id, row.status, new Date(row.created_at), new Date(row.updated_at), row.completed_at ? new Date(row.completed_at) : undefined, row.subject);
    }
}
exports.DeadlineRepository = DeadlineRepository;
