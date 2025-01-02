import express from 'express';
import { setupVite } from './vite';
import routes from './routes';

const app = express();
app.use(express.json());

// API routes
app.use(routes);

const PORT = process.env.PORT || 3000;

if (process.env.NODE_ENV === 'development') {
  setupVite(app);
} else {
  app.use(express.static('dist'));
}

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on port ${PORT}`);
});
