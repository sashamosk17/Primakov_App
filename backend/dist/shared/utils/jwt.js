"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.verifyToken = exports.signToken = void 0;
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
// JWT_SECRET is validated at startup in validateEnv.ts
const secret = process.env.JWT_SECRET;
const signToken = (payload) => {
    return jsonwebtoken_1.default.sign(payload, secret, { expiresIn: "1h" });
};
exports.signToken = signToken;
const verifyToken = (token) => {
    return jsonwebtoken_1.default.verify(token, secret);
};
exports.verifyToken = verifyToken;
