"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.RatingRepository = void 0;
const Result_1 = require("../../../shared/Result");
const Rating_1 = require("../../../domain/entities/Rating");
class RatingRepository {
    constructor(pool) {
        this.pool = pool;
    }
    async getByTeacher(teacherId) {
        try {
            const result = await this.pool.query("SELECT * FROM ratings WHERE teacher_id = $1", [teacherId]);
            const ratings = result.rows.map(row => {
                return new Rating_1.Rating(row.id, row.teacher_id, row.user_id, row.value, new Date(row.created_at), new Date(row.updated_at), row.version, row.ip_hash);
            });
            return Result_1.Result.ok(ratings);
        }
        catch (e) {
            return Result_1.Result.fail(e.message);
        }
    }
    async save(rating) {
        try {
            await this.pool.query("INSERT INTO ratings (id, teacher_id, user_id, value, version, ip_hash, created_at, updated_at) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) ON CONFLICT (id) DO UPDATE SET value = $4, version = $5, updated_at = $8", [rating.id, rating.teacherId, rating.userId, rating.value, rating.version, rating.ipHash, rating.createdAt, rating.updatedAt]);
            return Result_1.Result.ok();
        }
        catch (e) {
            return Result_1.Result.fail(e.message);
        }
    }
    async update(rating) {
        return this.save(rating);
    }
}
exports.RatingRepository = RatingRepository;
