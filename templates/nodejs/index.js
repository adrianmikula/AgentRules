import express from 'express';

const app = express();
const port = process.env.PORT || 8080;

// Middleware
app.use(express.json());

// Counter for requests
let requestCount = 0;

// Routes
app.get('/', (req, res) => {
  res.send('Node.js Template - Agentic Dev Velocity');
});

app.get('/health', (req, res) => {
  res.send('OK');
});

app.get('/api/count', (req, res) => {
  requestCount++;
  res.set('X-Count', String(requestCount));
  res.json({ count: requestCount });
});

app.get('/api/users', (req, res) => {
  const users = [
    { id: 1, name: 'User 1', email: 'user1@example.com' },
    { id: 2, name: 'User 2', email: 'user2@example.com' },
    { id: 3, name: 'User 3', email: 'user3@example.com' },
  ];
  res.json(users);
});

app.get('/api/users/:id', (req, res) => {
  const { id } = req.params;
  const user = {
    id: Number(id),
    name: `User ${id}`,
    email: `user${id}@example.com`,
  };
  res.json(user);
});

// Start server
app.listen(port, () => {
  console.log(`Server starting on :${port}`);
});

export default app;
