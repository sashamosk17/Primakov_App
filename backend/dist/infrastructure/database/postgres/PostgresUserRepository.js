"use strict";
/**
 * PostgreSQL implementation of IUserRepository
 *
 * Handles user persistence with PostgreSQL database.
 * Maps between database rows and User domain entities.
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.PostgresUserRepository = void 0;
const User_1 = require("../../../domain/entities/User");
const Result_1 = require("../../../shared/Result");
const Email_1 = require("../../../domain/value-objects/Email");
const Password_1 = require("../../../domain/value-objects/Password");
class PostgresUserRepository {
    constructor(pool) {
        this.pool = pool;
    }
    async findById(id) {
        try {
            const query = `
        SELECT id, email, password_hash, first_name, last_name, role,
               is_active, vk_id, created_at, updated_at
        FROM users
        WHERE id = $1 AND deleted_at IS NULL
      `;
            const result = await this.pool.query(query, [id]);
            if (result.rows.length === 0) {
                return Result_1.Result.ok(null);
            }
            const user = this.mapRowToUser(result.rows[0]);
            return Result_1.Result.ok(user);
        }
        catch (error) {
            console.error("Error finding user by id:", error);
            return Result_1.Result.fail("Failed to find user");
        }
    }
    async findByEmail(email) {
        try {
            const query = `
        SELECT id, email, password_hash, first_name, last_name, role,
               is_active, vk_id, created_at, updated_at
        FROM users
        WHERE email = $1 AND deleted_at IS NULL
      `;
            const result = await this.pool.query(query, [email.toLowerCase()]);
            if (result.rows.length === 0) {
                return Result_1.Result.ok(null);
            }
            const user = this.mapRowToUser(result.rows[0]);
            return Result_1.Result.ok(user);
        }
        catch (error) {
            console.error("Error finding user by email:", error);
            return Result_1.Result.fail("Failed to find user");
        }
    }
    async findByRole(role) {
        try {
            const query = `
        SELECT id, email, password_hash, first_name, last_name, role,
               is_active, vk_id, created_at, updated_at
        FROM users
        WHERE role = $1 AND is_active = true AND deleted_at IS NULL
        ORDER BY last_name, first_name
      `;
            const result = await this.pool.query(query, [role]);
            const users = result.rows.map(row => this.mapRowToUser(row));
            return Result_1.Result.ok(users);
        }
        catch (error) {
            console.error("Error finding users by role:", error);
            return Result_1.Result.fail("Failed to find users by role");
        }
    }
    async save(user) {
        try {
            // Check if user exists
            const existsQuery = "SELECT id FROM users WHERE id = $1";
            const existsResult = await this.pool.query(existsQuery, [user.id]);
            if (existsResult.rows.length > 0) {
                // Update existing user
                const updateQuery = `
          UPDATE users
          SET email = $2,
              password_hash = $3,
              first_name = $4,
              last_name = $5,
              role = $6,
              is_active = $7,
              vk_id = $8,
              updated_at = NOW()
          WHERE id = $1
        `;
                await this.pool.query(updateQuery, [
                    user.id,
                    user.email.value,
                    user.password.hash,
                    user.firstName,
                    user.lastName,
                    user.role,
                    user.isActive,
                    user.vkId || null,
                ]);
            }
            else {
                // Insert new user
                const insertQuery = `
          INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, vk_id, created_at, updated_at)
          VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
        `;
                await this.pool.query(insertQuery, [
                    user.id,
                    user.email.value,
                    user.password.hash,
                    user.firstName,
                    user.lastName,
                    user.role,
                    user.isActive,
                    user.vkId || null,
                    user.createdAt,
                    user.updatedAt,
                ]);
            }
            return Result_1.Result.ok();
        }
        catch (error) {
            console.error("Error saving user:", error);
            return Result_1.Result.fail("Failed to save user");
        }
    }
    /**
     * Map database row to User entity
     * Reconstructs value objects (Email, Password) from stored data
     */
    mapRowToUser(row) {
        const emailResult = Email_1.Email.create(row.email);
        if (emailResult.isFailure) {
            throw new Error(`Invalid email in database: ${row.email}`);
        }
        const password = Password_1.Password.fromHash(row.password_hash);
        return new User_1.User(row.id, emailResult.value, password, row.first_name, row.last_name, row.role, new Date(row.created_at), new Date(row.updated_at), row.is_active, row.vk_id);
    }
}
exports.PostgresUserRepository = PostgresUserRepository;
