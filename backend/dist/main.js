"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
// Load environment variables FIRST, before any other imports
const dotenv_1 = __importDefault(require("dotenv"));
const path_1 = __importDefault(require("path"));
// Load .env from the project root (dist/main.js runs from backend/ directory)
const envPath = path_1.default.join(__dirname, '..', '.env');
dotenv_1.default.config({ path: envPath });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const helmet_1 = __importDefault(require("helmet"));
const authRoutes_1 = require("./presentation/routes/authRoutes");
const scheduleRoutes_1 = require("./presentation/routes/scheduleRoutes");
const deadlineRoutes_1 = require("./presentation/routes/deadlineRoutes");
const ratingRoutes_1 = require("./presentation/routes/ratingRoutes");
const storyRoutes_1 = require("./presentation/routes/storyRoutes");
const announcementRoutes_1 = require("./presentation/routes/announcementRoutes");
const roomRoutes_1 = require("./presentation/routes/roomRoutes");
const requestRoutes_1 = require("./presentation/routes/requestRoutes");
const canteenRoutes_1 = require("./presentation/routes/canteenRoutes");
const userRoutes_1 = require("./presentation/routes/userRoutes");
const errorHandlerMiddleware_1 = require("./presentation/middleware/errorHandlerMiddleware");
const sanitizationMiddleware_1 = require("./presentation/middleware/sanitizationMiddleware");
const database_1 = require("./infrastructure/config/database");
const migrationRunner_1 = require("./infrastructure/database/migrations/migrationRunner");
const validateEnv_1 = require("./infrastructure/config/validateEnv");
const cors_2 = require("./infrastructure/config/cors");
const rateLimiter_1 = require("./infrastructure/config/rateLimiter");
const postgres_1 = require("./infrastructure/database/postgres");
async function startServer() {
    try {
        console.log("Validating environment configuration...");
        (0, validateEnv_1.validateEnvironment)();
        console.log("Initializing database connection...");
        const pool = await (0, database_1.createDatabasePool)();
        console.log("Running database migrations...");
        await (0, migrationRunner_1.runMigrations)(pool);
        console.log("Creating repository instances...");
        const userRepository = new postgres_1.PostgresUserRepository(pool);
        const scheduleRepository = new postgres_1.PostgresScheduleRepository(pool);
        const deadlineRepository = new postgres_1.PostgresDeadlineRepository(pool);
        const announcementRepository = new postgres_1.PostgresAnnouncementRepository(pool);
        const storyRepository = new postgres_1.PostgresStoryRepository(pool);
        const ratingRepository = new postgres_1.PostgresRatingRepository(pool);
        const roomRepository = new postgres_1.PostgresRoomRepository(pool);
        const requestRepository = new postgres_1.PostgresRequestRepository(pool);
        const canteenMenuRepository = new postgres_1.PostgresCanteenMenuRepository(pool);
        const app = (0, express_1.default)();
        // Security headers
        app.use((0, helmet_1.default)({
            contentSecurityPolicy: false, // Disable for API-only backend
            crossOriginEmbedderPolicy: false,
        }));
        // CORS configuration
        app.use((0, cors_1.default)(cors_2.corsConfig));
        // General rate limiting
        app.use(rateLimiter_1.generalRateLimiter);
        app.use(express_1.default.json());
        // Input sanitization
        app.use(sanitizationMiddleware_1.sanitizeInput);
        // Logging middleware
        app.use((req, res, next) => {
            console.log(`${req.method} ${req.path}`);
            next();
        });
        // Routes - using PostgreSQL repositories
        app.use("/api/auth", (0, authRoutes_1.authRoutes)(userRepository));
        app.use("/api/users", (0, userRoutes_1.userRoutes)(userRepository));
        app.use("/api/schedule", (0, scheduleRoutes_1.scheduleRoutes)(scheduleRepository));
        app.use("/api/deadlines", (0, deadlineRoutes_1.deadlineRoutes)(deadlineRepository));
        app.use("/api/ratings", (0, ratingRoutes_1.ratingRoutes)(ratingRepository));
        app.use("/api/stories", (0, storyRoutes_1.storyRoutes)(storyRepository));
        app.use("/api/announcements", (0, announcementRoutes_1.announcementRoutes)(announcementRepository));
        app.use("/api/rooms", (0, roomRoutes_1.roomRoutes)(roomRepository));
        app.use("/api/requests", (0, requestRoutes_1.requestRoutes)(requestRepository));
        app.use("/api/canteen", (0, canteenRoutes_1.canteenRoutes)(canteenMenuRepository));
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
