"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.DomainError = void 0;
const AppError_1 = require("./AppError");
class DomainError extends AppError_1.AppError {
    constructor(message, code = "DOMAIN_ERROR") {
        super(message, 400, code);
    }
}
exports.DomainError = DomainError;
