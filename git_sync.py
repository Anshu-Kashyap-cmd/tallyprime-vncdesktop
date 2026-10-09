#!/usr/bin/env python3
"""
Git Sync Manager - Manages git push/pull operations
"""

import subprocess
import time
import os
import sys
from datetime import datetime

class GitSync:
    def __init__(self, repo_dir="/root", remote="origin", branch="main"):
        self.repo_dir = repo_dir
        self.remote = remote
        self.branch = branch
        os.chdir(repo_dir)
    
    def run_command(self, cmd):
        """Run a git command and return output"""
        try:
            result = subprocess.run(
                cmd, 
                shell=True, 
                capture_output=True, 
                text=True,
                cwd=self.repo_dir
            )
            return result.returncode, result.stdout, result.stderr
        except Exception as e:
            return 1, "", str(e)
    
    def pull(self):
        """Pull latest changes"""
        print(f"[{datetime.now()}] Pulling from {self.remote}/{self.branch}...")
        code, out, err = self.run_command(f"git pull {self.remote} {self.branch}")
        if code == 0:
            print("Pull successful")
            return True
        else:
            print(f"Pull skipped: {err[:100]}")
            return False
    
    def push(self):
        """Push local changes"""
        print(f"[{datetime.now()}] Pushing to {self.remote}/{self.branch}...")
        
        # Add all changes
        self.run_command("git add -A")
        
        # Commit
        commit_msg = f"Auto-sync: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}"
        code, out, err = self.run_command(f'git commit -m "{commit_msg}"')
        
        # Push
        code, out, err = self.run_command(f"git push {self.remote} {self.branch}")
        if code == 0:
            print("Push successful")
            return True
        else:
            print(f"Push skipped: {err[:100]}")
            return False
    
    def sync(self):
        """Perform both pull and push"""
        self.pull()
        self.push()
    
    def watch(self, interval=30):
        """Watch for changes and sync periodically"""
        print(f"Starting git sync watch (every {interval}s)...")
        try:
            while True:
                self.sync()
                time.sleep(interval)
        except KeyboardInterrupt:
            print("Git sync stopped")

if __name__ == '__main__':
    sync = GitSync()
    if len(sys.argv) > 1 and sys.argv[1] == 'watch':
        interval = int(sys.argv[2]) if len(sys.argv) > 2 else 30
        sync.watch(interval)
    else:
        sync.sync()