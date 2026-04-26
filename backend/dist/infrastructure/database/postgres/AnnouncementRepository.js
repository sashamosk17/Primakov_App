"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.AnnouncementRepository = void 0;
const Result_1 = require("../../../shared/Result");
class AnnouncementRepository {
    constructor(pool) {
        this.pool = pool;
    }
    async getAll() {
        try {
            const result = await this.pool.query("SELECT * FROM announcements ORDER BY date DESC");
            return Result_1.Result.ok(result.rows.map(this.mapRow));
        }
        catch (e) {
            return Result_1.Result.fail(e.message);
        }
    }
    async getById(id) {
        try {
            const result = await this.pool.query("SELECT * FROM announcements WHERE id = $1", [id]);
            if (result.rows.length === 0)
                return Result_1.Result.ok(null);
            return Result_1.Result.ok(this.mapRow(result.rows[0]));
        }
        catch (e) {
            return Result_1.Result.fail(e.message);
        }
    }
    async getByCategory(category) {
        try {
            const result = await this.pool.query("SELECT * FROM announcements WHERE category = $1 ORDER BY date DESC", [category]);
            return Result_1.Result.ok(result.rows.map(this.mapRow));
        }
        catch (e) {
            return Result_1.Result.fail(e.message);
        }
    }
    async save(announcement) {
        try {
            await this.pool.query("INSERT INTO announcements (id, title, description, content, image_url, date, category, created_at, author_id) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) ON CONFLICT (id) DO UPDATE SET title = $2, description = $3, content = $4, image_url = $5, date = $6, category = $7, author_id = $9", [announcement.id, announcement.title, announcement.description, announcement.content, announcement.imageUrl, announcement.date, announcement.category, announcement.createdAt, announcement.authorId]);
            return Result_1.Result.ok();
        }
        catch (e) {
            return Result_1.Result.fail(e.message);
        }
    }
    mapRow(row) {
        return {
            id: row.id,
            title: row.title,
            description: row.description,
            content: row.content,
            imageUrl: row.image_url,
            date: new Date(row.date),
            category: row.category,
            createdAt: new Date(row.created_at),
            authorId: row.author_id
        };
    }
}
exports.AnnouncementRepository = AnnouncementRepository;
