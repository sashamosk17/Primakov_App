import { Pool } from "pg";
import { IRatingRepository } from "../../../domain/repositories/IRatingRepository";
import { Result } from "../../../shared/Result";
import { Rating } from "../../../domain/entities/Rating";

export class RatingRepository implements IRatingRepository {
  constructor(private pool: Pool) {}

  async getByTeacher(teacherId: string): Promise<Result<Rating[]>> {
    try {
      const result = await this.pool.query("SELECT * FROM ratings WHERE teacher_id = $1", [teacherId]);
      const ratings = result.rows.map(row => {
        return new Rating(
          row.id,
          row.teacher_id,
          row.user_id,
          row.value,
          new Date(row.created_at),
          new Date(row.updated_at),
          row.version,
          row.ip_hash
        );
      });
      return Result.ok(ratings);
    } catch(e: any) {
      return Result.fail(e.message);
    }
  }

  async save(rating: Rating): Promise<Result<void>> {
    try {
      await this.pool.query(
        "INSERT INTO ratings (id, teacher_id, user_id, value, version, ip_hash, created_at, updated_at) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) ON CONFLICT (id) DO UPDATE SET value = $4, version = $5, updated_at = $8",
        [rating.id, rating.teacherId, rating.userId, rating.value, rating.version, rating.ipHash, rating.createdAt, rating.updatedAt]
      );
      return Result.ok();
    } catch(e: any) {
      return Result.fail(e.message);
    }
  }

  async update(rating: Rating): Promise<Result<void>> {
    return this.save(rating);
  }
}
