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
import {
  scheduleRepository,
  deadlineRepository,
  announcementRepository,
  storyRepository,
  userRepository,
  ratingRepository,
} from "./infrastructure/database/memory/repositories";

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

// Используем глобальные экземпляры репозиториев, чтобы data persisted
app.use("/api/auth", authRoutes(userRepository));
app.use("/api/schedule", scheduleRoutes(scheduleRepository));
app.use("/api/deadlines", deadlineRoutes(deadlineRepository));
app.use("/api/ratings", ratingRoutes(ratingRepository));
app.use("/api/stories", storyRoutes(storyRepository));
app.use("/api/announcements", announcementRoutes(announcementRepository));

app.use(errorHandlerMiddleware);

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`PrimakovApp backend running on port ${port}`);
});
