import { PrismaClient } from '../generated/prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { Pool } from 'pg';

const pool = new Pool({ connectionString: process.env.DATABASE_URL! });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

prisma.$executeRaw`SELECT 1+1 AS result`
  .then(() => console.log('PRISMA: \t Connected to the database'))
  .catch((error) => console.error('PRISMA: \t Error connecting to the database:', error));

export default prisma;
