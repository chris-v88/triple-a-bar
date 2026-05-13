import { Request, Response, NextFunction } from 'express';
import { searchService } from '../services/search.service';
import { responseSuccess } from '../common/helpers/response.helpers';

export const searchController = {
  searchDrink: async (req: Request, res: Response, next: NextFunction) => {
    try {
      const result = await searchService.searchDrink(req);
      const response = responseSuccess(result, 'Search drinks successfully');
      res.status(response.statusCode).json(response);
    } catch (err) {
      next(err);
    }
  },

  searchBottle: async (req: Request, res: Response, next: NextFunction) => {
    try {
      const result = await searchService.searchBottle(req);
      const response = responseSuccess(result, 'Search bottles successfully');
      res.status(response.statusCode).json(response);
    } catch (err) {
      next(err);
    }
  },
};