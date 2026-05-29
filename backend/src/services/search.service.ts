import { Request } from 'express';
import prisma from '../lib/prisma';

type BottleRow = {
  id: bigint;
  name: string;
  abv: string | null;
  proof: string | null;
  brandName: string;
  categoryName: string;
  categoryDescription: string | null;
};

export const searchService = {
  searchDrink: async (req: Request) => {
    const q = String(req.query.q ?? '').trim();
    if (!q) return [];

    const pattern = `%${q}%`;
    const matchingIds = await prisma.$queryRaw<{ id: bigint }[]>`
      SELECT id FROM "Drinks"
      WHERE unaccent(name) ILIKE unaccent(${pattern})
    `;
    if (matchingIds.length === 0) return [];

    const ids = matchingIds.map((r) => Number(r.id));
    return prisma.drink.findMany({
      where: { id: { in: ids } },
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

    const pattern = `%${q}%`;
    const rows = await prisma.$queryRaw<BottleRow[]>`
      SELECT
        b.id,
        b.name,
        b.abv::text            AS abv,
        b.proof::text          AS proof,
        br.name                AS "brandName",
        sc.name                AS "categoryName",
        sc.description         AS "categoryDescription"
      FROM      "Bottles"     b
      JOIN      "Brands"      br ON b.brand_id    = br.id
      JOIN      "SpiritTypes" sc ON b.category_id = sc.id
      WHERE  unaccent(b.name)         ILIKE unaccent(${pattern})
          OR unaccent(br.name)        ILIKE unaccent(${pattern})
          OR unaccent(sc.name)        ILIKE unaccent(${pattern})
          OR unaccent(sc.description) ILIKE unaccent(${pattern})
      ORDER BY sc.name, br.name, b.name
    `;

    return rows.map((r) => ({
      id: Number(r.id),
      name: r.name,
      abv: r.abv,
      proof: r.proof,
      brand: { name: r.brandName },
      category: { name: r.categoryName, description: r.categoryDescription },
    }));
  },
};
