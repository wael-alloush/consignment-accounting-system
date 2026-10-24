const prisma = require("../src/config/db");

async function main() {
  const rows = await prisma.$queryRaw`SELECT 1 AS ok`;
  console.log("DB OK:", rows);
}

main()
  .then(() => prisma.$disconnect())
  .catch(async (e) => {
    console.error(e);
    await prisma.$disconnect();
    process.exit(1);
  });
