import { getConnection } from '../db.js';
import sql from 'mssql';

// Validation Helper
const validateProduct = (product) => {
  const { PRODUCTNAME, PRICE, STOCK } = product;
  if (!PRODUCTNAME || PRICE == null || STOCK == null) {
    return 'Product name, price, and stock are required.';
  }
  if (PRICE <= 0 || STOCK < 0) {
    return 'Price must be positive, and stock must be non-negative.';
  }
  return null;
};

export const getProducts = async (req, res) => {
  try {
    const pool = await getConnection();
    const result = await pool.request().query('SELECT * FROM PRODUCTS');
    res.json(result.recordset);
  } catch (error) {
    res.status(500).send(error.message);
  }
};

export const getProductById = async (req, res) => {
  try {
    const pool = await getConnection();
    const result = await pool
      .request()
      .input('id', sql.Int, req.params.id)
      .query('SELECT * FROM PRODUCTS WHERE PRODUCTID = @id');

    if (result.recordset.length === 0) {
      return res.status(404).json({ message: 'Product not found' });
    }
    res.json(result.recordset[0]);
  } catch (error) {
    res.status(500).send(error.message);
  }
};

export const createProduct = async (req, res) => {
  const validationError = validateProduct(req.body);
  if (validationError) {
    return res.status(400).json({ message: validationError });
  }

  const { PRODUCTNAME, PRICE, STOCK } = req.body;

  try {
    const pool = await getConnection();
    const result = await pool
      .request()
      .input('name', sql.NVarChar, PRODUCTNAME)
      .input('price', sql.Decimal(10, 2), PRICE)
      .input('stock', sql.Int, STOCK)
      .query(
        'INSERT INTO PRODUCTS (PRODUCTNAME, PRICE, STOCK) OUTPUT INSERTED.* VALUES (@name, @price, @stock)'
      );
    res.status(201).json(result.recordset[0]);
  } catch (error) {
    res.status(500).send(error.message);
  }
};

export const updateProduct = async (req, res) => {
  const validationError = validateProduct(req.body);
  if (validationError) {
    return res.status(400).json({ message: validationError });
  }

  const { PRODUCTNAME, PRICE, STOCK } = req.body;

  try {
    const pool = await getConnection();
    const result = await pool
      .request()
      .input('id', sql.Int, req.params.id)
      .input('name', sql.NVarChar, PRODUCTNAME)
      .input('price', sql.Decimal(10, 2), PRICE)
      .input('stock', sql.Int, STOCK)
      .query(
        'UPDATE PRODUCTS SET PRODUCTNAME = @name, PRICE = @price, STOCK = @stock OUTPUT INSERTED.* WHERE PRODUCTID = @id'
      );

    if (result.recordset.length === 0) {
      return res.status(404).json({ message: 'Product not found' });
    }
    res.json(result.recordset[0]);
  } catch (error) {
    res.status(500).send(error.message);
  }
};

export const deleteProduct = async (req, res) => {
  try {
    const pool = await getConnection();
    const result = await pool
      .request()
      .input('id', sql.Int, req.params.id)
      .query('DELETE FROM PRODUCTS WHERE PRODUCTID = @id');

    if (result.rowsAffected[0] === 0) {
      return res.status(404).json({ message: 'Product not found' });
    }
    res.sendStatus(204); // No Content
  } catch (error) {
    res.status(500).send(error.message);
  }
};