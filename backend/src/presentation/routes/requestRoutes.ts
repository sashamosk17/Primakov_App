import { Router } from "express";
import { PostgresRequestRepository } from "../../infrastructure/database/postgres/PostgresRequestRepository";
import { RequestController } from "../controllers/RequestController";
import { authMiddleware } from "../middleware/authMiddleware";

export function requestRoutes(repository: PostgresRequestRepository): Router {
  const router = Router();
  const controller = new RequestController(repository);

  router.use(authMiddleware);

  router.post("/", controller.create);
  router.get("/", controller.getUserRequests);
  router.get("/assigned", controller.getAssignedRequests);
  router.patch("/:id/status", controller.updateStatus);
  router.get("/active", controller.getActive);
  router.get("/type/:type", controller.getByType);

  return router;
}
