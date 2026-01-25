"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.errorHandlerMiddleware = void 0;
const AppError_1 = require("../../shared/errors/AppError");
const errorHandlerMiddleware = (err, _req, res, _next) => {
    if (err instanceof AppError_1.AppError) {
        return res.status(err.statusCode).json({
            status: "error",
            error: {
                code: err.code,
                message: err.message
            }
        });
    }
    return res.status(500).json({
        status: "error",
        error: {
            code: "INTERNAL_ERROR",
            message: err.message
        }
    });
};
exports.errorHandlerMiddleware = errorHandlerMiddleware;
