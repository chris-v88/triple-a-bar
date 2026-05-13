import type { Drink } from '../types';

export const searchDrinks = async (q: string): Promise<Drink[]> => {
  const res = await fetch(`/api/search/drink?q=${encodeURIComponent(q)}`);
  if (!res.ok) throw new Error('Failed to search drinks');
  const json = await res.json();
  return json.data;
};
