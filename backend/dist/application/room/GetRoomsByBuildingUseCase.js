"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GetRoomsByBuildingUseCase = void 0;
class GetRoomsByBuildingUseCase {
    constructor(roomRepository) {
        this.roomRepository = roomRepository;
    }
    async execute(building) {
        return await this.roomRepository.getByBuilding(building);
    }
}
exports.GetRoomsByBuildingUseCase = GetRoomsByBuildingUseCase;
