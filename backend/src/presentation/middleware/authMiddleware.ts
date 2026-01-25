import { Response, NextFunction } from "express";
import { verifyToken } from "../../shared/utils/jwt";
import { AuthenticationError } from "../../shared/errors/AuthenticationError";
import { AuthenticatedRequest } from "../types";

export const authMiddleware = (req: AuthenticatedRequest, _res: Response, next: NextFunction) => {
  try {
    const header = req.headers.authorization;
    if (!header) {
      throw new AuthenticationError("Missing token");
    }
    const token = header.split(" ")[1];
    if (!token) {
      throw new AuthenticationError("Invalid token");
    }
    req.user = verifyToken(token);
    return next();
  } catch (error) {
    return next(error);
  }
};
