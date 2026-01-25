import axiosInstance from "./axiosInstance";
import { endpoints } from "./endpoints";

export const RatingService = {
  getRatings: (teacherId: string) => axiosInstance.get(`${endpoints.ratings}/${teacherId}`),
  rate: (payload: unknown) => axiosInstance.post(endpoints.ratings, payload)
};

