"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Lesson = void 0;
class Lesson {
    constructor(id, subject, teacherId, timeSlot, room, floor, hasHomework = false, homeworkDescription) {
        this.id = id;
        this.subject = subject;
        this.teacherId = teacherId;
        this.timeSlot = timeSlot;
        this.room = room;
        this.floor = floor;
        this.hasHomework = hasHomework;
        this.homeworkDescription = homeworkDescription;
    }
    isNow() {
        const now = new Date();
        const [sh, sm] = this.timeSlot.startTime.split(":").map(Number);
        const [eh, em] = this.timeSlot.endTime.split(":").map(Number);
        const start = new Date(now);
        start.setHours(sh, sm, 0, 0);
        const end = new Date(now);
        end.setHours(eh, em, 0, 0);
        return now >= start && now <= end;
    }
    isFinished() {
        const now = new Date();
        const [eh, em] = this.timeSlot.endTime.split(":").map(Number);
        const end = new Date(now);
        end.setHours(eh, em, 0, 0);
        return now > end;
    }
    getDuration() {
        return this.timeSlot.durationMinutes();
    }
}
exports.Lesson = Lesson;
