/*
 * In-memory schedule repository with realistic weekly timetable
 * Contains 5-7 lessons per day for 7 days
 */

import { Schedule } from "../../../domain/entities/Schedule";
import { Lesson } from "../../../domain/entities/Lesson";
import { IScheduleRepository } from "../../../domain/repositories/IScheduleRepository";
import { Result } from "../../../shared/Result";
import { TimeSlot } from "../../../domain/value-objects/TimeSlot";
import { Room } from "../../../domain/value-objects/Room";

export class MockScheduleRepository implements IScheduleRepository {
  private schedules: Schedule[] = [];

  constructor() {
    this.initializeTestData();
  }

  private initializeTestData(): void {
    // создаем расписание для группы
    const groupId = "10A-Math";
    const startDate = new Date("2024-01-22");

    for (let dayOffset = 0; dayOffset < 7; dayOffset++) {
      const currentDate = new Date(startDate);
      currentDate.setDate(currentDate.getDate() + dayOffset);

      const lessons = this.generateLessonsForDay(dayOffset);

      const schedule = new Schedule(
        `schedule-${dayOffset}`,
        groupId,
        currentDate,
        lessons,
        new Date("2024-01-01")
      );

      this.schedules.push(schedule);
    }
  }

  private generateLessonsForDay(dayOfWeek: number): Lesson[] {
    const lessons: Lesson[] = [];
    const roomResult = Room.create("301", "A", 3);
    const room = roomResult.isSuccess ? roomResult.value : null;

    if (!room) return lessons;

    // Define lesson structure: different subjects for different days
    const scheduleByDay = {
      0: [
        { subject: "Математика", time: "09:00-10:00", teacherId: "teacher-1", hasHomework: true },
        { subject: "Русский язык", time: "10:10-11:10", teacherId: "teacher-2", hasHomework: true },
        { subject: "История", time: "11:20-12:20", teacherId: "teacher-1", hasHomework: false },
        { subject: "Физика", time: "12:30-13:30", teacherId: "teacher-2", hasHomework: true },
        { subject: "Литература", time: "14:00-15:00", teacherId: "teacher-1", hasHomework: false },
        { subject: "Физкультура", time: "15:10-16:10", teacherId: "teacher-2", hasHomework: false },
      ],
      1: [
        { subject: "Русский язык", time: "09:00-10:00", teacherId: "teacher-2", hasHomework: true },
        { subject: "Математика", time: "10:10-11:10", teacherId: "teacher-1", hasHomework: true },
        { subject: "Английский язык", time: "11:20-12:20", teacherId: "teacher-2", hasHomework: true },
        { subject: "Химия", time: "12:30-13:30", teacherId: "teacher-1", hasHomework: false },
        { subject: "Биология", time: "14:00-15:00", teacherId: "teacher-2", hasHomework: true },
      ],
      2: [
        { subject: "Математика", time: "09:00-10:00", teacherId: "teacher-1", hasHomework: true },
        { subject: "Информатика", time: "10:10-11:10", teacherId: "teacher-2", hasHomework: true },
        { subject: "История", time: "11:20-12:20", teacherId: "teacher-1", hasHomework: false },
        { subject: "Обществознание", time: "12:30-13:30", teacherId: "teacher-2", hasHomework: false },
        { subject: "География", time: "14:00-15:00", teacherId: "teacher-1", hasHomework: true },
        { subject: "ОБЖ", time: "15:10-16:10", teacherId: "teacher-2", hasHomework: false },
      ],
      3: [
        { subject: "Литература", time: "09:00-10:00", teacherId: "teacher-1", hasHomework: true },
        { subject: "Английский язык", time: "10:10-11:10", teacherId: "teacher-2", hasHomework: true },
        { subject: "Математика", time: "11:20-12:20", teacherId: "teacher-1", hasHomework: true },
        { subject: "Физика", time: "12:30-13:30", teacherId: "teacher-2", hasHomework: false },
        { subject: "Музыка", time: "14:00-15:00", teacherId: "teacher-1", hasHomework: false },
      ],
      4: [
        { subject: "Русский язык", time: "09:00-10:00", teacherId: "teacher-2", hasHomework: false },
        { subject: "Математика", time: "10:10-11:10", teacherId: "teacher-1", hasHomework: true },
        { subject: "Физкультура", time: "11:20-12:20", teacherId: "teacher-2", hasHomework: false },
        { subject: "Изобразительное искусство", time: "12:30-13:30", teacherId: "teacher-1", hasHomework: false },
        { subject: "Технология", time: "14:00-15:00", teacherId: "teacher-2", hasHomework: true },
      ],
      5: [
        { subject: "Математика", time: "09:00-10:00", teacherId: "teacher-1", hasHomework: false },
        { subject: "Русский язык", time: "10:10-11:10", teacherId: "teacher-2", hasHomework: false },
        { subject: "Проектная деятельность", time: "11:20-12:50", teacherId: "teacher-1", hasHomework: false },
      ],
      6: [
      ],
    };

    const dayLessons = scheduleByDay[dayOfWeek as keyof typeof scheduleByDay] || [];

    dayLessons.forEach((lesson, index) => {
      const [startTime, endTime] = lesson.time.split("-");
      const timeSlotResult = TimeSlot.create(startTime, endTime);

      if (timeSlotResult.isSuccess) {
        const lessonObj = new Lesson(
          `lesson-${dayOfWeek}-${index}`,
          lesson.subject,
          lesson.teacherId,
          timeSlotResult.value,
          room,
          3,
          lesson.hasHomework
        );
        lessons.push(lessonObj);
      }
    });

    return lessons;
  }

  async getScheduleByGroup(groupId: string): Promise<Result<Schedule | null>> {
    const schedule = this.schedules.find((s) => s.groupId === groupId);
    return Result.ok(schedule || null);
  }

  async getScheduleByDate(groupId: string, date: Date): Promise<Result<Schedule | null>> {
    const schedule = this.schedules.find((s) => {
      return (
        s.groupId === groupId &&
        s.date.getFullYear() === date.getFullYear() &&
        s.date.getMonth() === date.getMonth() &&
        s.date.getDate() === date.getDate()
      );
    });
    return Result.ok(schedule || null);
  }

  async save(schedule: Schedule): Promise<Result<void>> {
    const existingIndex = this.schedules.findIndex((s) => s.id === schedule.id);
    if (existingIndex >= 0) {
      this.schedules[existingIndex] = schedule;
    } else {
      this.schedules.push(schedule);
    }
    return Result.ok();
  }
}
