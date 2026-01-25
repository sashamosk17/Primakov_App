"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Password = void 0;
const crypto_1 = require("crypto");
class Password {
    constructor(_encrypted) {
        this._encrypted = _encrypted;
    }
    get encrypted() {
        return this._encrypted;
    }
    compare(plainText) {
        return Password.hash(plainText) === this._encrypted;
    }
    static create(plainText) {
        return new Password(Password.hash(plainText));
    }
    static hash(plainText) {
        return (0, crypto_1.createHash)("sha256").update(plainText).digest("hex");
    }
}
exports.Password = Password;
