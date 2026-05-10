import 'dotenv/config';

import cors from 'cors';
import express, { Request, Response, NextFunction } from 'express';
import cookieParser from 'cookie-parser';

// import rootRouter from './routers/root.router.js';

const app = express();

app.use(express.static('public'));
app.use(express.json());
app.use(cookieParser());

app.use(
  cors({
    origin: [process.env.CLIENT_URL ?? 'http://localhost:3000'],
    credentials: true,
  }),
);

// app.use('/api', rootRouter);

app.use((err: any, req: Request, res: Response, next: NextFunction) => {
  console.error('Error in middleware:', err);
  res.status(err?.status ?? 500).json({
    message: err?.message ?? 'Internal Server Error',
    ...(process.env.NODE_ENV !== 'production' && { stack: err?.stack }),
  });
});

const port = Number(process.env.PORT) || 3069;
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});

export default app;
