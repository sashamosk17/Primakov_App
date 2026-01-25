/**
 * Schedule Service
 * Handles schedule-related API calls
 */

import axiosInstance from "./axiosInstance";
import { Schedule, Lesson, ApiResponse } from "../types/api";

export const ScheduleService = {
  async getScheduleByDate(groupId: string, date: string): Promise<Schedule> {
    const response = await axiosInstance.get<ApiResponse<Schedule>>(
      `/schedule?groupId=${groupId}&date=${date}`
    );
    if (response.data.status === "error") {
      throw new Error(response.data.error?.message || "Failed to fetch schedule");
    }
    return response.data.data!;
  },

  async getLessonDetails(lessonId: string): Promise<Lesson> {
    const response = await axiosInstance.get<ApiResponse<Lesson>>(`/schedule/${lessonId}`);
    if (response.data.status === "error") {
      throw new Error(response.data.error?.message || "Failed to fetch lesson");
    }
    return response.data.data!;
  },
};
