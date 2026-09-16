import fs from "node:fs/promises";
import path from "node:path";
import postgres from "postgres";
const sql=postgres(process.env.DATABASE_URL!,{prepare:false});
const dir=path.join(process.cwd(),"database/migrations");
await sql`CREATE TABLE IF NOT EXISTS _project_forge_migrations (filename text PRIMARY KEY, applied_at timestamptz NOT NULL DEFAULT now())`;
for(const filename of (await fs.readdir(dir)).filter(f=>f.endsWith(".sql")).sort()){const applied=await sql`SELECT 1 FROM _project_forge_migrations WHERE filename=${filename}`;if(applied.length)continue;await sql.unsafe(await fs.readFile(path.join(dir,filename),"utf8"));await sql`INSERT INTO _project_forge_migrations(filename) VALUES(${filename})`;console.log(`applied ${filename}`)}
await sql.end();
