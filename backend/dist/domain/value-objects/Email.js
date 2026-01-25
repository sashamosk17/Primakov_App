"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Email = void 0;
const Result_1 = require("../../shared/Result");
const ValidationError_1 = require("../../shared/errors/ValidationError");
class Email {
    constructor(_value) {
        this._value = _value;
    }
    get value() {
        return this._value;
    }
    get domain() {
        return this._value.split("@")[1];
    }
    static create(value) {
        const normalized = value.trim().toLowerCase();
        const isValid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(normalized);
        if (!isValid) {
            return Result_1.Result.fail(new ValidationError_1.ValidationError("Invalid email").message);
        }
        return Result_1.Result.ok(new Email(normalized));
    }
    equals(other) {
        return this._value === other._value;
    }
}
exports.Email = Email;
