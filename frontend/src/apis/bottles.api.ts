import type { Bottle } from '../types';

export const searchBottles = async (q: string): Promise<Bottle[]> => {
  const res = await fetch(`/api/search/bottle?q=${encodeURIComponent(q)}`);
  if (!res.ok) throw new Error('Failed to search bottles');
  const json = await res.json();
  return json.data;
};
