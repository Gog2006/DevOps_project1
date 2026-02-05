const request = require('supertest');
const app = require('../app');

describe('DevOps Portfolio App', () => {
  describe('GET /', () => {
    it('should return 200 status', async () => {
      const res = await request(app).get('/');
      expect(res.statusCode).toBe(200);
    });
  });

  describe('GET /health', () => {
    it('should return health status', async () => {
      const res = await request(app).get('/health');
      expect(res.statusCode).toBe(200);
      expect(res.body).toHaveProperty('status', 'healthy');
      expect(res.body).toHaveProperty('timestamp');
      expect(res.body).toHaveProperty('version');
    });
  });

  describe('GET /api/info', () => {
    it('should return app information', async () => {
      const res = await request(app).get('/api/info');
      expect(res.statusCode).toBe(200);
      expect(res.body).toHaveProperty('message');
      expect(res.body).toHaveProperty('environment');
      expect(res.body).toHaveProperty('version');
      expect(res.body).toHaveProperty('hostname');
    });
  });

  describe('GET /nonexistent', () => {
    it('should return 404 for non-existent routes', async () => {
      const res = await request(app).get('/nonexistent');
      expect(res.statusCode).toBe(404);
      expect(res.body).toHaveProperty('error', 'Route not found');
    });
  });
});