"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.StoryRepository = void 0;
const Result_1 = require("../../../shared/Result");
class StoryRepository {
    constructor(pool) {
        this.pool = pool;
    }
    async getAll() {
        try {
            const result = await this.pool.query("SELECT * FROM stories WHERE expires_at > NOW() ORDER BY created_at DESC");
            return Result_1.Result.ok(result.rows.map(this.mapRow));
        }
        catch (e) {
            return Result_1.Result.fail(e.message);
        }
    }
    async getById(id) {
        try {
            const result = await this.pool.query("SELECT * FROM stories WHERE id = $1", [id]);
            if (result.rows.length === 0)
                return Result_1.Result.ok(null);
            return Result_1.Result.ok(this.mapRow(result.rows[0]));
        }
        catch (e) {
            return Result_1.Result.fail(e.message);
        }
    }
    async save(story) {
        try {
            await this.pool.query("INSERT INTO stories (id, title, description, image_url, video_url, created_at, expires_at, viewed_by, author) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) ON CONFLICT (id) DO UPDATE SET title = $2, description = $3, image_url = $4, video_url = $5, expires_at = $7, viewed_by = $8, author = $9", [story.id, story.title, story.description, story.imageUrl, story.videoUrl, story.createdAt, story.expiresAt, JSON.stringify(story.viewedBy), story.author]);
            return Result_1.Result.ok();
        }
        catch (e) {
            return Result_1.Result.fail(e.message);
        }
    }
    async markAsViewed(storyId, userId) {
        try {
            const storyResult = await this.getById(storyId);
            if (!storyResult.isSuccess || !storyResult.value)
                return Result_1.Result.fail("Story not found");
            const story = storyResult.value;
            if (!story.viewedBy.includes(userId)) {
                story.viewedBy.push(userId);
                await this.pool.query("UPDATE stories SET viewed_by = $1 WHERE id = $2", [JSON.stringify(story.viewedBy), storyId]);
            }
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
            imageUrl: row.image_url,
            videoUrl: row.video_url,
            createdAt: new Date(row.created_at),
            expiresAt: new Date(row.expires_at),
            viewedBy: row.viewed_by || [],
            author: row.author
        };
    }
}
exports.StoryRepository = StoryRepository;
