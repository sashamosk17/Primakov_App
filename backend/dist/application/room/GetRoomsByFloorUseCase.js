"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GetRoomsByFloorUseCase = void 0;
class GetRoomsByFloorUseCase {
    constructor(roomRepository) {
        this.roomRepository = roomRepository;
    }
    async execute(building, floor) {
        return await this.roomRepository.getByFloor(building, floor);
    }
}
exports.GetRoomsByFloorUseCase = GetRoomsByFloorUseCase;
