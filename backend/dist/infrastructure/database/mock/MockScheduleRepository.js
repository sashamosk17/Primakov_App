"use strict";
/*
 * In-memory schedule repository with realistic weekly timetable
 * Contains 5-7 lessons per day for 7 days
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.MockScheduleRepository = void 0;
/*
 * In-memory schedule repository with realistic weekly timetable
 * Now supports per-user schedules
 */
const Schedule_1 = require("../../../domain/entities/Schedule");
const Lesson_1 = require("../../../domain/entities/Lesson");
const Result_1 = require("../../../shared/Result");
const TimeSlot_1 = require("../../../domain/value-objects/TimeSlot");
const Room_1 = require("../../../domain/value-objects/Room");
class MockScheduleRepository {
    constructor() {
        this.schedules = [];
        this.initializeTestData();
    }
    initializeTestData() {
        // Создаем расписание для каждого пользователя
        const users = ['user-1', 'user-2', 'user-3'];
        users.forEach(userId => {
            // Создаем расписание на 7 дней текущей недели (начиная с понедельника)
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            // Находим понедельник текущей недели
            const day = today.getDay();
            const diff = today.getDate() - day + (day === 0 ? -6 : 1); // корректировка если сегодня воскресенье
            const monday = new Date(today.setDate(diff));
            for (let dayOffset = 0; dayOffset < 7; dayOffset++) {
                const currentDate = new Date(monday);
                currentDate.setDate(monday.getDate() + dayOffset);
                const dayOfWeek = currentDate.getDay();
                // Пропускаем воскресенье
                if (dayOfWeek === 0)
                    continue;
                const lessons = this.generateLessonsForDay(dayOfWeek, userId);
                const schedule = new Schedule_1.Schedule(`schedule-${userId}-${dayOffset}`, userId, // ← Теперь groupId = userId
                currentDate, lessons, new Date());
                this.schedules.push(schedule);
            }
        });
        console.log(`✅ Created ${this.schedules.length} schedules for users`);
    }
    generateLessonsForDay(dayOfWeek, userId) {
        const lessons = [];
        const roomResult = Room_1.Room.create("301", "A", 3);
        const room = roomResult.isSuccess ? roomResult.value : null;
        if (!room)
            return lessons;
        // Разное расписание для разных пользователей
        const getScheduleForUser = (userId, day) => {
            if (userId === 'user-1') {
                // Расписание для Ивана Петрова
                const schedules = {
                    1: [
                        { subject: "Математика", time: "09:00-09:45", teacherId: "teacher-1", hasHomework: true },
                        { subject: "Русский язык", time: "10:00-10:45", teacherId: "teacher-2", hasHomework: true },
                        { subject: "История", time: "11:00-11:45", teacherId: "teacher-1", hasHomework: false },
                        { subject: "Физика", time: "12:45-13:30", teacherId: "teacher-2", hasHomework: true },
                        { subject: "Химия", time: "13:45-14:30", teacherId: "teacher-1", hasHomework: false },
                    ],
                    2: [
                        { subject: "Английский язык", time: "09:00-09:45", teacherId: "teacher-2", hasHomework: true },
                        { subject: "Математика", time: "10:00-10:45", teacherId: "teacher-1", hasHomework: true },
                        { subject: "Информатика", time: "11:00-11:45", teacherId: "teacher-2", hasHomework: false },
                        { subject: "Литература", time: "12:45-13:30", teacherId: "teacher-1", hasHomework: true },
                    ],
                    3: [
                        { subject: "География", time: "09:00-09:45", teacherId: "teacher-1", hasHomework: false },
                        { subject: "Математика", time: "10:00-10:45", teacherId: "teacher-1", hasHomework: true },
                        { subject: "Физика", time: "11:00-11:45", teacherId: "teacher-2", hasHomework: true },
                        { subject: "ОБЖ", time: "12:45-13:30", teacherId: "teacher-2", hasHomework: false },
                    ],
                    4: [
                        { subject: "Русский язык", time: "09:00-09:45", teacherId: "teacher-2", hasHomework: true },
                        { subject: "Математика", time: "10:00-10:45", teacherId: "teacher-1", hasHomework: true },
                        { subject: "Биология", time: "11:00-11:45", teacherId: "teacher-1", hasHomework: false },
                        { subject: "Физкультура", time: "12:45-13:30", teacherId: "teacher-2", hasHomework: false },
                    ],
                    5: [
                        { subject: "Математика", time: "09:00-09:45", teacherId: "teacher-1", hasHomework: true },
                        { subject: "Русский язык", time: "10:00-10:45", teacherId: "teacher-2", hasHomework: false },
                        { subject: "Проектная деятельность", time: "11:00-12:30", teacherId: "teacher-1", hasHomework: false },
                    ],
                    6: [
                        { subject: "Факультатив по математике", time: "10:00-11:30", teacherId: "teacher-1", hasHomework: false },
                    ],
                };
                return schedules[day] || [];
            }
            else {
                // Расписание для других пользователей (стандартное)
                const defaultSchedules = {
                    1: [
                        { subject: "Математика", time: "09:00-09:45", teacherId: "teacher-1", hasHomework: true },
                        { subject: "Русский язык", time: "10:00-10:45", teacherId: "teacher-2", hasHomework: true },
                        { subject: "История", time: "11:00-11:45", teacherId: "teacher-1", hasHomework: false },
                    ],
                    2: [
                        { subject: "Физика", time: "09:00-09:45", teacherId: "teacher-2", hasHomework: true },
                        { subject: "Математика", time: "10:00-10:45", teacherId: "teacher-1", hasHomework: true },
                    ],
                    3: [
                        { subject: "Химия", time: "09:00-09:45", teacherId: "teacher-1", hasHomework: false },
                        { subject: "Биология", time: "10:00-10:45", teacherId: "teacher-2", hasHomework: true },
                    ],
                    4: [
                        { subject: "Литература", time: "09:00-09:45", teacherId: "teacher-1", hasHomework: true },
                        { subject: "Английский язык", time: "10:00-10:45", teacherId: "teacher-2", hasHomework: true },
                    ],
                    5: [
                        { subject: "Математика", time: "09:00-09:45", teacherId: "teacher-1", hasHomework: false },
                        { subject: "Физкультура", time: "10:00-10:45", teacherId: "teacher-2", hasHomework: false },
                    ],
                };
                return defaultSchedules[day] || [];
            }
        };
        const dayLessons = getScheduleForUser(userId, dayOfWeek);
        dayLessons.forEach((lesson, index) => {
            const [startTime, endTime] = lesson.time.split("-");
            const timeSlotResult = TimeSlot_1.TimeSlot.create(startTime, endTime);
            if (timeSlotResult.isSuccess) {
                const lessonObj = new Lesson_1.Lesson(`lesson-${userId}-${dayOfWeek}-${index}`, lesson.subject, lesson.teacherId, timeSlotResult.value, room, 3, lesson.hasHomework);
                lessons.push(lessonObj);
            }
        });
        return lessons;
    }
    async getScheduleByGroup(groupId) {
        const schedule = this.schedules.find((s) => s.groupId === groupId);
        return Result_1.Result.ok(schedule || null);
    }
    async getScheduleByDate(groupId, date) {
        console.log(`🔍 Looking for schedule: groupId=${groupId}, date=${date.toISOString()}`);
        // 🔥 ИСПРАВЛЕНИЕ: Сравниваем только дату без времени
        const schedule = this.schedules.find((s) => {
            // Получаем строку YYYY-MM-DD для обеих дат, избегая проблем с часовыми поясами
            const sDateString = new Date(s.date.getTime() - (s.date.getTimezoneOffset() * 60000))
                .toISOString().split('T')[0];
            const targetDateString = new Date(date.getTime() - (date.getTimezoneOffset() * 60000))
                .toISOString().split('T')[0];
            const isSameDate = (s.groupId === groupId && sDateString === targetDateString);
            if (isSameDate) {
                console.log(`✅ Found schedule for ${groupId} on ${targetDateString}`);
            }
            return isSameDate;
        });
        if (!schedule) {
            console.log(`❌ No schedule found for ${groupId} on ${date.toISOString().split('T')[0]}`);
            console.log(`📋 Available schedules for ${groupId}:`);
            this.schedules
                .filter(s => s.groupId === groupId)
                .forEach(s => console.log(`  - ${s.date.toISOString().split('T')[0]}`));
        }
        return Result_1.Result.ok(schedule || null);
    }
    async getScheduleByUserId(userId, date) {
        // In this mock, groupId = userId, so this is equivalent to getScheduleByDate
        return this.getScheduleByDate(userId, date);
    }
    async save(schedule) {
        const existingIndex = this.schedules.findIndex((s) => s.id === schedule.id);
        if (existingIndex >= 0) {
            this.schedules[existingIndex] = schedule;
        }
        else {
            this.schedules.push(schedule);
        }
        return Result_1.Result.ok();
    }
}
exports.MockScheduleRepository = MockScheduleRepository;
