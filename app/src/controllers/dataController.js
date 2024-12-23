const dbService = require('../services/dbService');

exports.getData = async (req, res) => {
  try {
    const data = await dbService.fetchData();
    res.json(data);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};