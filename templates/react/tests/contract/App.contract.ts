import { render, screen } from '@testing-library/react';
import { describe, it, expect } from 'vitest';
import App from '../../src/App';

// Contract tests ensure API compatibility
describe('App Contract Tests', () => {
  it('matches App component API contract', () => {
    render(<App />);
    const appElement = document.querySelector('.app');
    expect(appElement).not.toBeNull();
  });

  it('expects counter section to exist', () => {
    render(<App />);
    const counterSection = document.querySelector('.counter');
    expect(counterSection).not.toBeNull();
  });

  it('expects users section to exist', () => {
    render(<App />);
    const usersSection = document.querySelector('.users');
    expect(usersSection).not.toBeNull();
  });

  it('renders expected heading text', () => {
    render(<App />);
    expect(screen.getByRole('heading', { level: 1 })).toHaveTextContent('React Template');
  });

  it('renders user list as unordered list', () => {
    render(<App />);
    const userList = document.querySelector('.users ul');
    expect(userList).not.toBeNull();
  });
});
