"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Room = void 0;
const Result_1 = require("../../shared/Result");
class Room {
    constructor(_number, _building, _floor) {
        this._number = _number;
        this._building = _building;
        this._floor = _floor;
    }
    get number() {
        return this._number;
    }
    get building() {
        return this._building;
    }
    get floor() {
        return this._floor;
    }
    static create(number, building, floor) {
        if (!number || !building || Number.isNaN(floor)) {
            return Result_1.Result.fail("Invalid room");
        }
        return Result_1.Result.ok(new Room(number, building, floor));
    }
    fullName() {
        return `${this._number}-${this._building}, floor ${this._floor}`;
    }
}
exports.Room = Room;
