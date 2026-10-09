#!/usr/bin/env python3
"""
AI Logger - Logs prompts and responses to ailog.md
Usage: python3 ai_logger.py <type> <message>
Types: prompt, response, code, system
"""

import sys
import os
from datetime import datetime

def log_entry(entry_type, message):
    """Append a log entry to ailog.md"""
    log_file = os.environ.get('AI_LOG_FILE', '/root/ailog.md')
    
    # Ensure directory exists
    os.makedirs(os.path.dirname(log_file), exist_ok=True)
    
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    # Type icons
    icons = {
        'prompt': 'USER',
        'response': 'AI',
        'code': 'CODE',
        'system': 'SYS'
    }
    
    icon = icons.get(entry_type, 'INFO')
    
    # Format entry
    entry = f"\n### [{timestamp}] {icon}\n\n{message}\n"
    
    # Append to log file
    with open(log_file, 'a', encoding='utf-8') as f:
        f.write(entry)
    
    print(f"Logged to {log_file}")
    return True

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print("Usage: python3 ai_logger.py <type> <message>")
        sys.exit(1)
    
    log_type = sys.argv[1]
    message = ' '.join(sys.argv[2:])
    log_entry(log_type, message)