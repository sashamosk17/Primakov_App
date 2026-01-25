"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ValidationError = void 0;
const AppError_1 = require("./AppError");
class ValidationError extends AppError_1.AppError {
    constructor(message, code = "VALIDATION_ERROR") {
        super(message, 422, code);
    }
}
exports.ValidationError = ValidationError;
