"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.CacheManager = void 0;
class CacheManager {
    constructor(cache) {
        this.cache = cache;
    }
    async getOrSet(key, fetcher, ttlSeconds = 3600) {
        const cached = await this.cache.get(key);
        if (cached) {
            return JSON.parse(cached);
        }
        const fresh = await fetcher();
        await this.cache.set(key, JSON.stringify(fresh), ttlSeconds);
        return fresh;
    }
}
exports.CacheManager = CacheManager;
