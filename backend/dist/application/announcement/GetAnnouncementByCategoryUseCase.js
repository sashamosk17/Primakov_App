"use strict";
/*
 * Use case for retrieving announcements by category
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.GetAnnouncementByCategoryUseCase = void 0;
class GetAnnouncementByCategoryUseCase {
    constructor(announcementRepository) {
        this.announcementRepository = announcementRepository;
    }
    async execute(category) {
        const result = await this.announcementRepository.getByCategory(category);
        return result;
    }
}
exports.GetAnnouncementByCategoryUseCase = GetAnnouncementByCategoryUseCase;
