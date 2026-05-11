export type Ingredient = {
  id: number;
  sortOrder: number;
  quantity: string | null;
  unit: string | null;
  note: string | null;
  ingredient: { name: string };
};

export type Drink = {
  id: number;
  name: string;
  method: string;
  garnish: string | null;
  glass: { name: string };
  ingredients: Ingredient[];
};
