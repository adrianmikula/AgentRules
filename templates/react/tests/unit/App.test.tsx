import { render, screen, fireEvent } from '@testing-library/react';
import { describe, it, expect } from '@jest/globals';
import App from '../../src/App';

describe('App', () => {
  it('renders without crashing', () => {
    render(<App />);
    expect(screen.getByText('React Template')).toBeInTheDocument();
  });

  it('shows initial count of 0', () => {
    render(<App />);
    expect(screen.getByText('Count: 0')).toBeInTheDocument();
  });

  it('increments count when increment button is clicked', () => {
    render(<App />);
    const incrementButton = screen.getByText('Increment');
    fireEvent.click(incrementButton);
    expect(screen.getByText('Count: 1')).toBeInTheDocument();
  });

  it('decrements count when decrement button is clicked', () => {
    render(<App />);
    const decrementButton = screen.getByText('Decrement');
    fireEvent.click(decrementButton);
    expect(screen.getByText('Count: -1')).toBeInTheDocument();
  });

  it('adds user when add user button is clicked', () => {
    render(<App />);
    const addUserButton = screen.getByText('Add User');
    fireEvent.click(addUserButton);
    expect(screen.getByText('User 1 (user1@example.com)')).toBeInTheDocument();
  });

  it('tracks correct user count', () => {
    render(<App />);
    const addUserButton = screen.getByText('Add User');
    fireEvent.click(addUserButton);
    fireEvent.click(addUserButton);
    const userItems = screen.getAllByRole('listitem');
    expect(userItems).toHaveLength(2);
  });
});
