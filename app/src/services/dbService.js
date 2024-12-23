const mysql = require('mysql2/promise');
const dbConfig = require('../config/dbConfig');

exports.fetchData = async () => {
  const connection = await mysql.createConnection(dbConfig);
  const [rows] = await connection.execute('SELECT * FROM your_table');
  await connection.end();
  return rows;
};