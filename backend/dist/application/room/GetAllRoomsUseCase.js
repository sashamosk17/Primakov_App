"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GetAllRoomsUseCase = void 0;
class GetAllRoomsUseCase {
    constructor(roomRepository) {
        this.roomRepository = roomRepository;
    }
    async execute() {
        return await this.roomRepository.getAll();
    }
}
exports.GetAllRoomsUseCase = GetAllRoomsUseCase;
