"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.scheduleRoutes = void 0;
const express_1 = require("express");
const ScheduleController_1 = require("../controllers/ScheduleController");
const GetScheduleUseCase_1 = require("../../application/schedule/GetScheduleUseCase");
const GetScheduleByDateUseCase_1 = require("../../application/schedule/GetScheduleByDateUseCase");
const GetScheduleByUserIdUseCase_1 = require("../../application/schedule/GetScheduleByUserIdUseCase");
const ScheduleService_1 = require("../../domain/services/ScheduleService");
const scheduleRoutes = (repository) => {
    const router = (0, express_1.Router)();
    const service = new ScheduleService_1.ScheduleService(repository);
    const controller = new ScheduleController_1.ScheduleController(new GetScheduleUseCase_1.GetScheduleUseCase(service), new GetScheduleByDateUseCase_1.GetScheduleByDateUseCase(service), new GetScheduleByUserIdUseCase_1.GetScheduleByUserIdUseCase(service));
    router.get("/user/:userId/:date", controller.getScheduleByUserId);
    router.get("/:groupId", controller.getSchedule);
    router.get("/:groupId/:date", controller.getScheduleByDate);
    return router;
};
exports.scheduleRoutes = scheduleRoutes;
