"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GetAnnouncementsUseCase = void 0;
class GetAnnouncementsUseCase {
    constructor(announcementRepository) {
        this.announcementRepository = announcementRepository;
    }
    async execute() {
        const result = await this.announcementRepository.getAll();
        return result;
    }
}
exports.GetAnnouncementsUseCase = GetAnnouncementsUseCase;
