import express from 'express';
import cors from 'cors';
import config from './config.js';
import productRoutes from './routes/product.routes.js';

const app = express();

// Settings
app.set('port', config.port);

// Middlewares
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

// Routes
app.use('/products', productRoutes);

// Start server
app.listen(app.get('port'), () => {
  console.log(`Server is running on port ${app.get('port')}`);
});