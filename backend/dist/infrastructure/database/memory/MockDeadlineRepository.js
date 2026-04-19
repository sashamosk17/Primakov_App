"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.MockDeadlineRepository = void 0;
const Deadline_1 = require("../../../domain/entities/Deadline");
const Result_1 = require("../../../shared/Result");
const DeadlineStatus_1 = require("../../../domain/value-objects/DeadlineStatus");
const crypto_1 = require("crypto");
class MockDeadlineRepository {
    constructor() {
        this.deadlines = [];
        this.initializeMockData();
    }
    initializeMockData() {
        const today = new Date();
        const subjects = ["Математика", "Русский язык", "История", "Физика", "Химия", "Литература"];
        const defaultUserId = "user-1";
        const mockDeadlines = [
            {
                id: (0, crypto_1.randomUUID)(),
                title: "Реферат по истории",
                description: "Написать реферат про Французскую революцию",
                dueDate: new Date(today.getTime() + 3 * 24 * 60 * 60 * 1000),
                userId: defaultUserId,
                status: DeadlineStatus_1.DeadlineStatus.PENDING,
                subject: subjects[2],
            },
            {
                id: (0, crypto_1.randomUUID)(),
                title: "Задачи по математике",
                description: "Решить задачи с параграфа 5.3",
                dueDate: new Date(today.getTime() + 1 * 24 * 60 * 60 * 1000),
                userId: defaultUserId,
                status: DeadlineStatus_1.DeadlineStatus.PENDING,
                subject: subjects[0],
            },
            {
                id: (0, crypto_1.randomUUID)(),
                title: "Проект по физике",
                description: "Провести эксперимент и написать отчет",
                dueDate: new Date(today.getTime() + 7 * 24 * 60 * 60 * 1000),
                userId: defaultUserId,
                status: DeadlineStatus_1.DeadlineStatus.PENDING,
                subject: subjects[3],
            },
            {
                id: (0, crypto_1.randomUUID)(),
                title: "Сочинение на русском",
                description: "Написать сочинение на тему 'Моя семья'",
                dueDate: new Date(today.getTime() + 2 * 24 * 60 * 60 * 1000),
                userId: defaultUserId,
                status: DeadlineStatus_1.DeadlineStatus.PENDING,
                subject: subjects[1],
            },
            {
                id: (0, crypto_1.randomUUID)(),
                title: "Практическая работа по химии",
                description: "Провести опыт и оформить результаты",
                dueDate: new Date(today.getTime() + 5 * 24 * 60 * 60 * 1000),
                userId: defaultUserId,
                status: DeadlineStatus_1.DeadlineStatus.PENDING,
                subject: subjects[4],
            },
            {
                id: (0, crypto_1.randomUUID)(),
                title: "Анализ стихотворения",
                description: "Проанализировать произведение Пушкина",
                dueDate: new Date(today.getTime() + 4 * 24 * 60 * 60 * 1000),
                userId: defaultUserId,
                status: DeadlineStatus_1.DeadlineStatus.COMPLETED,
                subject: subjects[5],
            },
        ];
        mockDeadlines.forEach((data) => {
            const deadline = new Deadline_1.Deadline(data.id, data.title, data.description, data.dueDate, data.userId, data.status, today, data.status === DeadlineStatus_1.DeadlineStatus.COMPLETED ? today : undefined, undefined, data.subject);
            this.deadlines.push(deadline);
        });
    }
    async getByUser(userId) {
        return Result_1.Result.ok(this.deadlines.filter((d) => d.userId === userId));
    }
    async findById(id) {
        return this.deadlines.find((d) => d.id === id);
    }
    async save(deadline) {
        this.deadlines.push(deadline);
        return Result_1.Result.ok();
    }
    async update(deadline) {
        const index = this.deadlines.findIndex((d) => d.id === deadline.id);
        if (index >= 0) {
            this.deadlines[index] = deadline;
        }
        return Result_1.Result.ok();
    }
}
exports.MockDeadlineRepository = MockDeadlineRepository;
