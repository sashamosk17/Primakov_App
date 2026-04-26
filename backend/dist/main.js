"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const dotenv_1 = __importDefault(require("dotenv"));
const authRoutes_1 = require("./presentation/routes/authRoutes");
const scheduleRoutes_1 = require("./presentation/routes/scheduleRoutes");
const deadlineRoutes_1 = require("./presentation/routes/deadlineRoutes");
const ratingRoutes_1 = require("./presentation/routes/ratingRoutes");
const storyRoutes_1 = require("./presentation/routes/storyRoutes");
const announcementRoutes_1 = require("./presentation/routes/announcementRoutes");
const errorHandlerMiddleware_1 = require("./presentation/middleware/errorHandlerMiddleware");
const database_1 = require("./infrastructure/config/database");
const migrationRunner_1 = require("./infrastructure/database/migrations/migrationRunner");
const UserRepository_1 = require("./infrastructure/database/postgres/UserRepository");
const ScheduleRepository_1 = require("./infrastructure/database/postgres/ScheduleRepository");
const DeadlineRepository_1 = require("./infrastructure/database/postgres/DeadlineRepository");
const AnnouncementRepository_1 = require("./infrastructure/database/postgres/AnnouncementRepository");
const StoryRepository_1 = require("./infrastructure/database/postgres/StoryRepository");
const RatingRepository_1 = require("./infrastructure/database/postgres/RatingRepository");
dotenv_1.default.config();
async function startServer() {
    try {
        console.log("Initializing database connection...");
        const pool = await (0, database_1.createDatabasePool)();
        console.log("Running database migrations...");
        await (0, migrationRunner_1.runMigrations)(pool);
        console.log("Creating repository instances...");
        const userRepository = new UserRepository_1.UserRepository(pool);
        const scheduleRepository = new ScheduleRepository_1.ScheduleRepository(pool);
        const deadlineRepository = new DeadlineRepository_1.DeadlineRepository(pool);
        const announcementRepository = new AnnouncementRepository_1.AnnouncementRepository(pool);
        const storyRepository = new StoryRepository_1.StoryRepository(pool);
        const ratingRepository = new RatingRepository_1.RatingRepository(pool);
        const app = (0, express_1.default)();
        // CORS configuration for web development
        app.use((0, cors_1.default)({
            origin: '*',
            methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
            allowedHeaders: ['Content-Type', 'Authorization'],
            credentials: true,
        }));
        app.use(express_1.default.json());
        // Logging middleware
        app.use((req, res, next) => {
            console.log(`${req.method} ${req.path}`);
            next();
        });
        // Routes - using PostgreSQL repositories
        app.use("/api/auth", (0, authRoutes_1.authRoutes)(userRepository));
        app.use("/api/schedule", (0, scheduleRoutes_1.scheduleRoutes)(scheduleRepository));
        app.use("/api/deadlines", (0, deadlineRoutes_1.deadlineRoutes)(deadlineRepository));
        app.use("/api/ratings", (0, ratingRoutes_1.ratingRoutes)(ratingRepository));
        app.use("/api/stories", (0, storyRoutes_1.storyRoutes)(storyRepository));
        app.use("/api/announcements", (0, announcementRoutes_1.announcementRoutes)(announcementRepository));
        app.use(errorHandlerMiddleware_1.errorHandlerMiddleware);
        const port = process.env.PORT || 3000;
        const server = app.listen(port, () => {
            console.log(`Server running on port ${port}`);
            console.log(`Using PostgreSQL database at ${process.env.DB_HOST}`);
        });
        // Graceful shutdown
        const shutdown = async () => {
            console.log("\nShutting down gracefully...");
            server.close(async () => {
                await (0, database_1.closeDatabasePool)();
                process.exit(0);
            });
        };
        process.on("SIGTERM", shutdown);
        process.on("SIGINT", shutdown);
    }
    catch (error) {
        console.error("Failed to start server:", error);
        process.exit(1);
    }
}
startServer();
