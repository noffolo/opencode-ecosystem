#!/bin/bash
echo "Starting Open Notebook Backend..."
docker compose up -d
echo "Open Notebook is now running at http://localhost:8502 (Frontend) and http://localhost:5055 (API)."
