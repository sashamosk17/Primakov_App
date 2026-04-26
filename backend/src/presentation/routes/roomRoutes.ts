import { Router } from "express";
import { PostgresRoomRepository } from "../../infrastructure/database/postgres/PostgresRoomRepository";
import { RoomController } from "../controllers/RoomController";

export function roomRoutes(repository: PostgresRoomRepository): Router {
  const router = Router();
  const controller = new RoomController(repository);

  router.get("/", controller.getAll);
  router.get("/:number", controller.getByNumber);
  router.get("/building/:building", controller.getByBuilding);
  router.get("/building/:building/floor/:floor", controller.getByFloor);

  return router;
}
