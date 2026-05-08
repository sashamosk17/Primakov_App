import jwt from "jsonwebtoken";
import { AuthPayload } from "../types";

// JWT_SECRET is validated at startup in validateEnv.ts
const secret = process.env.JWT_SECRET!;

export const signToken = (payload: AuthPayload): string => {
  return jwt.sign(payload, secret, { expiresIn: "1h" });
};

export const verifyToken = (token: string): AuthPayload => {
  return jwt.verify(token, secret) as AuthPayload;
};
