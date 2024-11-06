#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  echo "Stopping PostgreSQL on macOS..."
  brew services stop postgresql@14
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # Ubuntu Linux
  echo "Stopping PostgreSQL on Ubuntu..."
  sudo systemctl stop postgresql
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
  # Windows
  echo "Stopping PostgreSQL on Windows..."
  net stop postgresql-x64-14
else
  echo "Unsupported operating system."
fi
