"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GetTeachersUseCase = void 0;
class GetTeachersUseCase {
    constructor(userRepository) {
        this.userRepository = userRepository;
    }
    async execute() {
        return this.userRepository.findByRole("TEACHER");
    }
}
exports.GetTeachersUseCase = GetTeachersUseCase;
