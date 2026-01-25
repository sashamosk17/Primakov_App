/**
 * Announcement Service
 * Handles announcement-related API calls
 */

import axiosInstance from "./axiosInstance";
import { Announcement, ApiResponse } from "../types/api";

export const AnnouncementService = {
  async getAnnouncements(): Promise<Announcement[]> {
    const response = await axiosInstance.get<ApiResponse<Announcement[]>>("/announcements");
    if (response.data.status === "error") {
      throw new Error(response.data.error?.message || "Failed to fetch announcements");
    }
    return response.data.data || [];
  },

  async getByCategory(category: string): Promise<Announcement[]> {
    const response = await axiosInstance.get<ApiResponse<Announcement[]>>(
      `/announcements/category/${category}`
    );
    if (response.data.status === "error") {
      throw new Error(response.data.error?.message || "Failed to fetch announcements");
    }
    return response.data.data || [];
  },
};
