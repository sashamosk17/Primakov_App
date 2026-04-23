"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Password = void 0;
const bcrypt_1 = require("bcrypt");
class Password {
    constructor(_hash) {
        this._hash = _hash;
    }
    get hash() {
        return this._hash;
    }
    compare(plainText) {
        return (0, bcrypt_1.compareSync)(plainText, this._hash);
    }
    static create(plainText) {
        const hashed = (0, bcrypt_1.hashSync)(plainText, 10);
        return new Password(hashed);
    }
    static fromHash(hash) {
        return new Password(hash);
    }
}
exports.Password = Password;
