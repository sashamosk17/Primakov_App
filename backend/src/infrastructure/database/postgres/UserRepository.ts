import { Pool } from "pg";
import { IUserRepository } from "../../../domain/repositories/IUserRepository";
import { Result } from "../../../shared/Result";
import { User } from "../../../domain/entities/User";
import { Email } from "../../../domain/value-objects/Email";
import { Password } from "../../../domain/value-objects/Password";

export class UserRepository implements IUserRepository {
  constructor(private pool: Pool) {}

  async findById(id: string): Promise<Result<User | null>> {
    try {
      const result = await this.pool.query(
        "SELECT * FROM users WHERE id = $1",
        [id]
      );

      if (result.rows.length === 0) {
        return Result.ok(null);
      }

      const user = this.mapRowToUser(result.rows[0]);
      return Result.ok(user);
    } catch (error: any) {
      return Result.fail(`Database error: ${error.message}`);
    }
  }

  async findByEmail(email: string): Promise<Result<User | null>> {
    try {
      const result = await this.pool.query(
        "SELECT * FROM users WHERE email = $1",
        [email.toLowerCase()]
      );

      if (result.rows.length === 0) {
        return Result.ok(null);
      }

      const user = this.mapRowToUser(result.rows[0]);
      return Result.ok(user);
    } catch (error: any) {
      return Result.fail(`Database error: ${error.message}`);
    }
  }

  async save(user: User): Promise<Result<void>> {
    try {
      const row = this.mapUserToRow(user);

      await this.pool.query(
        `INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, vk_id, created_at, updated_at)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
         ON CONFLICT (id) DO UPDATE SET
           email = $2,
           password_hash = $3,
           first_name = $4,
           last_name = $5,
           role = $6,
           is_active = $7,
           vk_id = $8,
           updated_at = $10`,
        [
          row.id,
          row.email,
          row.password_hash,
          row.first_name,
          row.last_name,
          row.role,
          row.is_active,
          row.vk_id,
          row.created_at,
          row.updated_at,
        ]
      );

      return Result.ok();
    } catch (error: any) {
      return Result.fail(`Database error: ${error.message}`);
    }
  }

  private mapRowToUser(row: any): User {
    const emailResult = Email.create(row.email);
    if (emailResult.isFailure) {
      throw new Error(`Invalid email in database: ${row.email}`);
    }

    const password = Password.fromHash(row.password_hash);

    return new User(
      row.id,
      emailResult.value,
      password,
      row.first_name,
      row.last_name,
      row.role,
      new Date(row.created_at),
      new Date(row.updated_at),
      row.is_active,
      row.vk_id
    );
  }

  private mapUserToRow(user: User): any {
    return {
      id: user.id,
      email: user.email.value,
      password_hash: user.password.hash,
      first_name: user.firstName,
      last_name: user.lastName,
      role: user.role,
      is_active: user.isActive,
      vk_id: user.vkId,
      created_at: user.createdAt,
      updated_at: user.updatedAt,
    };
  }
}
