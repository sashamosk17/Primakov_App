"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deadlineRoutes = void 0;
const express_1 = require("express");
const DeadlineController_1 = require("../controllers/DeadlineController");
const CreateDeadlineUseCase_1 = require("../../application/deadline/CreateDeadlineUseCase");
const GetUserDeadlinesUseCase_1 = require("../../application/deadline/GetUserDeadlinesUseCase");
const DeadlineService_1 = require("../../domain/services/DeadlineService");
const MockDeadlineRepository_1 = require("../../infrastructure/database/memory/MockDeadlineRepository");
const authMiddleware_1 = require("../middleware/authMiddleware");
const deadlineRoutes = () => {
    const router = (0, express_1.Router)();
    const service = new DeadlineService_1.DeadlineService(new MockDeadlineRepository_1.MockDeadlineRepository());
    const controller = new DeadlineController_1.DeadlineController(new CreateDeadlineUseCase_1.CreateDeadlineUseCase(service), new GetUserDeadlinesUseCase_1.GetUserDeadlinesUseCase(service));
    router.get("/", authMiddleware_1.authMiddleware, controller.getDeadlines);
    router.post("/", authMiddleware_1.authMiddleware, controller.createDeadline);
    return router;
};
exports.deadlineRoutes = deadlineRoutes;
