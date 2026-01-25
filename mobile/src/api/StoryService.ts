/**
 * Story Service
 * Handles story-related API calls
 */

import axiosInstance from "./axiosInstance";
import { Story, ApiResponse } from "../types/api";

export const StoryService = {
  async getStories(): Promise<Story[]> {
    const response = await axiosInstance.get<ApiResponse<Story[]>>("/stories");
    if (response.data.status === "error") {
      throw new Error(response.data.error?.message || "Failed to fetch stories");
    }
    return response.data.data || [];
  },

  async markAsViewed(storyId: string): Promise<void> {
    const response = await axiosInstance.post<ApiResponse<{}>>(`/stories/${storyId}/view`);
    if (response.data.status === "error") {
      throw new Error(response.data.error?.message || "Failed to mark story as viewed");
    }
  },
};
