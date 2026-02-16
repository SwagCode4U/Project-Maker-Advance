#!/bin/bash

# ProjectMaker Stop Script for macOS
# This script stops all running ProjectMaker servers

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo -e "${BLUE}Stopping ProjectMaker servers...${NC}"
echo ""

# Stop Backend
cd "$PROJECT_ROOT/backend"
if [ -f ".backend.pid" ]; then
    BACKEND_PID=$(cat .backend.pid)
    if kill -0 $BACKEND_PID 2>/dev/null; then
        kill $BACKEND_PID
        echo -e "${GREEN}✓ Backend server stopped${NC}"
    else
        echo -e "${YELLOW}Backend server was not running${NC}"
    fi
    rm -f .backend.pid
else
    # Try to find and kill by port
    BACKEND_PID=$(lsof -ti:8000 2>/dev/null)
    if [ ! -z "$BACKEND_PID" ]; then
        kill $BACKEND_PID 2>/dev/null
        echo -e "${GREEN}✓ Backend server stopped (found on port 8000)${NC}"
    else
        echo -e "${YELLOW}Backend server not found${NC}"
    fi
fi

# Stop Frontend
cd "$PROJECT_ROOT/backend"
if [ -f ".frontend.pid" ]; then
    FRONTEND_PID=$(cat .frontend.pid)
    if kill -0 $FRONTEND_PID 2>/dev/null; then
        kill $FRONTEND_PID
        echo -e "${GREEN}✓ Frontend server stopped${NC}"
    else
        echo -e "${YELLOW}Frontend server was not running${NC}"
    fi
    rm -f .frontend.pid
else
    # Try to find and kill by port
    FRONTEND_PID=$(lsof -ti:5173 2>/dev/null)
    if [ ! -z "$FRONTEND_PID" ]; then
        kill $FRONTEND_PID 2>/dev/null
        echo -e "${GREEN}✓ Frontend server stopped (found on port 5173)${NC}"
    else
        echo -e "${YELLOW}Frontend server not found${NC}"
    fi
fi

echo ""
echo -e "${GREEN}All ProjectMaker servers have been stopped!${NC}"
