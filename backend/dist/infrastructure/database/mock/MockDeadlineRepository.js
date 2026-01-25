"use strict";
/*
 * In-memory deadline repository with realistic deadlines
 * Contains 10 active deadlines across different subjects and groups
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.MockDeadlineRepository = void 0;
const Deadline_1 = require("../../../domain/entities/Deadline");
const Result_1 = require("../../../shared/Result");
const DeadlineStatus_1 = require("../../../domain/value-objects/DeadlineStatus");
class MockDeadlineRepository {
    constructor() {
        this.deadlines = [];
        this.initializeTestData();
    }
    initializeTestData() {
        const userId = "user-1"; // For student user-1
        const today = new Date();
        const testDeadlines = [
            {
                title: "Эссе по Литературе",
                description: "Написать эссе на тему: 'Роль морали в романе Достоевского'",
                dueDate: new Date(today.getTime() + 4 * 24 * 60 * 60 * 1000), // 4 days
                subject: "Литература",
            },
            {
                title: "Лабораторная работа по Физике",
                description: "Провести опыт по закону сохранения энергии и подготовить отчет",
                dueDate: new Date(today.getTime() + 2 * 24 * 60 * 60 * 1000), // 2 days
                subject: "Физика",
            },
            {
                title: "Контрольная работа по Математике",
                description: "Пройти тест по производным и интегралам (10 задач)",
                dueDate: new Date(today.getTime() + 1 * 24 * 60 * 60 * 1000), // 1 day
                subject: "Математика",
            },
            {
                title: "Проект по Истории",
                description: "Создать презентацию о Российской Империи (XV-XVIII век)",
                dueDate: new Date(today.getTime() + 7 * 24 * 60 * 60 * 1000), // 7 days
                subject: "История",
            },
            {
                title: "Тестирование по Английскому языку",
                description: "Пройти тест на использование Present Perfect и Past Simple",
                dueDate: new Date(today.getTime() + 3 * 24 * 60 * 60 * 1000), // 3 days
                subject: "Английский язык",
            },
            {
                title: "Домашнее задание по Химии",
                description: "Решить задачи по расчету молярных масс веществ (стр. 234-235)",
                dueDate: new Date(today.getTime() + 1 * 24 * 60 * 60 * 1000), // 1 day
                subject: "Химия",
            },
            {
                title: "Реферат по Обществознанию",
                description: "Написать реферат на тему 'Гражданское общество в России' (10-12 стр.)",
                dueDate: new Date(today.getTime() + 10 * 24 * 60 * 60 * 1000), // 10 days
                subject: "Обществознание",
            },
            {
                title: "Программирование на Python",
                description: "Написать программу для сортировки массива (не менее 3 методов)",
                dueDate: new Date(today.getTime() + 5 * 24 * 60 * 60 * 1000), // 5 days
                subject: "Информатика",
            },
            {
                title: "Творческий проект по Музыке",
                description: "Составить плей-лист из 10 произведений разных эпох с описанием",
                dueDate: new Date(today.getTime() + 8 * 24 * 60 * 60 * 1000), // 8 days
                subject: "Музыка",
            },
            {
                title: "Доклад по Географии",
                description: "Подготовить доклад о климатических поясах Земли (5-7 минут)",
                dueDate: new Date(today.getTime() + 6 * 24 * 60 * 60 * 1000), // 6 days
                subject: "География",
            },
        ];
        testDeadlines.forEach((deadline, index) => {
            this.deadlines.push(new Deadline_1.Deadline(`deadline-${index + 1}`, deadline.title, deadline.description, deadline.dueDate, userId, DeadlineStatus_1.DeadlineStatus.PENDING, new Date(today.getTime() - (10 - index) * 24 * 60 * 60 * 1000), undefined, undefined, deadline.subject));
        });
        // Add some completed deadlines
        const completedDeadlines = [
            {
                title: "Презентация по Биологии",
                description: "Создать презентацию о системах органов человека",
                subject: "Биология",
            },
            {
                title: "Тест по Русскому языку",
                description: "Пройти тест на использование деепричастий",
                subject: "Русский язык",
            },
        ];
        completedDeadlines.forEach((deadline, index) => {
            const createdDate = new Date(today.getTime() - (15 + index) * 24 * 60 * 60 * 1000);
            const completedAt = new Date(createdDate.getTime() + 10 * 24 * 60 * 60 * 1000);
            this.deadlines.push(new Deadline_1.Deadline(`deadline-completed-${index + 1}`, deadline.title, deadline.description, completedAt, userId, DeadlineStatus_1.DeadlineStatus.COMPLETED, createdDate, new Date(), completedAt, deadline.subject));
        });
    }
    async getByUser(userId) {
        const userDeadlines = this.deadlines.filter((d) => d.userId === userId);
        return Result_1.Result.ok(userDeadlines);
    }
    async save(deadline) {
        this.deadlines.push(deadline);
        return Result_1.Result.ok();
    }
    async update(deadline) {
        const existingIndex = this.deadlines.findIndex((d) => d.id === deadline.id);
        if (existingIndex >= 0) {
            this.deadlines[existingIndex] = deadline;
        }
        return Result_1.Result.ok();
    }
}
exports.MockDeadlineRepository = MockDeadlineRepository;
