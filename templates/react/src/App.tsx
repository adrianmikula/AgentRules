import { useState } from 'react';
import './App.css';

interface User {
  id: number;
  name: string;
  email: string;
}

function App(): JSX.Element {
  const [count, setCount] = useState(0);
  const [users, setUsers] = useState<User[]>([]);

  const addUser = (): void => {
    const newUser: User = {
      id: Date.now(),
      name: `User ${count + 1}`,
      email: `user${count + 1}@example.com`,
    };
    setUsers([...users, newUser]);
    setCount(count + 1);
  };

  return (
    <div className="app">
      <h1>React Template</h1>
      <p>Agentic Dev Velocity - Fast Iteration</p>
      
      <div className="counter">
        <p>Count: {count}</p>
        <button onClick={() => setCount(count + 1)}>Increment</button>
        <button onClick={() => setCount(count - 1)}>Decrement</button>
      </div>

      <div className="users">
        <h2>Users</h2>
        <button onClick={addUser}>Add User</button>
        <ul>
          {users.map((user) => (
            <li key={user.id}>
              {user.name} ({user.email})
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}

export default App;
