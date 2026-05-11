import { Request } from 'express';
import prisma from '../lib/prisma';

export const searchService = {
  searchDrink: async (req: Request) => {
    const q = String(req.query.q ?? '').trim();
    if (!q) return [];
    return prisma.drink.findMany({
      where: {
        name: { contains: q, mode: 'insensitive' },
      },
      include: {
        glass: { select: { name: true } },
        ingredients: {
          include: { ingredient: { select: { name: true } } },
          orderBy: { sortOrder: 'asc' },
        },
      },
      orderBy: { name: 'asc' },
    });
  },
};
