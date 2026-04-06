"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deadlineRoutes = void 0;
const express_1 = require("express");
const DeadlineController_1 = require("../controllers/DeadlineController");
const CreateDeadlineUseCase_1 = require("../../application/deadline/CreateDeadlineUseCase");
const GetUserDeadlinesUseCase_1 = require("../../application/deadline/GetUserDeadlinesUseCase");
const CompleteDeadlineUseCase_1 = require("../../application/deadline/CompleteDeadlineUseCase");
const DeadlineService_1 = require("../../domain/services/DeadlineService");
const deadlineRoutes = (repository) => {
    const router = (0, express_1.Router)();
    const service = new DeadlineService_1.DeadlineService(repository);
    const controller = new DeadlineController_1.DeadlineController(new CreateDeadlineUseCase_1.CreateDeadlineUseCase(service), new GetUserDeadlinesUseCase_1.GetUserDeadlinesUseCase(service), new CompleteDeadlineUseCase_1.CompleteDeadlineUseCase(service), repository);
    router.get("/", controller.getDeadlines);
    router.post("/", controller.createDeadline);
    router.patch("/:deadlineId/complete", controller.completeDeadline);
    return router;
};
exports.deadlineRoutes = deadlineRoutes;
