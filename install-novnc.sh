#!/bin/bash
# Install noVNC for web-based VNC access
# This allows accessing VNC through a web browser (fixes 502 errors from HTTP proxies)

set -e

echo "=== Installing noVNC for Web Access ==="

# Install websockify for WebSocket support
apt-get update -qq
apt-get install -y -qq websockify novnc

# Create noVNC directory
mkdir -p /usr/share/novnc

# Download noVNC if not available via package
if [ ! -f /usr/share/novnc/vnc.html ]; then
    echo "Downloading noVNC..."
    cd /tmp
    curl -L -o novnc.tar.gz https://github.com/novnc/noVNC/archive/v1.4.0.tar.gz
    tar -xzf novnc.tar.gz
    cp -r noVNC-1.4.0/* /usr/share/novnc/
    rm -rf novnc.tar.gz noVNC-1.4.0
fi

# Configure websockify to connect to VNC
cat > /etc/websockify.conf << 'EOF'
# Websockify configuration for noVNC
:5902=127.0.0.1:5901
EOF

# Create systemd service or supervisor config
cat > /etc/supervisor/conf.d/websockify.conf << 'EOF'
[program:websockify]
command=/usr/bin/websockify --web=/usr/share/novnc 0.0.0.0:5902 127.0.0.1:5901
autostart=true
autorestart=true
stdout_logfile=/var/log/websockify_stdout.log
stderr_logfile=/var/log/websockify_stderr.log
priority=3
EOF

echo "✓ noVNC installed"
echo ""
echo "Web VNC Access:"
echo "  http://localhost:5902/vnc.html"
echo "  Host: localhost"
echo "  Port: 5901"
echo "  Password: vncpass"