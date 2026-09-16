import fs from "node:fs";
import path from "node:path";
import postgres from "postgres";

const sql = postgres(process.env.DATABASE_URL!);
const seed = fs.readFileSync(path.join(process.cwd(), "database/seeds/seed.sql"), "utf8");

await sql.unsafe(seed);
await sql.end();
console.log("PROJECT FORGE seed completed.");
