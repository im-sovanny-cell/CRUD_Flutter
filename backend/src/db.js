import sql from 'mssql';
import config from './config.js';

const dbSettings = {
  user: config.dbUser,
  password: config.dbPassword,
  server: config.dbServer,
  database: config.dbDatabase,
  port: config.dbPort,
  options: {
    encrypt: false, // Use true for Azure SQL
    trustServerCertificate: true,
  },
};

export async function getConnection() {
  try {
    const pool = await sql.connect(dbSettings);
    return pool;
  } catch (error) {
    console.error('Database connection error:', error);
  }
}