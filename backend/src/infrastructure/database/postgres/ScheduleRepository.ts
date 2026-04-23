import { Pool } from "pg";
import { IScheduleRepository } from "../../../domain/repositories/IScheduleRepository";
import { Result } from "../../../shared/Result";
import { Schedule } from "../../../domain/entities/Schedule";
import { Lesson } from "../../../domain/entities/Lesson";
import { TimeSlot } from "../../../domain/value-objects/TimeSlot";
import { Room } from "../../../domain/value-objects/Room";

export class ScheduleRepository implements IScheduleRepository {
  constructor(private pool: Pool) {}

  async getScheduleByGroup(groupId: string): Promise<Result<Schedule | null>> {
    try {
      const scheduleResult = await this.pool.query(
        "SELECT * FROM schedules WHERE group_id = $1 ORDER BY date DESC LIMIT 1",
        [groupId]
      );
      if (scheduleResult.rows.length === 0) return Result.ok(null);
      
      const scheduleRow = scheduleResult.rows[0];
      const lessonsResult = await this.pool.query(
        "SELECT * FROM lessons WHERE schedule_id = $1",
        [scheduleRow.id]
      );
      
      return Result.ok(this.mapToSchedule(scheduleRow, lessonsResult.rows));
    } catch (e: any) {
      return Result.fail(e.message);
    }
  }

  async getScheduleByDate(groupId: string, date: Date): Promise<Result<Schedule | null>> {
    try {
      const scheduleResult = await this.pool.query(
        "SELECT * FROM schedules WHERE group_id = $1 AND date::date = $2::date",
        [groupId, date]
      );
      if (scheduleResult.rows.length === 0) return Result.ok(null);
      
      const scheduleRow = scheduleResult.rows[0];
      const lessonsResult = await this.pool.query(
        "SELECT * FROM lessons WHERE schedule_id = $1",
        [scheduleRow.id]
      );
      
      return Result.ok(this.mapToSchedule(scheduleRow, lessonsResult.rows));
    } catch (e: any) {
      return Result.fail(e.message);
    }
  }

  async save(schedule: Schedule): Promise<Result<void>> {
    const client = await this.pool.connect();
    try {
      await client.query("BEGIN");
      
      await client.query(
        "INSERT INTO schedules (id, group_id, date, created_at, updated_at) VALUES ($1, $2, $3, $4, $5) ON CONFLICT (id) DO UPDATE SET group_id = $2, date = $3, updated_at = $5",
        [schedule.id, schedule.groupId, schedule.date, schedule.createdAt, schedule.updatedAt]
      );

      // delete existing lessons and re-insert
      await client.query("DELETE FROM lessons WHERE schedule_id = $1", [schedule.id]);

      for (const lesson of schedule.lessons) {
        await client.query(
          "INSERT INTO lessons (id, schedule_id, subject, teacher_id, start_time, end_time, room_number, room_building, floor, has_homework) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)",
          [
            lesson.id, schedule.id, lesson.subject, lesson.teacherId, 
            lesson.timeSlot.startTime, lesson.timeSlot.endTime,
            lesson.room.number, lesson.room.building, lesson.floor, lesson.hasHomework
          ]
        );
      }

      await client.query("COMMIT");
      return Result.ok();
    } catch (e: any) {
      await client.query("ROLLBACK");
      return Result.fail(e.message);
    } finally {
      client.release();
    }
  }

  private mapToSchedule(scheduleRow: any, lessonRows: any[]): Schedule {
    const lessons = lessonRows.map(l => {
      const timeSlotRes = TimeSlot.create(l.start_time, l.end_time);
      const roomRes = Room.create(l.room_number, l.room_building, l.floor);
      // Fallbacks in case of old dummy data breaking value objects
      const timeSlot = timeSlotRes.isSuccess ? timeSlotRes.value : TimeSlot.create("08:00", "08:45").value;
      const room = roomRes.isSuccess ? roomRes.value : Room.create("101", l.room_building || "Main", l.floor || 1).value;
      return new Lesson(l.id, l.subject, l.teacher_id, timeSlot, room, l.floor, l.has_homework);
    });

    return new Schedule(
      scheduleRow.id,
      scheduleRow.group_id,
      new Date(scheduleRow.date),
      lessons,
      new Date(scheduleRow.created_at),
      new Date(scheduleRow.updated_at)
    );
  }
}
