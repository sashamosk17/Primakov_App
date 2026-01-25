"use strict";
/*
 * In-memory announcement repository with school events and news
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.MockAnnouncementRepository = void 0;
const Result_1 = require("../../../shared/Result");
class MockAnnouncementRepository {
    constructor() {
        this.announcements = [];
        this.initializeTestData();
    }
    initializeTestData() {
        const today = new Date();
        this.announcements = [
            {
                id: "announcement-1",
                title: "Начало второй четверти",
                description: "Школа начинает работу в штатном режиме",
                content: "Все уроки начинаются в обычное время. Родители просят убедиться в наличии учебников.",
                date: new Date(today.getTime() + 7 * 24 * 60 * 60 * 1000),
                category: "IMPORTANT",
                createdAt: today,
                authorId: "admin-1",
            },
            {
                id: "announcement-2",
                title: "Профилактические работы в столовой",
                description: "Столовая закрыта на техническое обслуживание",
                content: "Столовая будет закрыта с 22 по 25 января. Обед переносится в учебный класс.",
                date: new Date(today.getTime() + 1 * 24 * 60 * 60 * 1000),
                category: "MAINTENANCE",
                createdAt: today,
                authorId: "admin-1",
            },
            {
                id: "announcement-3",
                title: "Олимпиада по Математике",
                description: "Школьный этап олимпиады по математике",
                content: "Регистрация открыта до 25 января. Участие добровольное. Призы и дипломы для победителей.",
                date: new Date(today.getTime() + 10 * 24 * 60 * 60 * 1000),
                category: "EVENT",
                createdAt: today,
                authorId: "teacher-1",
            },
            {
                id: "announcement-4",
                title: "Каникулы переносятся",
                description: "Расписание каникул изменилось",
                content: "Весенние каникулы сдвинуты на неделю. Новые даты будут объявлены завтра. Просим отнестись к этому с пониманием.",
                date: new Date(today.getTime() + 3 * 24 * 60 * 60 * 1000),
                category: "IMPORTANT",
                createdAt: today,
                authorId: "admin-1",
            },
            {
                id: "announcement-5",
                title: "День науки в школе",
                description: "Ежегодное событие с представлением проектов",
                content: "Учащиеся смогут продемонстрировать свои научные исследования. Желающих участвовать просим зарегистрироваться у классного руководителя.",
                date: new Date(today.getTime() + 14 * 24 * 60 * 60 * 1000),
                category: "EVENT",
                createdAt: today,
                authorId: "admin-1",
            },
        ];
    }
    async getAll() {
        return Result_1.Result.ok(this.announcements);
    }
    async getById(id) {
        const announcement = this.announcements.find((a) => a.id === id);
        return Result_1.Result.ok(announcement || null);
    }
    async getByCategory(category) {
        const categoryAnnouncements = this.announcements.filter((a) => a.category === category);
        return Result_1.Result.ok(categoryAnnouncements);
    }
    async save(announcement) {
        this.announcements.push(announcement);
        return Result_1.Result.ok();
    }
}
exports.MockAnnouncementRepository = MockAnnouncementRepository;
