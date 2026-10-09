FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    DISPLAY=:1 \
    VNC_PASSWORD=vncpass \
    AI_LOG_FILE=/root/ailog.md \
    GIT_REMOTE=origin \
    GIT_BRANCH=main

# Install system packages, VNC server, desktop environment, Wine, and Python
RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get install -y --no-install-recommends \
    tigervnc-standalone-server tigervnc-common \
    xfce4 xfce4-goodies \
    x11vnc \
    wine wine64 wine32 \
    python3 python3-pip python3-venv \
    git \
    curl ca-certificates \
    supervisor \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Set up VNC directories and password
COPY create_vnc_password.py /opt/create_vnc_password.py
RUN chmod +x /opt/create_vnc_password.py && \
    mkdir -p /root/.vnc && \
    python3 /opt/create_vnc_password.py && \
    echo "set password-file=/root/.vnc/passwd" > /root/.vnc/config && \
    echo "set geometry=1920x1080" >> /root/.vnc/config && \
    echo "set depth=24" >> /root/.vnc/config && \
    echo "set alwaysshared" >> /root/.vnc/config

# Configure VNC startup script
COPY start-vnc.sh /start-vnc.sh
RUN chmod +x /start-vnc.sh

# Tally installer script
COPY install-tally.sh /opt/install-tally.sh
RUN chmod +x /opt/install-tally.sh

# AI Logger and Git Sync scripts
COPY ai_logger.py /opt/ai_logger.py
COPY ai_log.sh /usr/local/bin/ai_log
COPY git-sync.sh /usr/local/bin/git-sync
COPY git_sync.py /opt/git_sync.py
RUN chmod +x /opt/ai_logger.py /usr/local/bin/ai_log /usr/local/bin/git-sync /opt/git_sync.py

# Create health check script
RUN cat > /usr/local/bin/healthcheck.sh << 'EOF'
#!/bin/bash
# Health check script for VNC and Tally
set -e

# Check VNC server
if ! pgrep -f "X vnc" > /dev/null 2>&1; then
    echo "VNC server not running"
    exit 1
fi

# Check supervisor
if ! pgrep supervisord > /dev/null 2>&1; then
    echo "Supervisor not running"
    exit 1
fi

echo "OK"
exit 0
EOF
RUN chmod +x /usr/local/bin/healthcheck.sh

# Supervisor config to run VNC and desktop
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set up Python virtual environment and install requirements
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir --upgrade pip

COPY requirements.txt /requirements.txt
RUN /opt/venv/bin/pip install --no-cache-dir -r /requirements.txt

ENV PATH="/opt/venv/bin:$PATH"

# Create AI log file template
RUN cat > /root/ailog.md << 'EOF'
# AI Log

This file logs all prompts, responses, code snippets, and system events.
It is automatically synced with git for live updates.

EOF

# Create desktop shortcut for Tally Prime
RUN mkdir -p /usr/share/applications && \
    cat > /usr/share/applications/tallyprime.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Tally Prime
Comment=Tally Prime Accounting Software
Exec=wine /opt/TallyPrime/Tally.exe
Icon=tally
Terminal=false
Categories=Office;
EOF

# Create startup wrapper that ensures services stay alive
RUN cat > /usr/local/bin/startup.sh << 'EOF'
#!/bin/bash
# Startup wrapper to ensure services remain stable
set -e

echo "=== Tally Prime VNC Desktop - Startup ==="

# Start supervisor if not running
if ! pgrep supervisord > /dev/null 2>&1; then
    echo "Starting supervisord..."
    /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
fi

# Monitor loop - restart supervisor if it crashes
while true; do
    if ! pgrep supervisord > /dev/null 2>&1; then
        echo "[$(date)] WARNING: Supervisord stopped, restarting..."
        /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
    fi
    
    # Check VNC health
    if ! pgrep -f "X vnc" > /dev/null 2>&1; then
        echo "[$(date)] WARNING: VNC server not detected"
    fi
    
    sleep 30
done
EOF
RUN chmod +x /usr/local/bin/startup.sh

WORKDIR /root

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD /usr/local/bin/healthcheck.sh

CMD ["/usr/local/bin/startup.sh"]