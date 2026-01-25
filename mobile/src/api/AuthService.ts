/**
 * Auth Service
 * Handles authentication API calls
 */

import axiosInstance from "./axiosInstance";
import { User, AuthResponse, ApiResponse } from "../types/api";

export const AuthService = {
  async login(email: string, password: string): Promise<AuthResponse> {
    const response = await axiosInstance.post<ApiResponse<AuthResponse>>("/auth/login", {
      email,
      password,
    });
    if (response.data.status === "error") {
      throw new Error(response.data.error?.message || "Login failed");
    }
    return response.data.data!;
  },

  async register(email: string, password: string): Promise<AuthResponse> {
    const response = await axiosInstance.post<ApiResponse<AuthResponse>>("/auth/register", {
      email,
      password,
    });
    if (response.data.status === "error") {
      throw new Error(response.data.error?.message || "Registration failed");
    }
    return response.data.data!;
  },

  async logout(): Promise<void> {
    // Logout is handled by Redux in React Native
    // localStorage is not available, use AsyncStorage in production
  },
};
