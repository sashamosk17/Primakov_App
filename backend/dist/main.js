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
const repositories_1 = require("./infrastructure/database/memory/repositories");
dotenv_1.default.config();
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
// Используем глобальные экземпляры репозиториев, чтобы data persisted
app.use("/api/auth", (0, authRoutes_1.authRoutes)(repositories_1.userRepository));
app.use("/api/schedule", (0, scheduleRoutes_1.scheduleRoutes)(repositories_1.scheduleRepository));
app.use("/api/deadlines", (0, deadlineRoutes_1.deadlineRoutes)(repositories_1.deadlineRepository));
app.use("/api/ratings", (0, ratingRoutes_1.ratingRoutes)(repositories_1.ratingRepository));
app.use("/api/stories", (0, storyRoutes_1.storyRoutes)(repositories_1.storyRepository));
app.use("/api/announcements", (0, announcementRoutes_1.announcementRoutes)(repositories_1.announcementRepository));
app.use(errorHandlerMiddleware_1.errorHandlerMiddleware);
const port = process.env.PORT || 3000;
app.listen(port, () => {
    console.log(`PrimakovApp backend running on port ${port}`);
});
