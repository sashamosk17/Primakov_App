"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.validationMiddleware = exports.validate = void 0;
const zod_1 = require("zod");
const validate = (schema) => {
    return (req, res, next) => {
        try {
            schema.parse(req.body);
            next();
        }
        catch (error) {
            if (error instanceof zod_1.ZodError) {
                return res.status(400).json({
                    status: "error",
                    error: {
                        code: "VALIDATION_ERROR",
                        message: "Invalid input data",
                        details: error.issues.map((e) => ({
                            field: e.path.join('.'),
                            message: e.message,
                        })),
                    },
                });
            }
            next(error);
        }
    };
};
exports.validate = validate;
// Legacy middleware for backward compatibility
const validationMiddleware = (_req, _res, next) => {
    return next();
};
exports.validationMiddleware = validationMiddleware;
