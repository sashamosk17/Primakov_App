"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.MockScheduleRepository = void 0;
const Result_1 = require("../../../shared/Result");
const Schedule_1 = require("../../../domain/entities/Schedule");
class MockScheduleRepository {
    constructor() {
        this.schedules = [];
        this.initializeMockData();
    }
    initializeMockData() {
        // Добавляем mock расписание на неделю для группы 10A
        const today = new Date();
        const subjects = [
            { name: "Математика", room: 305, floor: 3 },
            { name: "Русский язык", room: 201, floor: 2 },
            { name: "История", room: 404, floor: 4 },
            { name: "Физика", room: 102, floor: 1 },
            { name: "Химия", room: 103, floor: 1 },
            { name: "Литература", room: 202, floor: 2 },
            { name: "Английский язык", room: 303, floor: 3 },
            { name: "Информатика", room: 501, floor: 5 },
        ];
        for (let dayOffset = 0; dayOffset < 6; dayOffset++) {
            const scheduleDate = new Date(today);
            scheduleDate.setDate(scheduleDate.getDate() + dayOffset);
            const lessons = [
                {
                    id: `lesson-${dayOffset}-1`,
                    subject: subjects[dayOffset % subjects.length].name,
                    startTime: "09:00",
                    endTime: "09:45",
                    room: subjects[dayOffset % subjects.length].room,
                    floor: subjects[dayOffset % subjects.length].floor,
                    hasHomework: Math.random() > 0.5,
                },
                {
                    id: `lesson-${dayOffset}-2`,
                    subject: subjects[(dayOffset + 1) % subjects.length].name,
                    startTime: "10:00",
                    endTime: "10:45",
                    room: subjects[(dayOffset + 1) % subjects.length].room,
                    floor: subjects[(dayOffset + 1) % subjects.length].floor,
                    hasHomework: Math.random() > 0.5,
                },
                {
                    id: `lesson-${dayOffset}-3`,
                    subject: subjects[(dayOffset + 2) % subjects.length].name,
                    startTime: "11:00",
                    endTime: "11:45",
                    room: subjects[(dayOffset + 2) % subjects.length].room,
                    floor: subjects[(dayOffset + 2) % subjects.length].floor,
                    hasHomework: Math.random() > 0.5,
                },
                {
                    id: `lesson-${dayOffset}-4`,
                    subject: subjects[(dayOffset + 3) % subjects.length].name,
                    startTime: "12:45",
                    endTime: "13:30",
                    room: subjects[(dayOffset + 3) % subjects.length].room,
                    floor: subjects[(dayOffset + 3) % subjects.length].floor,
                    hasHomework: Math.random() > 0.5,
                },
                {
                    id: `lesson-${dayOffset}-5`,
                    subject: subjects[(dayOffset + 4) % subjects.length].name,
                    startTime: "13:45",
                    endTime: "14:30",
                    room: subjects[(dayOffset + 4) % subjects.length].room,
                    floor: subjects[(dayOffset + 4) % subjects.length].floor,
                    hasHomework: Math.random() > 0.5,
                },
            ];
            const schedule = new Schedule_1.Schedule(`schedule-${dayOffset}`, "10A-Math", scheduleDate, lessons, new Date());
            this.schedules.push(schedule);
        }
    }
    async getScheduleByGroup(groupId) {
        const schedule = this.schedules.find((s) => s.groupId === groupId) || null;
        return Result_1.Result.ok(schedule);
    }
    async getScheduleByDate(groupId, date) {
        const schedule = this.schedules.find((s) => s.groupId === groupId && s.date.toDateString() === date.toDateString()) ||
            null;
        return Result_1.Result.ok(schedule);
    }
    async save(schedule) {
        this.schedules.push(schedule);
        return Result_1.Result.ok();
    }
}
exports.MockScheduleRepository = MockScheduleRepository;
