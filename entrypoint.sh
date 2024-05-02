#!/bin/bash

# Start Xvfb
Xvfb :99 -screen 0 1024x768x24 &

# Start Multilogin X launcher
mlx &

# Wait for a while so the launcher is properly installed
sleep 20

# Run Python automation script
cd /app/mlx-app && python3 main.py