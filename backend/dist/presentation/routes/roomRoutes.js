"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.roomRoutes = roomRoutes;
const express_1 = require("express");
const RoomController_1 = require("../controllers/RoomController");
function roomRoutes(repository) {
    const router = (0, express_1.Router)();
    const controller = new RoomController_1.RoomController(repository);
    router.get("/", controller.getAll);
    router.get("/:number", controller.getByNumber);
    router.get("/building/:building", controller.getByBuilding);
    router.get("/building/:building/floor/:floor", controller.getByFloor);
    return router;
}
