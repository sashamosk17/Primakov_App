"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthenticationError = void 0;
const AppError_1 = require("./AppError");
class AuthenticationError extends AppError_1.AppError {
    constructor(message, code = "AUTH_ERROR") {
        super(message, 401, code);
    }
}
exports.AuthenticationError = AuthenticationError;
