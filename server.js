require('dotenv').config();
const path = require('path');
const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');

const app = express();
const port = process.env.PORT || 3000;
const pool = new Pool({ connectionString: process.env.DATABASE_URL || 'postgres://guitar:guitar@db:5432/guitarshop' });
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

app.get('/api/products', async (req, res) => {
  try {
    const { rows } = await pool.query('SELECT * FROM products ORDER BY featured DESC, id');
    res.json(rows);
  } catch (error) { res.status(500).json({ error: 'Could not load guitars.' }); }
});

app.post('/api/orders', async (req, res) => {
  const { customerName, email, items } = req.body;
  if (!customerName || !email || !Array.isArray(items) || !items.length) return res.status(400).json({ error: 'Name, email, and cart items are required.' });
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    const ids = items.map(i => Number(i.id));
    const { rows: products } = await client.query('SELECT id, price FROM products WHERE id = ANY($1)', [ids]);
    const total = items.reduce((sum, item) => {
      const product = products.find(p => p.id === Number(item.id));
      return sum + (product ? Number(product.price) * Math.max(1, Number(item.quantity) || 1) : 0);
    }, 0);
    const order = await client.query('INSERT INTO orders (customer_name, email, total) VALUES ($1,$2,$3) RETURNING id, total, created_at', [customerName, email, total]);
    for (const item of items) {
      const product = products.find(p => p.id === Number(item.id));
      if (product) await client.query('INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES ($1,$2,$3,$4)', [order.rows[0].id, product.id, Math.max(1, Number(item.quantity) || 1), product.price]);
    }
    await client.query('COMMIT');
    res.status(201).json({ message: 'Order placed. We will be in touch shortly!', order: order.rows[0] });
  } catch (error) { await client.query('ROLLBACK'); res.status(500).json({ error: 'Could not create order.' }); }
  finally { client.release(); }
});

app.get('*', (req, res) => res.sendFile(path.join(__dirname, 'public', 'index.html')));
app.listen(port, () => console.log(`String Theory running on ${port}`));
