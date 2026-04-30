"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const Room_1 = require("../Room");
describe("Room Value Object", () => {
    describe("create", () => {
        it("должен создавать аудиторию с валидными данными", () => {
            const result = Room_1.Room.create("301", "A", 3);
            expect(result.isSuccess).toBe(true);
            expect(result.value.number).toBe("301");
            expect(result.value.building).toBe("A");
            expect(result.value.floor).toBe(3);
        });
        it("должен принимать аудиторию на первом этаже", () => {
            const result = Room_1.Room.create("101", "Главный", 1);
            expect(result.isSuccess).toBe(true);
        });
        it("должен отклонять аудиторию без номера", () => {
            const result = Room_1.Room.create("", "A", 3);
            expect(result.isFailure).toBe(true);
            expect(result.error).toBe("Invalid room");
        });
        it("должен отклонять аудиторию без здания", () => {
            const result = Room_1.Room.create("301", "", 3);
            expect(result.isFailure).toBe(true);
            expect(result.error).toBe("Invalid room");
        });
        it("должен отклонять аудиторию с NaN этажом", () => {
            const result = Room_1.Room.create("301", "A", NaN);
            expect(result.isFailure).toBe(true);
            expect(result.error).toBe("Invalid room");
        });
    });
    describe("fullName", () => {
        it("должен возвращать полное название аудитории", () => {
            const room = Room_1.Room.create("301", "A", 3).value;
            expect(room.fullName()).toBe("301-A, floor 3");
        });
        it("должен корректно формировать название с буквенным обозначением", () => {
            const room = Room_1.Room.create("Актовый зал", "Главный", 2).value;
            expect(room.fullName()).toBe("Актовый зал-Главный, floor 2");
        });
    });
});
