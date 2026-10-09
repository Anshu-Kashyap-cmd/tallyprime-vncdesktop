#!/bin/bash
# Setup script for git and AI logging
# Run this inside the container to configure git

set -e

echo "=== Git & AI Logger Setup ==="

# Configure git identity if not set
if ! git config user.name > /dev/null 2>&1; then
    read -p "Enter your name: " GIT_USER_NAME
    git config --global user.name "$GIT_USER_NAME"
fi

if ! git config user.email > /dev/null 2>&1; then
    read -p "Enter your email: " GIT_USER_EMAIL
    git config --global user.email "$GIT_USER_EMAIL"
fi

# Configure git remote if not set
if ! git remote get-url origin > /dev/null 2>&1; then
    read -p "Enter git remote URL (or press skip): " GIT_REMOTE_URL
    if [ -n "$GIT_REMOTE_URL" ]; then
        git remote add origin "$GIT_REMOTE_URL"
        echo "Remote added: $GIT_REMOTE_URL"
    fi
fi

# Initialize AI log file if not exists
if [ ! -f /root/ailog.md ]; then
    cat > /root/ailog.md << 'EOF'
# AI Log

This file logs all prompts, responses, code snippets, and system events.
It is automatically synced with git for live updates.

EOF
    echo "AI log file created"
fi

# Test AI logger
echo "Testing AI logger..."
ai_log system "Git and AI Logger setup completed successfully"

echo ""
echo "=== Setup Complete ==="
echo "Git configured:"
git config user.name
git config user.email
echo ""
echo "AI Logger ready. Use: ai_log <type> <message>"
echo "Types: prompt, response, code, system"