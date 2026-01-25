"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.TimeSlot = void 0;
const Result_1 = require("../../shared/Result");
class TimeSlot {
    constructor(_startTime, _endTime) {
        this._startTime = _startTime;
        this._endTime = _endTime;
    }
    get startTime() {
        return this._startTime;
    }
    get endTime() {
        return this._endTime;
    }
    static create(startTime, endTime) {
        if (!startTime || !endTime) {
            return Result_1.Result.fail("Invalid time slot");
        }
        return Result_1.Result.ok(new TimeSlot(startTime, endTime));
    }
    durationMinutes() {
        const [sh, sm] = this._startTime.split(":").map(Number);
        const [eh, em] = this._endTime.split(":").map(Number);
        return (eh * 60 + em) - (sh * 60 + sm);
    }
    overlaps(other) {
        const thisStart = this._startTime;
        const thisEnd = this._endTime;
        return thisStart < other.endTime && thisEnd > other.startTime;
    }
}
exports.TimeSlot = TimeSlot;
