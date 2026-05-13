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

  searchBottle: async (req: Request) => {
    const q = String(req.query.q ?? '').trim();
    if (!q) return [];

    const matchingCategories = await prisma.spiritCategory.findMany({
      where: {
        OR: [
          { name: { contains: q, mode: 'insensitive' } },
          { description: { contains: q, mode: 'insensitive' } },
        ],
      },
      select: { id: true },
    });

    if (matchingCategories.length === 0) return [];

    const categoryIds = matchingCategories.map((c) => c.id);

    return prisma.bottle.findMany({
      where: { categoryId: { in: categoryIds } },
      include: {
        brand: { select: { name: true } },
        category: { select: { name: true, description: true } },
      },
      orderBy: [
        { category: { name: 'asc' } },
        { brand: { name: 'asc' } },
        { name: 'asc' },
      ],
    });
  },
};
