#!/bin/bash

# Install requirements if not already installed
if [ ! -f "requirements.txt" ]; then
    echo "Error: requirements.txt file not found"
    exit 1
fi

pip install -r requirements.txt

# Run Robot Framework tests and store reports in results directory
mkdir -p results
robot --outputdir results tests
