import { axiosInstance } from './axiosInstance';
import type { Drink } from '../types';

export const searchDrinks = async (q: string): Promise<Drink[]> => {
  const { data } = await axiosInstance.get<{ data: Drink[] }>('/search/drink', { params: { q } });
  return data.data;
};
