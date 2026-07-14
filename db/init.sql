CREATE TABLE IF NOT EXISTS products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  brand VARCHAR(80) NOT NULL,
  category VARCHAR(50) NOT NULL,
  price NUMERIC(10,2) NOT NULL,
  image TEXT NOT NULL,
  description TEXT NOT NULL,
  featured BOOLEAN DEFAULT false
);
CREATE TABLE IF NOT EXISTS orders (
  id SERIAL PRIMARY KEY,
  customer_name VARCHAR(120) NOT NULL,
  email VARCHAR(160) NOT NULL,
  total NUMERIC(10,2) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS order_items (
  id SERIAL PRIMARY KEY,
  order_id INTEGER REFERENCES orders(id) ON DELETE CASCADE,
  product_id INTEGER REFERENCES products(id),
  quantity INTEGER NOT NULL,
  unit_price NUMERIC(10,2) NOT NULL
);
INSERT INTO products (name, brand, category, price, image, description, featured) VALUES
('American Vintage II Stratocaster', 'Fender', 'Electric', 2249.00, 'https://images.unsplash.com/photo-1550985616-10810253b84d?auto=format&fit=crop&w=900&q=85', 'A timeless alder-body icon with crystalline single-coil character.', true),
('Les Paul Standard 60s', 'Gibson', 'Electric', 2799.00, 'https://images.unsplash.com/photo-1564186763535-ebb21ef5277f?auto=format&fit=crop&w=900&q=85', 'Mahogany warmth, figured maple flame, and singing sustain.', true),
('Academy 12e', 'Taylor', 'Acoustic', 849.00, 'https://images.unsplash.com/photo-1510915361894-db8b60106cb1?auto=format&fit=crop&w=900&q=85', 'A responsive, player-friendly acoustic built for everyday inspiration.', true),
('Player II Telecaster', 'Fender', 'Electric', 799.00, 'https://images.unsplash.com/photo-1525201548942-d8732f6617a0?auto=format&fit=crop&w=900&q=85', 'The no-nonsense workhorse with bite, twang, and modern comfort.', false),
('D-10E Road Series', 'Martin', 'Acoustic', 999.00, 'https://images.unsplash.com/photo-1511379938547-c1f69419868d?auto=format&fit=crop&w=900&q=85', 'Solid-top authority with stage-ready electronics.', false),
('SR300E', 'Ibanez', 'Bass', 399.00, 'https://images.unsplash.com/photo-1558098329-a11cff621064?auto=format&fit=crop&w=900&q=85', 'Fast neck, versatile electronics, and punchy low-end definition.', false)
ON CONFLICT DO NOTHING;
