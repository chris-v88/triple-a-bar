import express from 'express';
import searchRouter from './search.router';

const rootRouter = express.Router();

rootRouter.use('/search', searchRouter);

export default rootRouter;
