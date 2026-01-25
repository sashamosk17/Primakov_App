"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Schedule = void 0;
class Schedule {
    constructor(id, groupId, date, lessons, createdAt, updatedAt) {
        this.id = id;
        this.groupId = groupId;
        this.date = date;
        this.lessons = lessons;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt ?? createdAt;
    }
    getLessonAt(timeSlot) {
        return this.lessons.find((lesson) => lesson.timeSlot.overlaps(timeSlot)) || null;
    }
    isComplete() {
        return this.lessons.length > 0;
    }
    hasFreeSlot(timeSlot) {
        return !this.lessons.some((lesson) => lesson.timeSlot.overlaps(timeSlot));
    }
}
exports.Schedule = Schedule;
