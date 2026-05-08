"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const TimeSlot_1 = require("../TimeSlot");
describe("TimeSlot Value Object", () => {
    describe("create", () => {
        it("должен создавать временной слот с валидными данными", () => {
            const result = TimeSlot_1.TimeSlot.create("09:00", "10:30");
            expect(result.isSuccess).toBe(true);
            expect(result.value.startTime).toBe("09:00");
            expect(result.value.endTime).toBe("10:30");
        });
        it("должен отклонять слот без начального времени", () => {
            const result = TimeSlot_1.TimeSlot.create("", "10:30");
            expect(result.isFailure).toBe(true);
            expect(result.error).toBe("Invalid time slot");
        });
        it("должен отклонять слот без конечного времени", () => {
            const result = TimeSlot_1.TimeSlot.create("09:00", "");
            expect(result.isFailure).toBe(true);
            expect(result.error).toBe("Invalid time slot");
        });
    });
    describe("durationMinutes", () => {
        it("должен рассчитывать продолжительность урока (90 минут)", () => {
            const slot = TimeSlot_1.TimeSlot.create("09:00", "10:30").value;
            expect(slot.durationMinutes()).toBe(90);
        });
        it("должен рассчитывать продолжительность 45-минутного урока", () => {
            const slot = TimeSlot_1.TimeSlot.create("11:00", "11:45").value;
            expect(slot.durationMinutes()).toBe(45);
        });
        it("должен рассчитывать продолжительность перемены (10 минут)", () => {
            const slot = TimeSlot_1.TimeSlot.create("10:30", "10:40").value;
            expect(slot.durationMinutes()).toBe(10);
        });
    });
    describe("overlaps", () => {
        it("должен определять пересечение слотов", () => {
            const slot1 = TimeSlot_1.TimeSlot.create("09:00", "10:30").value;
            const slot2 = TimeSlot_1.TimeSlot.create("10:00", "11:30").value;
            expect(slot1.overlaps(slot2)).toBe(true);
        });
        it("должен возвращать false для непересекающихся слотов", () => {
            const slot1 = TimeSlot_1.TimeSlot.create("09:00", "10:30").value;
            const slot2 = TimeSlot_1.TimeSlot.create("11:00", "12:30").value;
            expect(slot1.overlaps(slot2)).toBe(false);
        });
        it("должен возвращать false для смежных слотов (конец = начало другого)", () => {
            const slot1 = TimeSlot_1.TimeSlot.create("09:00", "10:30").value;
            const slot2 = TimeSlot_1.TimeSlot.create("10:30", "12:00").value;
            expect(slot1.overlaps(slot2)).toBe(false);
        });
        it("должен определять пересечение когда один слот внутри другого", () => {
            const outer = TimeSlot_1.TimeSlot.create("09:00", "12:00").value;
            const inner = TimeSlot_1.TimeSlot.create("10:00", "11:00").value;
            expect(outer.overlaps(inner)).toBe(true);
        });
    });
});
