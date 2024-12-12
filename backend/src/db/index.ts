import { drizzle } from "drizzle-orm/node-postgres";
import { Pool } from "pg";

const pool = new Pool({
  connectionString: "postgesql://postgres:test123@mydb:5432/mydb",
});

export const db = drizzle(pool);
