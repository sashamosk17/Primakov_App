"use strict";
/**
 * PostgreSQL implementation of IScheduleRepository
 *
 * Handles schedule and lesson persistence with PostgreSQL database.
 * Manages the one-to-many relationship between schedules and lessons.
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.PostgresScheduleRepository = void 0;
const Schedule_1 = require("../../../domain/entities/Schedule");
const Lesson_1 = require("../../../domain/entities/Lesson");
const Result_1 = require("../../../shared/Result");
const TimeSlot_1 = require("../../../domain/value-objects/TimeSlot");
const Room_1 = require("../../../domain/value-objects/Room");
class PostgresScheduleRepository {
    constructor(pool) {
        this.pool = pool;
    }
    async getScheduleByGroup(groupId) {
        // Note: groupId is actually userId in current implementation
        try {
            const scheduleQuery = `
        SELECT id, user_id, date, created_at, updated_at
        FROM schedules
        WHERE user_id = $1
        ORDER BY date DESC
        LIMIT 1
      `;
            const scheduleResult = await this.pool.query(scheduleQuery, [groupId]);
            if (scheduleResult.rows.length === 0) {
                return Result_1.Result.ok(null);
            }
            const scheduleRow = scheduleResult.rows[0];
            const lessons = await this.getLessonsByScheduleId(scheduleRow.id);
            const schedule = new Schedule_1.Schedule(scheduleRow.id, scheduleRow.user_id, new Date(scheduleRow.date), lessons, new Date(scheduleRow.created_at), new Date(scheduleRow.updated_at));
            return Result_1.Result.ok(schedule);
        }
        catch (error) {
            console.error("Error getting schedule by group:", error);
            return Result_1.Result.fail("Failed to get schedule");
        }
    }
    async getScheduleByDate(groupId, date) {
        try {
            // Format date as YYYY-MM-DD for comparison
            const dateString = date.toISOString().split("T")[0];
            const scheduleQuery = `
        SELECT id, user_id, date, created_at, updated_at
        FROM schedules
        WHERE user_id = $1 AND date = $2
      `;
            const scheduleResult = await this.pool.query(scheduleQuery, [groupId, dateString]);
            if (scheduleResult.rows.length === 0) {
                return Result_1.Result.ok(null);
            }
            const scheduleRow = scheduleResult.rows[0];
            const lessons = await this.getLessonsByScheduleId(scheduleRow.id);
            const schedule = new Schedule_1.Schedule(scheduleRow.id, scheduleRow.user_id, new Date(scheduleRow.date), lessons, new Date(scheduleRow.created_at), new Date(scheduleRow.updated_at));
            return Result_1.Result.ok(schedule);
        }
        catch (error) {
            console.error("Error getting schedule by date:", error);
            return Result_1.Result.fail("Failed to get schedule");
        }
    }
    async getScheduleByUserId(userId, date) {
        // In PostgreSQL implementation groupId column stores userId, so this is equivalent
        return this.getScheduleByDate(userId, date);
    }
    async save(schedule) {
        const client = await this.pool.connect();
        try {
            await client.query("BEGIN");
            // Check if schedule exists
            const existsQuery = "SELECT id FROM schedules WHERE id = $1";
            const existsResult = await client.query(existsQuery, [schedule.id]);
            if (existsResult.rows.length > 0) {
                // Update existing schedule
                const updateQuery = `
          UPDATE schedules
          SET user_id = $2,
              date = $3,
              updated_at = NOW()
          WHERE id = $1
        `;
                await client.query(updateQuery, [
                    schedule.id,
                    schedule.groupId,
                    schedule.date.toISOString().split("T")[0],
                ]);
                // Delete existing lessons
                await client.query("DELETE FROM lessons WHERE schedule_id = $1", [schedule.id]);
            }
            else {
                // Insert new schedule
                const insertQuery = `
          INSERT INTO schedules (id, user_id, date, created_at, updated_at)
          VALUES ($1, $2, $3, $4, $5)
        `;
                await client.query(insertQuery, [
                    schedule.id,
                    schedule.groupId,
                    schedule.date.toISOString().split("T")[0],
                    schedule.createdAt,
                    schedule.updatedAt,
                ]);
            }
            // Insert lessons
            for (const lesson of schedule.lessons) {
                await this.saveLesson(client, lesson, schedule.id);
            }
            await client.query("COMMIT");
            return Result_1.Result.ok();
        }
        catch (error) {
            await client.query("ROLLBACK");
            console.error("Error saving schedule:", error);
            return Result_1.Result.fail("Failed to save schedule");
        }
        finally {
            client.release();
        }
    }
    /**
     * Get all lessons for a schedule
     */
    async getLessonsByScheduleId(scheduleId) {
        const query = `
      SELECT id, schedule_id, subject, teacher_id, start_time, end_time,
             room_number, room_building, room_floor, has_homework, created_at
      FROM lessons
      WHERE schedule_id = $1
      ORDER BY start_time
    `;
        const result = await this.pool.query(query, [scheduleId]);
        return result.rows.map((row) => this.mapRowToLesson(row));
    }
    /**
     * Save a single lesson
     */
    async saveLesson(client, lesson, scheduleId) {
        const query = `
      INSERT INTO lessons (id, schedule_id, subject, teacher_id, start_time, end_time,
                          room_number, room_building, room_floor, has_homework, created_at)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, NOW())
    `;
        await client.query(query, [
            lesson.id,
            scheduleId,
            lesson.subject,
            lesson.teacherId,
            lesson.timeSlot.startTime,
            lesson.timeSlot.endTime,
            lesson.room.number,
            lesson.room.building,
            lesson.room.floor,
            lesson.hasHomework,
        ]);
    }
    /**
     * Map database row to Lesson entity
     * Reconstructs TimeSlot and Room value objects
     */
    mapRowToLesson(row) {
        const timeSlotResult = TimeSlot_1.TimeSlot.create(row.start_time, row.end_time);
        if (timeSlotResult.isFailure) {
            throw new Error(`Invalid time slot in database: ${row.start_time} - ${row.end_time}`);
        }
        const roomResult = Room_1.Room.create(row.room_number, row.room_building, row.room_floor);
        if (roomResult.isFailure) {
            throw new Error(`Invalid room in database: ${row.room_number}`);
        }
        return new Lesson_1.Lesson(row.id, row.subject, row.teacher_id, timeSlotResult.value, roomResult.value, row.room_floor, row.has_homework);
    }
}
exports.PostgresScheduleRepository = PostgresScheduleRepository;
