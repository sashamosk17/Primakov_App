"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.scheduleRoutes = void 0;
const express_1 = require("express");
const ScheduleController_1 = require("../controllers/ScheduleController");
const GetScheduleUseCase_1 = require("../../application/schedule/GetScheduleUseCase");
const GetScheduleByDateUseCase_1 = require("../../application/schedule/GetScheduleByDateUseCase");
const ScheduleService_1 = require("../../domain/services/ScheduleService");
const MockScheduleRepository_1 = require("../../infrastructure/database/memory/MockScheduleRepository");
const authMiddleware_1 = require("../middleware/authMiddleware");
const scheduleRoutes = () => {
    const router = (0, express_1.Router)();
    const service = new ScheduleService_1.ScheduleService(new MockScheduleRepository_1.MockScheduleRepository());
    const controller = new ScheduleController_1.ScheduleController(new GetScheduleUseCase_1.GetScheduleUseCase(service), new GetScheduleByDateUseCase_1.GetScheduleByDateUseCase(service));
    router.get("/:groupId", authMiddleware_1.authMiddleware, controller.getSchedule);
    router.get("/:groupId/:date", authMiddleware_1.authMiddleware, controller.getScheduleByDate);
    return router;
};
exports.scheduleRoutes = scheduleRoutes;
