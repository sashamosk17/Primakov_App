"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.canteenRoutes = canteenRoutes;
const express_1 = require("express");
const CanteenController_1 = require("../controllers/CanteenController");
function canteenRoutes(repository) {
    const router = (0, express_1.Router)();
    const controller = new CanteenController_1.CanteenController(repository);
    router.get("/menu/today", controller.getTodaysMenu);
    router.get("/menu/:date", controller.getMenuByDate);
    router.get("/menu/:date/:mealType", controller.getMenuByDateAndMealType);
    return router;
}
