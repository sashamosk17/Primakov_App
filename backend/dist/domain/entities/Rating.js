"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Rating = void 0;
const Result_1 = require("../../shared/Result");
class Rating {
    constructor(id, teacherId, userId, value, createdAt, comment = '', updatedAt, version = 0, ipHash) {
        this.id = id;
        this.teacherId = teacherId;
        this.userId = userId;
        this.value = value;
        this.createdAt = createdAt;
        this.comment = comment;
        this.version = version;
        this.ipHash = ipHash;
        this.updatedAt = updatedAt ?? createdAt;
    }
    canBeUpdated() {
        return this.value >= 1 && this.value <= 10;
    }
    update(newValue) {
        if (newValue < 1 || newValue > 10) {
            return Result_1.Result.fail("Invalid rating value");
        }
        this.value = newValue;
        this.version += 1;
        this.updatedAt = new Date();
        return Result_1.Result.ok();
    }
    isOlderThan(days) {
        const diff = new Date().getTime() - this.updatedAt.getTime();
        return diff > days * 24 * 60 * 60 * 1000;
    }
}
exports.Rating = Rating;
