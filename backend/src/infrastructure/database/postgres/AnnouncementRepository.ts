import { Pool } from "pg";
import { IAnnouncementRepository } from "../../../domain/repositories/IAnnouncementRepository";
import { Result } from "../../../shared/Result";
import { Announcement } from "../../../domain/entities/Announcement";

export class AnnouncementRepository implements IAnnouncementRepository {
  constructor(private pool: Pool) {}

  async getAll(): Promise<Result<Announcement[]>> {
    try {
      const result = await this.pool.query("SELECT * FROM announcements ORDER BY date DESC");
      return Result.ok(result.rows.map(this.mapRow));
    } catch (e: any) {
      return Result.fail(e.message);
    }
  }

  async getById(id: string): Promise<Result<Announcement | null>> {
    try {
      const result = await this.pool.query("SELECT * FROM announcements WHERE id = $1", [id]);
      if (result.rows.length === 0) return Result.ok(null);
      return Result.ok(this.mapRow(result.rows[0]));
    } catch (e: any) {
      return Result.fail(e.message);
    }
  }

  async getByCategory(category: string): Promise<Result<Announcement[]>> {
    try {
      const result = await this.pool.query("SELECT * FROM announcements WHERE category = $1 ORDER BY date DESC", [category]);
      return Result.ok(result.rows.map(this.mapRow));
    } catch (e: any) {
      return Result.fail(e.message);
    }
  }

  async save(announcement: Announcement): Promise<Result<void>> {
    try {
      await this.pool.query(
        "INSERT INTO announcements (id, title, description, content, image_url, date, category, created_at, author_id) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) ON CONFLICT (id) DO UPDATE SET title = $2, description = $3, content = $4, image_url = $5, date = $6, category = $7, author_id = $9",
        [announcement.id, announcement.title, announcement.description, announcement.content, announcement.imageUrl, announcement.date, announcement.category, announcement.createdAt, announcement.authorId]
      );
      return Result.ok();
    } catch (e: any) {
      return Result.fail(e.message);
    }
  }

  private mapRow(row: any): Announcement {
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
