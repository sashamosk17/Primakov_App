import { Router } from "express";
import { PostgresCanteenMenuRepository } from "../../infrastructure/database/postgres/PostgresCanteenMenuRepository";
import { CanteenController } from "../controllers/CanteenController";

export function canteenRoutes(repository: PostgresCanteenMenuRepository): Router {
  const router = Router();
  const controller = new CanteenController(repository);

  router.get("/menu/today", controller.getTodaysMenu);
  router.get("/menu/:date", controller.getMenuByDate);
  router.get("/menu/:date/:mealType", controller.getMenuByDateAndMealType);

  return router;
}
