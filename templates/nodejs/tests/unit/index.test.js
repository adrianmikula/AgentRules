import request from 'supertest';
import { describe, it, expect } from '@jest/globals';
import app from '../../index.js';

describe('Node.js API Unit Tests', () => {
  describe('GET /', () => {
    it('returns greeting message', async () => {
      const res = await request(app).get('/');
      expect(res.status).toBe(200);
      expect(res.text).toBe('Node.js Template - Agentic Dev Velocity');
    });
  });

  describe('GET /health', () => {
    it('returns OK', async () => {
      const res = await request(app).get('/health');
      expect(res.status).toBe(200);
      expect(res.text).toBe('OK');
    });
  });

  describe('GET /api/users', () => {
    it('returns list of users', async () => {
      const res = await request(app).get('/api/users');
      expect(res.status).toBe(200);
      expect(res.body).toHaveLength(3);
      expect(res.body[0]).toHaveProperty('id');
      expect(res.body[0]).toHaveProperty('name');
      expect(res.body[0]).toHaveProperty('email');
    });

    it('has correct user data', async () => {
      const res = await request(app).get('/api/users');
      expect(res.body[0].name).toBe('User 1');
      expect(res.body[0].email).toBe('user1@example.com');
    });
  });

  describe('GET /api/users/:id', () => {
    it('returns single user', async () => {
      const res = await request(app).get('/api/users/42');
      expect(res.status).toBe(200);
      expect(res.body.id).toBe(42);
      expect(res.body.name).toBe('User 42');
      expect(res.body.email).toBe('user42@example.com');
    });
  });

  describe('GET /api/count', () => {
    it('increments and returns count', async () => {
      const res = await request(app).get('/api/count');
      expect(res.status).toBe(200);
      expect(res.body).toHaveProperty('count');
      expect(res.header['x-count']).toBeDefined();
    });
  });
});
