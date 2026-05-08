"use strict";
/**
 * PostgreSQL implementation of IAnnouncementRepository
 *
 * Handles announcement persistence with PostgreSQL database.
 * Implements soft delete functionality.
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.PostgresAnnouncementRepository = void 0;
const Result_1 = require("../../../shared/Result");
class PostgresAnnouncementRepository {
    constructor(pool) {
        this.pool = pool;
    }
    async getAll() {
        try {
            const query = `
        SELECT id, title, description, content, image_url, date, category, author_id, created_at
        FROM announcements
        ORDER BY date DESC, created_at DESC
      `;
            const result = await this.pool.query(query);
            const announcements = result.rows.map((row) => this.mapRowToAnnouncement(row));
            return Result_1.Result.ok(announcements);
        }
        catch (error) {
            console.error("Error getting all announcements:", error);
            return Result_1.Result.fail("Failed to get announcements");
        }
    }
    async getById(id) {
        try {
            const query = `
        SELECT id, title, description, content, image_url, date, category, author_id, created_at
        FROM announcements
        WHERE id = $1
      `;
            const result = await this.pool.query(query, [id]);
            if (result.rows.length === 0) {
                return Result_1.Result.ok(null);
            }
            const announcement = this.mapRowToAnnouncement(result.rows[0]);
            return Result_1.Result.ok(announcement);
        }
        catch (error) {
            console.error("Error getting announcement by id:", error);
            return Result_1.Result.fail("Failed to get announcement");
        }
    }
    async getByCategory(category) {
        try {
            const query = `
        SELECT id, title, description, content, image_url, date, category, author_id, created_at
        FROM announcements
        WHERE category = $1
        ORDER BY date DESC, created_at DESC
      `;
            const result = await this.pool.query(query, [category]);
            const announcements = result.rows.map((row) => this.mapRowToAnnouncement(row));
            return Result_1.Result.ok(announcements);
        }
        catch (error) {
            console.error("Error getting announcements by category:", error);
            return Result_1.Result.fail("Failed to get announcements");
        }
    }
    async save(announcement) {
        try {
            // Check if announcement exists
            const existsQuery = "SELECT id FROM announcements WHERE id = $1";
            const existsResult = await this.pool.query(existsQuery, [announcement.id]);
            if (existsResult.rows.length > 0) {
                // Update existing announcement
                const updateQuery = `
          UPDATE announcements
          SET title = $2,
              description = $3,
              content = $4,
              image_url = $5,
              date = $6,
              category = $7,
              author_id = $8
          WHERE id = $1
        `;
                await this.pool.query(updateQuery, [
                    announcement.id,
                    announcement.title,
                    announcement.description,
                    announcement.content || null,
                    announcement.imageUrl || null,
                    announcement.date,
                    announcement.category,
                    announcement.authorId,
                ]);
            }
            else {
                // Insert new announcement
                const insertQuery = `
          INSERT INTO announcements (id, title, description, content, image_url, date, category, author_id, created_at)
          VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
        `;
                await this.pool.query(insertQuery, [
                    announcement.id,
                    announcement.title,
                    announcement.description,
                    announcement.content || null,
                    announcement.imageUrl || null,
                    announcement.date,
                    announcement.category,
                    announcement.authorId,
                    announcement.createdAt,
                ]);
            }
            return Result_1.Result.ok();
        }
        catch (error) {
            console.error("Error saving announcement:", error);
            return Result_1.Result.fail("Failed to save announcement");
        }
    }
    /**
     * Map database row to Announcement entity
     */
    mapRowToAnnouncement(row) {
        return {
            id: row.id,
            title: row.title,
            content: row.content || row.description || '', // Use content if available, fallback to description
            createdAt: new Date(row.created_at),
            description: row.description,
            imageUrl: row.image_url,
            date: new Date(row.date),
            category: row.category,
            authorId: row.author_id,
        };
    }
}
exports.PostgresAnnouncementRepository = PostgresAnnouncementRepository;
