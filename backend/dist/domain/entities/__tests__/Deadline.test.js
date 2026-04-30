"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const Deadline_1 = require("../Deadline");
const DeadlineStatus_1 = require("../../value-objects/DeadlineStatus");
function makeDeadline(status = DeadlineStatus_1.DeadlineStatus.PENDING, daysFromNow = 5) {
    const dueDate = new Date(Date.now() + daysFromNow * 24 * 60 * 60 * 1000);
    return new Deadline_1.Deadline("deadline-1", "Контрольная по математике", "Решить задачи на производные", dueDate, "user-1", status, new Date());
}
describe("Deadline Entity", () => {
    describe("complete", () => {
        it("должен переводить статус в COMPLETED", () => {
            const deadline = makeDeadline(DeadlineStatus_1.DeadlineStatus.PENDING);
            const result = deadline.complete();
            expect(result.isSuccess).toBe(true);
            expect(deadline.status).toBe(DeadlineStatus_1.DeadlineStatus.COMPLETED);
            expect(deadline.completedAt).toBeDefined();
        });
        it("должен обновлять updatedAt при завершении", () => {
            const deadline = makeDeadline(DeadlineStatus_1.DeadlineStatus.PENDING);
            const before = deadline.updatedAt;
            deadline.complete();
            expect(deadline.updatedAt).not.toBe(before);
        });
        it("должен возвращать ошибку если дедлайн уже завершён", () => {
            const deadline = makeDeadline(DeadlineStatus_1.DeadlineStatus.COMPLETED);
            const result = deadline.complete();
            expect(result.isFailure).toBe(true);
            expect(result.error).toBe("Deadline already completed");
        });
    });
    describe("uncomplete", () => {
        it("должен переводить статус обратно в PENDING", () => {
            const deadline = makeDeadline(DeadlineStatus_1.DeadlineStatus.COMPLETED);
            const result = deadline.uncomplete();
            expect(result.isSuccess).toBe(true);
            expect(deadline.status).toBe(DeadlineStatus_1.DeadlineStatus.PENDING);
            expect(deadline.completedAt).toBeUndefined();
        });
        it("должен возвращать ошибку если дедлайн уже в PENDING", () => {
            const deadline = makeDeadline(DeadlineStatus_1.DeadlineStatus.PENDING);
            const result = deadline.uncomplete();
            expect(result.isFailure).toBe(true);
            expect(result.error).toBe("Deadline is not completed");
        });
    });
    describe("isOverdue", () => {
        it("должен возвращать false для будущего дедлайна", () => {
            const deadline = makeDeadline(DeadlineStatus_1.DeadlineStatus.PENDING, 5);
            expect(deadline.isOverdue()).toBe(false);
        });
        it("должен возвращать true для просроченного дедлайна", () => {
            const deadline = makeDeadline(DeadlineStatus_1.DeadlineStatus.PENDING, -1);
            expect(deadline.isOverdue()).toBe(true);
        });
        it("должен возвращать false для завершённого дедлайна даже если срок прошёл", () => {
            const deadline = makeDeadline(DeadlineStatus_1.DeadlineStatus.COMPLETED, -1);
            expect(deadline.isOverdue()).toBe(false);
        });
    });
    describe("getDaysLeft", () => {
        it("должен возвращать положительное число для будущего дедлайна", () => {
            const deadline = makeDeadline(DeadlineStatus_1.DeadlineStatus.PENDING, 3);
            expect(deadline.getDaysLeft()).toBeGreaterThan(0);
        });
        it("должен возвращать отрицательное число для просроченного дедлайна", () => {
            const deadline = makeDeadline(DeadlineStatus_1.DeadlineStatus.PENDING, -2);
            expect(deadline.getDaysLeft()).toBeLessThan(0);
        });
    });
    describe("changeTitle", () => {
        it("должен изменять название дедлайна", () => {
            const deadline = makeDeadline();
            const result = deadline.changeTitle("Новое название");
            expect(result.isSuccess).toBe(true);
            expect(deadline.title).toBe("Новое название");
        });
        it("должен отклонять пустое название", () => {
            const deadline = makeDeadline();
            const result = deadline.changeTitle("   ");
            expect(result.isFailure).toBe(true);
            expect(result.error).toBe("Invalid title");
        });
    });
    describe("extend", () => {
        it("должен переносить дедлайн на более позднюю дату", () => {
            const deadline = makeDeadline(DeadlineStatus_1.DeadlineStatus.PENDING, 3);
            const newDate = new Date(deadline.dueDate.getTime() + 7 * 24 * 60 * 60 * 1000);
            const result = deadline.extend(newDate);
            expect(result.isSuccess).toBe(true);
            expect(deadline.dueDate).toEqual(newDate);
        });
        it("должен отклонять перенос на более раннюю дату", () => {
            const deadline = makeDeadline(DeadlineStatus_1.DeadlineStatus.PENDING, 5);
            const earlierDate = new Date(deadline.dueDate.getTime() - 2 * 24 * 60 * 60 * 1000);
            const result = deadline.extend(earlierDate);
            expect(result.isFailure).toBe(true);
            expect(result.error).toBe("New date must be later than current date");
        });
        it("должен отклонять перенос на ту же дату", () => {
            const deadline = makeDeadline(DeadlineStatus_1.DeadlineStatus.PENDING, 5);
            const sameDate = new Date(deadline.dueDate.getTime());
            const result = deadline.extend(sameDate);
            expect(result.isFailure).toBe(true);
        });
    });
});
