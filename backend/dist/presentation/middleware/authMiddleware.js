"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.authMiddleware = void 0;
const jsonwebtoken_1 = require("jsonwebtoken");
const jwt_1 = require("../../shared/utils/jwt");
const AuthenticationError_1 = require("../../shared/errors/AuthenticationError");
const authMiddleware = (req, _res, next) => {
    try {
        const header = req.headers.authorization;
        if (!header) {
            throw new AuthenticationError_1.AuthenticationError("Missing token");
        }
        const token = header.split(" ")[1];
        if (!token) {
            throw new AuthenticationError_1.AuthenticationError("Invalid token");
        }
        req.user = (0, jwt_1.verifyToken)(token);
        return next();
    }
    catch (error) {
        if (error instanceof jsonwebtoken_1.TokenExpiredError) {
            return next(new AuthenticationError_1.AuthenticationError("Token expired"));
        }
        if (error instanceof jsonwebtoken_1.JsonWebTokenError) {
            return next(new AuthenticationError_1.AuthenticationError("Invalid token"));
        }
        return next(error);
    }
};
exports.authMiddleware = authMiddleware;
