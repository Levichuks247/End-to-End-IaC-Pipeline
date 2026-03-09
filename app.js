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

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('V11: App is Up and Database is Connected!\n');
});

const PORT = process.env.PORT || 80;
server.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Server running on port ${PORT}`);
  connectWithRetry();
});