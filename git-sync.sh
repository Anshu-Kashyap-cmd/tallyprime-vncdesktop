#!/bin/bash
# Git Sync Script - Auto-push and pull for live updates
# Usage: ./git-sync.sh [push|pull|both]
# Runs in background to keep repo in sync

REPO_DIR="${REPO_DIR:-/root}"
GIT_REMOTE="${GIT_REMOTE:-origin}"
GIT_BRANCH="${GIT_BRANCH:-main}"

cd "$REPO_DIR" || exit 1

ACTION="${1:-both}"

sync_pull() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Pulling latest changes from $GIT_BRANCH..."
    git fetch "$GIT_REMOTE" 2>/dev/null
    git pull "$GIT_REMOTE" "$GIT_BRANCH" 2>/dev/null && echo "Pull successful" || echo "Pull skipped (no remote or conflicts)"
}

sync_push() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Pushing changes to $GIT_BRANCH..."
    git add -A 2>/dev/null
    git commit -m "Auto-sync: $(date '+%Y-%m-%d %H:%M:%S')" 2>/dev/null
    git push "$GIT_REMOTE" "$GIT_BRANCH" 2>/dev/null && echo "Push successful" || echo "Push skipped (no remote or no changes)"
}

case "$ACTION" in
    pull)
        sync_pull
        ;;
    push)
        sync_push
        ;;
    both)
        sync_pull
        sync_push
        ;;
    watch)
        # Watch mode: run every 30 seconds
        echo "Starting git sync watch (every 30s)..."
        while true; do
            sync_pull
            sync_push
            sleep 30
        done
        ;;
    *)
        echo "Usage: $0 [push|pull|both|watch]"
        exit 1
        ;;
esac