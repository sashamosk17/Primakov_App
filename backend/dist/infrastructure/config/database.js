"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.databaseConfig = void 0;
exports.createDatabasePool = createDatabasePool;
exports.getDatabasePool = getDatabasePool;
exports.closeDatabasePool = closeDatabasePool;
const pg_1 = require("pg");
exports.databaseConfig = {
    host: process.env.DB_HOST || "localhost",
    port: Number(process.env.DB_PORT || 5432),
    user: process.env.DB_USER || "primakov",
    password: process.env.DB_PASSWORD || "primakov",
    database: process.env.DB_NAME || "primakovapp"
};
let pool = null;
async function createDatabasePool() {
    if (pool) {
        return pool;
    }
    pool = new pg_1.Pool({
        host: process.env.DB_HOST || exports.databaseConfig.host,
        port: process.env.DB_PORT ? parseInt(process.env.DB_PORT) : exports.databaseConfig.port,
        database: process.env.DB_NAME || exports.databaseConfig.database,
        user: process.env.DB_USER || exports.databaseConfig.user,
        password: process.env.DB_PASSWORD || exports.databaseConfig.password,
        max: 10,
        idleTimeoutMillis: 60000,
        connectionTimeoutMillis: 60000,
        keepAlive: true,
        keepAliveInitialDelayMillis: 10000,
        statement_timeout: 120000, // 120 seconds for any single statement
        query_timeout: 120000,
    });
    pool.on("error", (err) => {
        console.error("Unexpected database error:", err);
    });
    try {
        await pool.query("SELECT NOW()");
        console.log("✓ Database connection established");
    }
    catch (error) {
        console.error("✗ Failed to connect to database:", error);
        throw error;
    }
    return pool;
}
function getDatabasePool() {
    if (!pool) {
        throw new Error("Database pool not initialized. Call createDatabasePool() first.");
    }
    return pool;
}
async function closeDatabasePool() {
    if (pool) {
        await pool.end();
        pool = null;
        console.log("✓ Database connection closed");
    }
}
