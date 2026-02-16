#!/bin/bash

# ProjectMaker Easy Setup Script for macOS
# This script automates the entire setup process for Mac users

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  ProjectMaker - Easy Setup (macOS)    ${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
echo -e "${YELLOW}Checking prerequisites...${NC}"

if ! command_exists python3; then
    echo -e "${RED}Error: Python 3 is not installed!${NC}"
    echo ""
    echo "Please install Python 3.8 or higher:"
    echo "  Option 1: Download from https://python.org"
    echo "  Option 2: Using Homebrew: brew install python"
    echo "  Option 3: Using pyenv: pyenv install 3.x.x"
    exit 1
fi

if ! command_exists node; then
    echo -e "${RED}Error: Node.js is not installed!${NC}"
    echo ""
    echo "Please install Node.js 18 or higher:"
    echo "  Option 1: Download from https://nodejs.org"
    echo "  Option 2: Using Homebrew: brew install node"
    echo "  Option 3: Using nvm: nvm install 18"
    exit 1
fi

if ! command_exists npm; then
    echo -e "${RED}Error: npm is not installed!${NC}"
    echo "It should come with Node.js. Please reinstall Node.js."
    exit 1
fi

echo -e "${GREEN}✓ All prerequisites found!${NC}"
echo ""

# Display versions
echo -e "${BLUE}Versions detected:${NC}"
python3 --version
node --version
npm --version
echo ""

# Change to project root
cd "$PROJECT_ROOT"
echo -e "${YELLOW}Working directory: $(pwd)${NC}"
echo ""

# Setup Backend
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Setting up Backend (Python/FastAPI)   ${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

cd backend

# Check if venv exists
if [ -d "venv" ]; then
    echo -e "${YELLOW}Virtual environment already exists. Using existing venv...${NC}"
else
    echo -e "${YELLOW}Creating virtual environment...${NC}"
    python3 -m venv venv
    echo -e "${GREEN}✓ Virtual environment created!${NC}"
fi

# Activate virtual environment
echo -e "${YELLOW}Activating virtual environment...${NC}"
source venv/bin/activate
echo -e "${GREEN}✓ Virtual environment activated!${NC}"

# Install requirements
echo -e "${YELLOW}Installing Python dependencies...${NC}"
pip install --upgrade pip
pip install -r requirements.txt
echo -e "${GREEN}✓ Dependencies installed!${NC}"
echo ""

# Start Backend in background
echo -e "${BLUE}Starting Backend Server...${NC}"
echo -e "${YELLOW}Backend will run on http://localhost:8000${NC}"
echo ""

# Create a log file for backend
mkdir -p logs
python -m uvicorn app.main:app --reload --port 8000 --log-level info > logs/backend.log 2>&1 &
BACKEND_PID=$!
echo $BACKEND_PID > .backend.pid

echo -e "${GREEN}✓ Backend server started (PID: $BACKEND_PID)${NC}"
echo -e "${YELLOW}Backend logs: backend/logs/backend.log${NC}"
echo ""

# Wait a moment for backend to start
sleep 3

# Check if backend is running
if kill -0 $BACKEND_PID 2>/dev/null; then
    echo -e "${GREEN}✓ Backend is running successfully!${NC}"
else
    echo -e "${RED}✗ Backend failed to start. Check logs/backend.log for errors.${NC}"
    exit 1
fi

# Setup Frontend
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Setting up Frontend (React/Vite)      ${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

cd "$PROJECT_ROOT/frontend"

# Check if node_modules exists
if [ -d "node_modules" ]; then
    echo -e "${YELLOW}node_modules already exists. Skipping npm install...${NC}"
else
    echo -e "${YELLOW}Installing npm dependencies...${NC}"
    npm install
    echo -e "${GREEN}✓ npm dependencies installed!${NC}"
fi

echo ""
echo -e "${BLUE}Starting Frontend Server...${NC}"
echo -e "${YELLOW}Frontend will run on http://localhost:5173${NC}"
echo ""

# Start Frontend in background
npm run dev > ../backend/logs/frontend.log 2>&1 &
FRONTEND_PID=$!
echo $FRONTEND_PID > ../backend/.frontend.pid

echo -e "${GREEN}✓ Frontend server started (PID: $FRONTEND_PID)${NC}"
echo -e "${YELLOW}Frontend logs: backend/logs/frontend.log${NC}"
echo ""

# Wait for frontend to start
sleep 5

# Check if frontend is running
if kill -0 $FRONTEND_PID 2>/dev/null; then
    echo -e "${GREEN}✓ Frontend is running successfully!${NC}"
else
    echo -e "${RED}✗ Frontend failed to start. Check backend/logs/frontend.log for errors.${NC}"
fi

# Display final message
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  🎉 ProjectMaker is Ready!            ${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}Access your application:${NC}"
echo -e "  🌐 Frontend UI:  ${GREEN}http://localhost:5173${NC}"
echo -e "  ⚙️  Backend API: ${GREEN}http://localhost:8000${NC}"
echo -e "  📚 API Docs:     ${GREEN}http://localhost:8000/docs${NC}"
echo ""
echo -e "${YELLOW}Logs:${NC}"
echo -e "  Backend:  tail -f backend/logs/backend.log"
echo -e "  Frontend: tail -f backend/logs/frontend.log"
echo ""
echo -e "${YELLOW}To stop the servers:${NC}"
echo -e "  Run: ./Easy-SetUp/stop-mac.sh"
echo -e "  Or manually: kill $(cat backend/.backend.pid) $(cat backend/.frontend.pid)"
echo ""
echo -e "${BLUE}Press Ctrl+C to stop viewing this message (servers will keep running)${NC}"
echo ""

# Keep script running to show logs
tail -f ../backend/logs/backend.log ../backend/logs/frontend.log 2>/dev/null || wait
