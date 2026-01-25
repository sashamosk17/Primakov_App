"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.rbacMiddleware = void 0;
const AuthorizationError_1 = require("../../shared/errors/AuthorizationError");
const rbacMiddleware = (required) => {
    return (req, _res, next) => {
        const permissions = req.user?.permissions || [];
        const hasAll = required.every((perm) => permissions.includes(perm));
        if (!hasAll) {
            return next(new AuthorizationError_1.AuthorizationError("Permission denied"));
        }
        return next();
    };
};
exports.rbacMiddleware = rbacMiddleware;
