import request from 'supertest';
import { describe, it, expect } from '@jest/globals';
import app from '../../index.js';

// Contract tests ensure API compatibility

describe('User Schema Contract', () => {
  it('user object has required fields', async () => {
    const res = await request(app).get('/api/users/1');
    expect(res.status).toBe(200);
    expect(res.body).toHaveProperty('id');
    expect(res.body).toHaveProperty('name');
    expect(res.body).toHaveProperty('email');
  });

  it('id is a number', async () => {
    const res = await request(app).get('/api/users/1');
    expect(res.status).toBe(200);
    expect(typeof res.body.id).toBe('number');
  });

  it('name is a string', async () => {
    const res = await request(app).get('/api/users/1');
    expect(res.status).toBe(200);
    expect(typeof res.body.name).toBe('string');
  });

  it('email is a string', async () => {
    const res = await request(app).get('/api/users/1');
    expect(res.status).toBe(200);
    expect(typeof res.body.email).toBe('string');
  });
});

describe('API Endpoints Contract', () => {
  it('GET / returns 200', async () => {
    const res = await request(app).get('/');
    expect(res.status).toBe(200);
  });

  it('GET /health returns 200', async () => {
    const res = await request(app).get('/health');
    expect(res.status).toBe(200);
  });

  it('GET /api/users returns JSON', async () => {
    const res = await request(app).get('/api/users');
    expect(res.status).toBe(200);
    expect(res.headers['content-type']).toContain('application/json');
  });

  it('GET /api/users returns array', async () => {
    const res = await request(app).get('/api/users');
    expect(res.status).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
  });

  it('GET /api/users/:id returns JSON', async () => {
    const res = await request(app).get('/api/users/1');
    expect(res.status).toBe(200);
    expect(res.headers['content-type']).toContain('application/json');
  });

  it('GET /api/count returns JSON with count', async () => {
    const res = await request(app).get('/api/count');
    expect(res.status).toBe(200);
    expect(res.body).toHaveProperty('count');
    expect(res.header['x-count']).toBeDefined();
  });
});

describe('Users List Contract', () => {
  it('returns at least 3 users', async () => {
    const res = await request(app).get('/api/users');
    expect(res.status).toBe(200);
    expect(res.body.length).toBeGreaterThanOrEqual(3);
  });

  it('users have sequential IDs', async () => {
    const res = await request(app).get('/api/users');
    expect(res.status).toBe(200);
    expect(res.body[0].id).toBe(1);
    expect(res.body[1].id).toBe(2);
    expect(res.body[2].id).toBe(3);
  });
});
