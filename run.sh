#!/bin/bash

# DevOps Portfolio Project - Setup and Run Script
# This script automates the setup and running of the DevOps portfolio project

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    local missing_tools=()
    
    if ! command_exists node; then
        missing_tools+=("node")
    fi
    
    if ! command_exists npm; then
        missing_tools+=("npm")
    fi
    
    if ! command_exists docker; then
        missing_tools+=("docker")
    fi
    
    if ! command_exists docker-compose; then
        missing_tools+=("docker-compose")
    fi
    
    if [ ${#missing_tools[@]} -ne 0 ]; then
        print_error "Missing required tools: ${missing_tools[*]}"
        echo "Please install the missing tools and run this script again."
        exit 1
    fi
    
    print_success "All prerequisites are met!"
}

# Function to install npm dependencies
install_dependencies() {
    print_status "Installing Node.js dependencies..."
    npm install
    print_success "Dependencies installed successfully!"
}

# Function to run tests
run_tests() {
    print_status "Running tests..."
    npm run lint
    npm test
    print_success "All tests passed!"
}

# Function to build Docker image
build_docker() {
    print_status "Building Docker image..."
    docker build -t devops-portfolio-app .
    print_success "Docker image built successfully!"
}

# Function to start the application
start_app() {
    local mode=$1
    
    case $mode in
        "local")
            print_status "Starting application locally..."
            npm start &
            LOCAL_PID=$!
            sleep 3
            ;;
        "docker")
            print_status "Starting application with Docker..."
            docker run -d -p 3000:3000 --name devops-portfolio-app devops-portfolio-app
            sleep 3
            ;;
        "compose")
            print_status "Starting application with Docker Compose..."
            docker-compose up -d
            sleep 5
            ;;
        *)
            print_error "Invalid mode: $mode"
            exit 1
            ;;
    esac
}

# Function to test the application
test_app() {
    print_status "Testing application endpoints..."
    
    # Test health endpoint
    if curl -f -s http://localhost:3000/health > /dev/null; then
        print_success "Health endpoint is working!"
    else
        print_error "Health endpoint failed!"
        return 1
    fi
    
    # Test main page
    if curl -f -s http://localhost:3000 > /dev/null; then
        print_success "Main page is accessible!"
    else
        print_error "Main page failed!"
        return 1
    fi
    
    # Test API endpoint
    if curl -f -s http://localhost:3000/api/info > /dev/null; then
        print_success "API endpoint is working!"
    else
        print_error "API endpoint failed!"
        return 1
    fi
    
    print_success "All endpoints are working correctly!"
}

# Function to cleanup
cleanup() {
    print_status "Cleaning up..."
    
    # Kill local process if it exists
    if [ ! -z "$LOCAL_PID" ]; then
        kill $LOCAL_PID 2>/dev/null || true
    fi
    
    # Stop and remove Docker containers
    docker-compose down 2>/dev/null || true
    docker stop devops-portfolio-app 2>/dev/null || true
    docker rm devops-portfolio-app 2>/dev/null || true
    
    print_success "Cleanup completed!"
}

# Function to show help
show_help() {
    echo "DevOps Portfolio Project - Setup and Run Script"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  setup          - Install dependencies and run tests"
    echo "  start-local    - Start application locally with Node.js"
    echo "  start-docker   - Start application with Docker"
    echo "  start-compose  - Start application with Docker Compose"
    echo "  test           - Run all tests (lint + unit tests)"
    echo "  build          - Build Docker image"
    echo "  clean          - Clean up running containers and processes"
    echo "  full           - Run full pipeline (setup + build + test + start)"
    echo "  help           - Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 setup          # Install dependencies and run tests"
    echo "  $0 start-local    # Start the app locally"
    echo "  $0 full           # Complete setup and start"
    echo ""
}

# Function to run full pipeline
run_full_pipeline() {
    print_status "Running full DevOps pipeline..."
    
    check_prerequisites
    install_dependencies
    run_tests
    build_docker
    start_app "compose"
    test_app
    
    print_success "Full pipeline completed successfully!"
    echo ""
    echo "Application is running at: http://localhost:3000"
    echo "Health check: http://localhost:3000/health"
    echo "API info: http://localhost:3000/api/info"
    echo ""
    echo "To stop the application, run: $0 clean"
}

# Trap to cleanup on exit
trap cleanup EXIT

# Main script logic
case ${1:-help} in
    "setup")
        check_prerequisites
        install_dependencies
        run_tests
        print_success "Setup completed!"
        ;;
    "start-local")
        check_prerequisites
        start_app "local"
        test_app
        print_success "Application is running locally at http://localhost:3000"
        echo "Press Ctrl+C to stop..."
        wait
        ;;
    "start-docker")
        check_prerequisites
        build_docker
        start_app "docker"
        test_app
        print_success "Application is running with Docker at http://localhost:3000"
        echo "To stop: docker stop devops-portfolio-app"
        ;;
    "start-compose")
        check_prerequisites
        start_app "compose"
        test_app
        print_success "Application is running with Docker Compose at http://localhost:3000"
        echo "To stop: docker-compose down"
        ;;
    "test")
        check_prerequisites
        install_dependencies
        run_tests
        ;;
    "build")
        check_prerequisites
        build_docker
        ;;
    "clean")
        cleanup
        ;;
    "full")
        run_full_pipeline
        ;;
    "help"|"--help"|"-h")
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac