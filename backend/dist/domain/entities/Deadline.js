"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Deadline = void 0;
const DeadlineStatus_1 = require("../value-objects/DeadlineStatus");
const Result_1 = require("../../shared/Result");
class Deadline {
    constructor(id, title, description, dueDate, userId, status, createdAt, updatedAt, completedAt, subject) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.dueDate = dueDate;
        this.userId = userId;
        this.status = status;
        this.createdAt = createdAt;
        this.completedAt = completedAt;
        this.subject = subject;
        this.updatedAt = updatedAt ?? createdAt;
    }
    complete() {
        if (this.status === DeadlineStatus_1.DeadlineStatus.COMPLETED) {
            return Result_1.Result.fail("Deadline already completed");
        }
        this.status = DeadlineStatus_1.DeadlineStatus.COMPLETED;
        this.completedAt = new Date();
        this.updatedAt = new Date();
        return Result_1.Result.ok();
    }
    isOverdue() {
        return this.status !== DeadlineStatus_1.DeadlineStatus.COMPLETED && new Date() > this.dueDate;
    }
    getDaysLeft() {
        const diff = this.dueDate.getTime() - new Date().getTime();
        return Math.ceil(diff / (1000 * 60 * 60 * 24));
    }
    changeTitle(newTitle) {
        if (!newTitle.trim()) {
            return Result_1.Result.fail("Invalid title");
        }
        this.title = newTitle;
        return Result_1.Result.ok();
    }
    extend(newDate) {
        if (newDate <= this.dueDate) {
            return Result_1.Result.fail("New date must be later than current date");
        }
        this.dueDate = newDate;
        return Result_1.Result.ok();
    }
}
exports.Deadline = Deadline;
