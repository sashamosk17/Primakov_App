import { Pool } from "pg";
import { IDeadlineRepository } from "../../../domain/repositories/IDeadlineRepository";
import { Result } from "../../../shared/Result";
import { Deadline } from "../../../domain/entities/Deadline";
import { DeadlineStatus } from "../../../domain/value-objects/DeadlineStatus";

export class DeadlineRepository implements IDeadlineRepository {
  constructor(private pool: Pool) {}

  async getByUser(userId: string): Promise<Result<Deadline[]>> {
    try {
      const result = await this.pool.query(
        "SELECT * FROM deadlines WHERE user_id = $1",
        [userId]
      );
      const deadlines = result.rows.map(this.mapRowToDeadline);
      return Result.ok(deadlines);
    } catch (error: any) {
      return Result.fail("Database error: " + error.message);
    }
  }

  async findById(id: string): Promise<Deadline | undefined> {
    try {
      const result = await this.pool.query("SELECT * FROM deadlines WHERE id = $1", [id]);
      if (result.rows.length === 0) return undefined;
      return this.mapRowToDeadline(result.rows[0]);
    } catch (error: any) {
      return undefined;
    }
  }

  async save(deadline: Deadline): Promise<Result<void>> {
    try {
      await this.pool.query(
        "INSERT INTO deadlines (id, title, description, due_date, user_id, status, created_at, updated_at, completed_at, subject) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) ON CONFLICT (id) DO UPDATE SET title = $2, description = $3, due_date = $4, status = $6, updated_at = $8, completed_at = $9, subject = $10",
        [deadline.id, deadline.title, deadline.description, deadline.dueDate, deadline.userId, deadline.status, deadline.createdAt, deadline.updatedAt, deadline.completedAt, deadline.subject]
      );
      return Result.ok();
    } catch (error: any) {
      return Result.fail("Database error: " + error.message);
    }
  }

  async update(deadline: Deadline): Promise<Result<void>> {
      return this.save(deadline);
  }

  private mapRowToDeadline(row: any): Deadline {
    return new Deadline(
      row.id, row.title, row.description, new Date(row.due_date), row.user_id, row.status as DeadlineStatus,
      new Date(row.created_at), new Date(row.updated_at), row.completed_at ? new Date(row.completed_at) : undefined, row.subject
    );
  }
}

