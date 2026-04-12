const { Client } = require('pg');
const http = require('http');

const dbConfig = {
  host: process.env.DB_HOSTNAME,
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  port: 5432,
};

async function connectWithRetry() {
  console.log('Attempting to connect to database...');
  while (true) {
    const client = new Client(dbConfig);
    try {
      await client.connect();
      console.log('✅ Connected to PostgreSQL');
      return client;
    } catch (err) {
      console.error('❌ Connection failed. Retrying in 5 seconds...');
      await new Promise(resolve => setTimeout(resolve, 5000));
    }
  }
}

const server = http.createServer(async (req, res) => {
  // TPO IMPROVEMENT: Added a Health Check endpoint
  if (req.url === '/health') {
    res.writeHead(200);
    res.end('Healthy');
    return;
  }

  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('V1.1.0: Enterprise SaaS Infrastructure is Active\n');
});

const PORT = process.env.PORT || 80;
server.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Server running on port ${PORT}`);
  connectWithRetry();
});