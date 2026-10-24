// backend/src/config/db.js
import dotenv from 'dotenv';
dotenv.config(); 

import { PrismaClient } from "@prisma/client";
import { PrismaMariaDb } from "@prisma/adapter-mariadb";

function createAdapter() {
  const url = process.env.DATABASE_URL;
  if (!url) {
    throw new Error("DATABASE_URL is missing in .env");
  }

  // mysql://user:pass@host:port/database
  const parsed = new URL(url);
  return new PrismaMariaDb({
    host: parsed.hostname || "127.0.0.1",
    port: Number(parsed.port || 3306),
    user: decodeURIComponent(parsed.username || "root"),
    password: decodeURIComponent(parsed.password || ""),
    database: parsed.pathname.replace(/^\//, ""),
    connectionLimit: 5,
  });
}

const prisma = new PrismaClient({ adapter: createAdapter() });

export default prisma;
