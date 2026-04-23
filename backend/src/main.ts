import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import { authRoutes } from "./presentation/routes/authRoutes";
import { scheduleRoutes } from "./presentation/routes/scheduleRoutes";
import { deadlineRoutes } from "./presentation/routes/deadlineRoutes";
import { ratingRoutes } from "./presentation/routes/ratingRoutes";
import { storyRoutes } from "./presentation/routes/storyRoutes";
import { announcementRoutes } from "./presentation/routes/announcementRoutes";
import { errorHandlerMiddleware } from "./presentation/middleware/errorHandlerMiddleware";
import { createDatabasePool, closeDatabasePool } from "./infrastructure/config/database";
import { runMigrations } from "./infrastructure/database/migrations/migrationRunner";
import { UserRepository } from "./infrastructure/database/postgres/UserRepository";
import { ScheduleRepository } from "./infrastructure/database/postgres/ScheduleRepository";
import { DeadlineRepository } from "./infrastructure/database/postgres/DeadlineRepository";
import { AnnouncementRepository } from "./infrastructure/database/postgres/AnnouncementRepository";
import { StoryRepository } from "./infrastructure/database/postgres/StoryRepository";
import { RatingRepository } from "./infrastructure/database/postgres/RatingRepository";

dotenv.config();

async function startServer() {
  try {
    console.log("Initializing database connection...");
    const pool = await createDatabasePool();

    console.log("Running database migrations...");
    await runMigrations(pool);

    console.log("Creating repository instances...");
    const userRepository = new UserRepository(pool);
    const scheduleRepository = new ScheduleRepository(pool);
    const deadlineRepository = new DeadlineRepository(pool);
    const announcementRepository = new AnnouncementRepository(pool);
    const storyRepository = new StoryRepository(pool);
    const ratingRepository = new RatingRepository(pool);

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
