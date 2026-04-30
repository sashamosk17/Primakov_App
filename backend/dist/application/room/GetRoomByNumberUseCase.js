"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GetRoomByNumberUseCase = void 0;
class GetRoomByNumberUseCase {
    constructor(roomRepository) {
        this.roomRepository = roomRepository;
    }
    async execute(number) {
        return await this.roomRepository.getByNumber(number);
    }
}
exports.GetRoomByNumberUseCase = GetRoomByNumberUseCase;
