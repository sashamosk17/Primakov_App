"use strict";
/*
 * Routes for announcement management endpoints
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.announcementRoutes = void 0;
const express_1 = require("express");
const AnnouncementController_1 = require("../controllers/AnnouncementController");
const GetAnnouncementsUseCase_1 = require("../../application/announcement/GetAnnouncementsUseCase");
const GetAnnouncementByCategoryUseCase_1 = require("../../application/announcement/GetAnnouncementByCategoryUseCase");
const MockAnnouncementRepository_1 = require("../../infrastructure/database/mock/MockAnnouncementRepository");
const announcementRoutes = () => {
    const router = (0, express_1.Router)();
    const announcementRepository = new MockAnnouncementRepository_1.MockAnnouncementRepository();
    const getAnnouncementsUseCase = new GetAnnouncementsUseCase_1.GetAnnouncementsUseCase(announcementRepository);
    const getAnnouncementByCategoryUseCase = new GetAnnouncementByCategoryUseCase_1.GetAnnouncementByCategoryUseCase(announcementRepository);
    const controller = new AnnouncementController_1.AnnouncementController(getAnnouncementsUseCase, getAnnouncementByCategoryUseCase);
    router.get("/", controller.getAnnouncements);
    router.get("/category/:category", controller.getByCategory);
    return router;
};
exports.announcementRoutes = announcementRoutes;
