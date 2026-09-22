const express = require('express');

const app = express();
const port = process.env.PORT || 3001;

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok', service: 'order-service' });
});

app.get('/api/orders', (req, res) => {
  res.status(200).json([
    { id: 101, userId: 1, total: 999.99 },
    { id: 102, userId: 2, total: 499.99 }
  ]);
});

app.listen(port, () => {
  console.log(`Order Service listening on port ${port}`);
});
