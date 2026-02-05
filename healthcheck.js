const http = require('http');

const options = {
  hostname: 'localhost',
  port: 3000,
  path: '/health',
  timeout: 2000
};

const healthCheck = http.request(options, (res) => {
  console.log(`HEALTHCHECK STATUS: ${res.statusCode}`);
  if (res.statusCode === 200) {
    process.exit(0);
  } else {
    process.exit(1);
  }
});

healthCheck.on('error', (_err) => {
  console.error('HEALTHCHECK FAILED');
  process.exit(1);
});

healthCheck.end();