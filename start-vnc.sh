#!/bin/bash
# Start VNC server and Xfce desktop
# VNC Port: 5901 (display :1)

set -e

echo "=== Starting VNC Server ==="
echo "Display: :1"
echo "Port: 5901"
echo "Password: vncpass"
echo "Resolution: 1920x1080"
echo ""

# Kill any existing X server
pkill -f "X vnc" 2>/dev/null || true
pkill -f "Xorg" 2>/dev/null || true
sleep 1

# Clean lock files
rm -f /tmp/.X1-lock /tmp/.X0-lock 2>/dev/null || true

# Remove config file to avoid TLS settings from previous sessions
rm -f /root/.vnc/config

# Start TigerVNC server on display :1 (port 5901) with plain VNC auth only (no TLS)
# This avoids 502 errors when accessed through proxies
vncserver :1 -depth 24 -geometry 1920x1080 -localhost no -SecurityTypes VncAuth

# Wait for VNC to start
sleep 3

# Verify VNC is running
if pgrep -f "X vnc" > /dev/null; then
    echo "✓ VNC Server started successfully on port 5901"
    echo ""
    echo "Connect using VNC client:"
    echo "  Host: localhost:5901"
    echo "  Password: vncpass"
    echo "  Security: VNC Auth (no TLS)"
    echo ""
    echo "Desktop: Xfce"
    echo "Tally Prime: Run 'wine /opt/TallyPrime/Tally.exe'"
    echo "Python: /opt/venv/bin/python"
    echo "AI Logger: ai_log <type> <message>"
    echo "Git Sync: git-sync watch"
else
    echo "✗ Failed to start VNC server"
    exit 1
fi

# Keep container running
tail -f /var/log/vncserver@:1.log 2>/dev/null || sleep infinity