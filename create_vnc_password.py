#!/usr/bin/env python3
"""Create VNC password file"""
import os

def create_vnc_password(password, filepath="/root/.vnc/passwd"):
    """Create a VNC password file using XOR encryption"""
    # VNC uses a simple XOR with a fixed key
    key = bytes([0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA])
    encrypted = bytes([ord(c) ^ key[i % len(key)] for i, c in enumerate(password.ljust(8, '\0')[:8])])
    
    with open(filepath, 'wb') as f:
        f.write(encrypted)
    
    os.chmod(filepath, 0o600)
    print(f"VNC password file created at {filepath}")

if __name__ == '__main__':
    create_vnc_password('vncpass')