# DevOps Portfolio Project

A comprehensive DevOps portfolio showcasing modern CI/CD practices, infrastructure as code, and automated deployment pipelines.

## Project Overview

This project demonstrates industry-standard DevOps skills through an end-to-end automated deployment pipeline featuring:

- **Simple Node.js Web Application** - Express.js with health checks and monitoring endpoints
- **Containerization** - Docker with optimized multi-stage builds
- **CI/CD Pipeline** - GitHub Actions with comprehensive testing and deployment
- **Infrastructure as Code** - Terraform for AWS resource management (coming soon)
- **Configuration Management** - Ansible for automated server configuration (coming soon)
- **Security Scanning** - Trivy vulnerability scanning and automated security checks

## Architecture

```
┌─────────────┐    ┌──────────────┐    ┌─────────────┐    ┌──────────────┐
│   Developer │───▶│ GitHub       │───▶│ GitHub      │───▶│ AWS          │
│   Commits   │    │ Repository   │    │ Actions     │    │ Infrastructure│
└─────────────┘    └──────────────┘    │ CI/CD       │    │              │
                                       └─────────────┘    └──────────────┘
                                              │
                                              ▼
                   ┌─────────────┐    ┌──────────────┐    ┌─────────────┐
                   │   Docker    │◀───│  Build &     │───▶│  Staging    │
                   │   Registry  │    │  Test        │    │  Environment│
                   └─────────────┘    └──────────────┘    └─────────────┘
                                              │
                                              ▼
                                       ┌──────────────┐
                                       │  Production  │
                                       │  Environment │
                                       └──────────────┘
```

## Quick Start

### Prerequisites

- Node.js 18+ and npm
- Docker and Docker Compose
- Git
- AWS Account (for full deployment)

### Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/Gog2006/DevOps_project1.git
   cd DevOps_project1
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Run tests**
   ```bash
   npm test
   npm run lint
   ```

4. **Start the application**
   ```bash
   npm start
   # Application available at http://localhost:3000
   ```

### Docker Deployment

1. **Build the Docker image**
   ```bash
   docker build -t devops-portfolio-app .
   ```

2. **Run with Docker Compose**
   ```bash
   docker-compose up -d
   ```

3. **Health check**
   ```bash
   curl http://localhost:3000/health
   ```

## Testing

### Unit Tests
```bash
npm test              # Run all tests
npm test -- --watch   # Run tests in watch mode
npm test -- --coverage # Generate coverage report
```

### Linting
```bash
npm run lint          # Check code style
npm run lint:fix      # Auto-fix lint issues
```

### Docker Testing
```bash
# Build and test the container
docker build -t devops-portfolio-app:test .
docker run --rm -p 3000:3000 devops-portfolio-app:test

# Run container health check
docker run --rm devops-portfolio-app:test node healthcheck.js
```

## CI/CD Pipeline

The GitHub Actions workflow ([.github/workflows/ci-cd.yml](.github/workflows/ci-cd.yml)) includes:

### 1. **Code Quality & Testing**
- ESLint code style checking
- Jest unit tests with coverage reporting
- Security vulnerability scanning with npm audit

### 2. **Security Scanning**
- Trivy vulnerability scanner for filesystem
- SARIF upload to GitHub Security tab
- Docker image security analysis

### 3. **Build & Push**
- Multi-architecture Docker builds (AMD64, ARM64)
- GitHub Container Registry publishing
- Image tagging strategy (latest, branch, SHA)
- Build caching for faster builds

### 4. **Deployment**
- **Staging**: Automated deployment on develop branch
- **Production**: Manual approval required on main branch
- AWS credential configuration
- Environment-specific configurations

### 5. **Post-Deployment**
- Health checks and smoke tests
- End-to-end testing (planned)
- Deployment notifications

## Project Structure

```
DevOps_project1/
├── .github/
│   └── workflows/
│       └── ci-cd.yml           # GitHub Actions CI/CD pipeline
├── public/
│   └── index.html              # Frontend application
├── tests/
│   └── app.test.js             # Unit tests
├── terraform/                  # Infrastructure as Code (coming soon)
├── ansible/                    # Configuration management (coming soon)
├── app.js                      # Main application server
├── Dockerfile                  # Container configuration
├── docker-compose.yml          # Local development setup
├── healthcheck.js              # Container health check
├── package.json                # Node.js dependencies and scripts
├── jest.config.js              # Jest testing configuration
├── .eslintrc.json              # ESLint configuration
└── README.md                   # This file
```

## Technology Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Application** | Node.js + Express.js | Web server and API |
| **Frontend** | HTML5 + CSS3 + Vanilla JS | User interface |
| **Testing** | Jest + Supertest | Unit and integration testing |
| **Code Quality** | ESLint | Code linting and formatting |
| **Containerization** | Docker + Docker Compose | Application packaging |
| **CI/CD** | GitHub Actions | Automated testing and deployment |
| **Security** | Trivy + npm audit | Vulnerability scanning |
| **Cloud** | AWS (planned) | Infrastructure hosting |
| **IaC** | Terraform (planned) | Infrastructure provisioning |
| **Config Mgmt** | Ansible (planned) | Server configuration |

## Monitoring & Health Checks

### Application Endpoints

- **`GET /`** - Main application page
- **`GET /health`** - Health check endpoint
- **`GET /api/info`** - Application information and version

### Health Check Response
```json
{
  "status": "healthy",
  "timestamp": "2024-02-05T10:30:00.000Z",
  "version": "1.0.0"
}
```

### Docker Health Checks
The application includes built-in Docker health checks:
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node healthcheck.js
```

## Security Features

- **Helmet.js** - Security headers middleware
- **Non-root container user** - Enhanced container security
- **Dependency scanning** - Automated vulnerability detection
- **Code scanning** - SARIF integration with GitHub Security
- **Secrets management** - Environment-based configuration

## Environment Configuration

### Development
```bash
NODE_ENV=development
PORT=3000
```

### Production
```bash
NODE_ENV=production
PORT=3000
```

### Docker Environment Variables
```yaml
environment:
  - NODE_ENV=production
  - PORT=3000
```

## Deployment Strategies

### Current: Basic CI/CD
- Automated testing on every push
- Docker image building and publishing
- Manual production deployments

### Planned: Advanced Deployments
- Blue-green deployments
- Rolling updates with zero downtime
- Automated rollback capabilities
- Infrastructure scaling

## Development Workflow

1. **Feature Development**
   ```bash
   git checkout -b feature/new-feature
   npm run dev  # Start development server
   npm test -- --watch  # Run tests in watch mode
   ```

2. **Testing & Quality Assurance**
   ```bash
   npm run lint         # Check code style
   npm test            # Run all tests
   docker-compose up   # Test with Docker
   ```

3. **Deployment**
   ```bash
   git push origin feature/new-feature
   # Create pull request
   # GitHub Actions runs CI pipeline
   # Merge to develop for staging deployment
   # Merge to main for production deployment
   ```

## Troubleshooting

### Common Issues

**Port already in use**
```bash
lsof -ti:3000 | xargs kill
```

**Docker build failures**
```bash
docker system prune -a  # Clean up Docker cache
docker build --no-cache -t devops-portfolio-app .
```

**Test failures**
```bash
npm test -- --verbose  # Detailed test output
npm test -- --detectOpenHandles  # Debug hanging tests
```

### Logs and Debugging

**Application logs**
```bash
npm start 2>&1 | tee app.log
```

**Docker logs**
```bash
docker logs $(docker ps -q --filter ancestor=devops-portfolio-app)
```

## Cost Estimation (AWS)

This project is designed to be AWS Free Tier compatible:

- **EC2 t2.micro**: $0 (free tier)
- **Application Load Balancer**: ~$16/month
- **Route 53**: ~$0.50/month
- **S3**: ~$1-3/month
- **Total estimated**: ~$17-20/month

## Cleanup

### Local Cleanup
```bash
docker-compose down -v
docker system prune -a
npm run clean  # If available
```

### AWS Cleanup (when implemented)
```bash
terraform destroy
```

## Skills Demonstrated

This project showcases the following DevOps competencies:

- **Version Control**: Git workflows and branching strategies
- **Containerization**: Docker and Docker Compose
- **CI/CD Pipelines**: GitHub Actions automation
- **Testing**: Unit tests, integration tests, and code coverage
- **Code Quality**: Linting, formatting, and security scanning
- **Monitoring**: Health checks and application observability
- **Infrastructure as Code**: Terraform (in progress)
- **Configuration Management**: Ansible (in progress)
- **Cloud Deployment**: AWS services (planned)
- **Orchestration**: Kubernetes (advanced phase)

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

Project Link: [https://github.com/Gog2006/DevOps_project1](https://github.com/Gog2006/DevOps_project1)

---

**Built for DevOps Excellence**
