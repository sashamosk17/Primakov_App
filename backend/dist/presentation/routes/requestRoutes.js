"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.requestRoutes = requestRoutes;
const express_1 = require("express");
const RequestController_1 = require("../controllers/RequestController");
const authMiddleware_1 = require("../middleware/authMiddleware");
function requestRoutes(repository) {
    const router = (0, express_1.Router)();
    const controller = new RequestController_1.RequestController(repository);
    router.use(authMiddleware_1.authMiddleware);
    router.post("/", controller.create);
    router.get("/", controller.getUserRequests);
    router.get("/assigned", controller.getAssignedRequests);
    router.patch("/:id/status", controller.updateStatus);
    router.get("/active", controller.getActive);
    router.get("/type/:type", controller.getByType);
    return router;
}
