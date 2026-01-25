import { randomUUID } from "crypto";
import { Response, NextFunction } from "express";
import { AuthenticatedRequest } from "../types";
import { RateTeacherUseCase } from "../../application/rating/RateTeacherUseCase";
import { GetTeacherRatingsUseCase } from "../../application/rating/GetTeacherRatingsUseCase";
import { Rating } from "../../domain/entities/Rating";

export class RatingController {
  constructor(
    private readonly rateTeacherUseCase: RateTeacherUseCase,
    private readonly getTeacherRatingsUseCase: GetTeacherRatingsUseCase
  ) {}

  public rateTeacher = async (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user?.userId || "";
      const { teacherId, value } = req.body;
      const rating = new Rating(randomUUID(), teacherId, userId, value, new Date());
      const result = await this.rateTeacherUseCase.execute(rating);
      if (result.isFailure) {
        return res.status(400).json({ status: "error", error: { message: result.error } });
      }
      return res.status(201).json({ status: "success" });
    } catch (error) {
      return next(error);
    }
  };

  public getRatings = async (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
    try {
      const { teacherId } = req.params;
      const result = await this.getTeacherRatingsUseCase.execute(teacherId);
      return res.json({ status: "success", data: result.value });
    } catch (error) {
      return next(error);
    }
  };
}
