/**
 * Deadline Service
 * Handles deadline-related API calls
 */

import axiosInstance from "./axiosInstance";
import { Deadline, ApiResponse } from "../types/api";

export const DeadlineService = {
  async getDeadlines(userId: string, status?: string): Promise<Deadline[]> {
    const params = new URLSearchParams({ userId });
    if (status) params.append("status", status);
    const response = await axiosInstance.get<ApiResponse<Deadline[]>>(
      `/deadlines?${params.toString()}`
    );
    if (response.data.status === "error") {
      throw new Error(response.data.error?.message || "Failed to fetch deadlines");
    }
    return response.data.data || [];
  },

  async createDeadline(deadline: Omit<Deadline, "id" | "createdAt">): Promise<Deadline> {
    const response = await axiosInstance.post<ApiResponse<Deadline>>("/deadlines", deadline);
    if (response.data.status === "error") {
      throw new Error(response.data.error?.message || "Failed to create deadline");
    }
    return response.data.data!;
  },

  async completeDeadline(deadlineId: string): Promise<Deadline> {
    const response = await axiosInstance.patch<ApiResponse<Deadline>>(
      `/deadlines/${deadlineId}/complete`
    );
    if (response.data.status === "error") {
      throw new Error(response.data.error?.message || "Failed to complete deadline");
    }
    return response.data.data!;
  },
};
