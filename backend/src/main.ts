import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import { authRoutes } from "./presentation/routes/authRoutes";
import { scheduleRoutes } from "./presentation/routes/scheduleRoutes";
import { deadlineRoutes } from "./presentation/routes/deadlineRoutes";
import { ratingRoutes } from "./presentation/routes/ratingRoutes";
import { storyRoutes } from "./presentation/routes/storyRoutes";
import { announcementRoutes } from "./presentation/routes/announcementRoutes";
import { roomRoutes } from "./presentation/routes/roomRoutes";
import { requestRoutes } from "./presentation/routes/requestRoutes";
import { canteenRoutes } from "./presentation/routes/canteenRoutes";
import { errorHandlerMiddleware } from "./presentation/middleware/errorHandlerMiddleware";
import { createDatabasePool, closeDatabasePool } from "./infrastructure/config/database";
import { runMigrations } from "./infrastructure/database/migrations/migrationRunner";
import {
  PostgresUserRepository,
  PostgresScheduleRepository,
  PostgresDeadlineRepository,
  PostgresRatingRepository,
  PostgresStoryRepository,
  PostgresAnnouncementRepository,
  PostgresRoomRepository,
  PostgresRequestRepository,
  PostgresCanteenMenuRepository,
} from "./infrastructure/database/postgres";

dotenv.config();

async function startServer() {
  try {
    console.log("Initializing database connection...");
    const pool = await createDatabasePool();

    console.log("Running database migrations...");
    await runMigrations(pool);

    console.log("Creating repository instances...");
    const userRepository = new PostgresUserRepository(pool);
    const scheduleRepository = new PostgresScheduleRepository(pool);
    const deadlineRepository = new PostgresDeadlineRepository(pool);
    const announcementRepository = new PostgresAnnouncementRepository(pool);
    const storyRepository = new PostgresStoryRepository(pool);
    const ratingRepository = new PostgresRatingRepository(pool);
    const roomRepository = new PostgresRoomRepository(pool);
    const requestRepository = new PostgresRequestRepository(pool);
    const canteenMenuRepository = new PostgresCanteenMenuRepository(pool);

    const app = express();

    // CORS configuration for web development
    app.use(cors({
      origin: '*',
      methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
      allowedHeaders: ['Content-Type', 'Authorization'],
      credentials: true,
    }));

    app.use(express.json());

    // Logging middleware
    app.use((req, res, next) => {
      console.log(`${req.method} ${req.path}`);
      next();
    });

    // Routes - using PostgreSQL repositories
    app.use("/api/auth", authRoutes(userRepository));
    app.use("/api/schedule", scheduleRoutes(scheduleRepository));
    app.use("/api/deadlines", deadlineRoutes(deadlineRepository));
    app.use("/api/ratings", ratingRoutes(ratingRepository));
    app.use("/api/stories", storyRoutes(storyRepository));
    app.use("/api/announcements", announcementRoutes(announcementRepository));
    app.use("/api/rooms", roomRoutes(roomRepository));
    app.use("/api/requests", requestRoutes(requestRepository));
    app.use("/api/canteen", canteenRoutes(canteenMenuRepository));

    app.use(errorHandlerMiddleware);

    const port = process.env.PORT || 3000;
    const server = app.listen(port, () => {
      console.log(`Server running on port ${port}`);
      console.log(`Using PostgreSQL database at ${process.env.DB_HOST}`);
    });

    // Graceful shutdown
    const shutdown = async () => {
      console.log("\nShutting down gracefully...");
      server.close(async () => {
        await closeDatabasePool();
        process.exit(0);
      });
    };

    process.on("SIGTERM", shutdown);
    process.on("SIGINT", shutdown);

  } catch (error) {
    console.error("Failed to start server:", error);
    process.exit(1);
  }
}

startServer();
