"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.databaseConfig = void 0;
const resolveValue = (...values) => {
    return values.find((value) => typeof value === 'string' && value.length > 0);
};
const useSsl = String(process.env.DB_SSL ?? process.env.DATABASE_SSL ?? 'false').toLowerCase() === 'true';
const databaseConfig = () => {
    const databaseUrl = process.env.DATABASE_URL;
    if (databaseUrl) {
        return {
            type: 'postgres',
            url: databaseUrl,
            autoLoadEntities: true,
            synchronize: true,
            ssl: useSsl ? { rejectUnauthorized: false } : false,
        };
    }
    const host = process.env.DB_HOST ?? 'localhost';
    const port = Number(process.env.DB_PORT ?? 5432);
    const username = resolveValue(process.env.DB_USERNAME, process.env.DB_USER) ?? 'postgres';
    const password = resolveValue(process.env.DB_PASSWORD, process.env.DB_PASS) ?? '';
    const database = process.env.DB_NAME ?? 'spliteasy';
    return {
        type: 'postgres',
        host,
        port,
        username,
        password,
        database,
        autoLoadEntities: true,
        synchronize: true,
        ssl: useSsl ? { rejectUnauthorized: false } : false,
    };
};
exports.databaseConfig = databaseConfig;
//# sourceMappingURL=database.config.js.map