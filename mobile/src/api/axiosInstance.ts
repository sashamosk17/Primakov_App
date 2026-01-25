import axios from "axios";

const API_BASE_URL = process.env.EXPO_PUBLIC_API_BASE_URL || "http://localhost:3000/api";

console.log("API_BASE_URL:", API_BASE_URL);

export const axiosInstance = axios.create({
  baseURL: API_BASE_URL,
  timeout: 10000,
});

// Request interceptor: Add JWT token to headers
// Note: Token management in React Native uses Redux instead of localStorage
axiosInstance.interceptors.request.use(
  (config) => {
    // Token will be passed from components or Redux state in the future
    // For now, requests are made without persistent token storage
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response interceptor: Handle 401 and logout
axiosInstance.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Would dispatch logout action here in a real implementation
      // Requires accessing Redux store, which we'll implement in phase 2
    }
    return Promise.reject(error);
  }
);

export default axiosInstance;
