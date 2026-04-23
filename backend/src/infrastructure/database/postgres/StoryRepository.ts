import { Pool } from "pg";
import { IStoryRepository } from "../../../domain/repositories/IStoryRepository";
import { Result } from "../../../shared/Result";
import { Story } from "../../../domain/entities/Story";

export class StoryRepository implements IStoryRepository {
  constructor(private pool: Pool) {}

  async getAll(): Promise<Result<Story[]>> {
    try {
      const result = await this.pool.query("SELECT * FROM stories WHERE expires_at > NOW() ORDER BY created_at DESC");
      return Result.ok(result.rows.map(this.mapRow));
    } catch (e: any) {
      return Result.fail(e.message);
    }
  }

  async getById(id: string): Promise<Result<Story | null>> {
    try {
      const result = await this.pool.query("SELECT * FROM stories WHERE id = $1", [id]);
      if (result.rows.length === 0) return Result.ok(null);
      return Result.ok(this.mapRow(result.rows[0]));
    } catch (e: any) {
      return Result.fail(e.message);
    }
  }

  async save(story: Story): Promise<Result<void>> {
    try {
      await this.pool.query(
        "INSERT INTO stories (id, title, description, image_url, video_url, created_at, expires_at, viewed_by, author) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) ON CONFLICT (id) DO UPDATE SET title = $2, description = $3, image_url = $4, video_url = $5, expires_at = $7, viewed_by = $8, author = $9",
        [story.id, story.title, story.description, story.imageUrl, story.videoUrl, story.createdAt, story.expiresAt, JSON.stringify(story.viewedBy), story.author]
      );
      return Result.ok();
    } catch (e: any) {
      return Result.fail(e.message);
    }
  }

  async markAsViewed(storyId: string, userId: string): Promise<Result<void>> {
    try {
      const storyResult = await this.getById(storyId);
      if (!storyResult.isSuccess || !storyResult.value) return Result.fail("Story not found");
      const story = storyResult.value;
      if (!story.viewedBy.includes(userId)) {
        story.viewedBy.push(userId);
        await this.pool.query("UPDATE stories SET viewed_by = $1 WHERE id = $2", [JSON.stringify(story.viewedBy), storyId]);
      }
      return Result.ok();
    } catch (e: any) {
      return Result.fail(e.message);
    }
  }

  private mapRow(row: any): Story {
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
