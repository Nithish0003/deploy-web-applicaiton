const express = require('express');
const app = express();
const dataRoutes = require('./routes/dataRoutes');

app.use(express.json());
app.use('/data', dataRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});