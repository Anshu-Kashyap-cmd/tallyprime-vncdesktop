# Tally Prime VNC Desktop

Docker-based setup with VNC Desktop, Tally Prime (via Wine), and Python environment.
Now with DevContainer support for seamless VS Code integration.

## Features

- **Open Source VNC Server**: TigerVNC (open source)
- **Desktop Environment**: Xfce
- **Tally Prime**: Runs via Wine compatibility layer
- **Python**: Python 3 with virtual environment and required packages
- **DevContainer**: VS Code Remote - Containers support
- **Auto-restart**: Services auto-restart on failure
- **Health Monitoring**: Built-in health checks

## Quick Start

### Option 1: Using DevContainer (VS Code)

1. Open this folder in VS Code
2. Press `Ctrl+Shift+P` → "Remote-Containers: Reopen in Container"
3. Container will build automatically
4. VNC server starts on port 5901

### Option 2: Using Docker Compose

1. Build and start the container:

```bash
docker-compose up -d --build
```

2. Connect using a VNC client:
   - Host: `localhost`
   - Port: `5901`
   - Password: `vncpass`

## Install Tally Prime

After starting the container, install Tally Prime using one of these methods:

**Option 1: Use the install script with a download URL**

```bash
TALLY_URL="https://example.com/tally.tar.gz" docker exec tallyprime-vnc-desktop /opt/install-tally.sh
```

**Option 2: Mount installer file**

```bash
docker run -v /path/to/tally.tar.gz:/opt/tally-installer.tar.gz ...
```

**Option 3: Copy files directly into the container**

```bash
docker cp tally.exe tallyprime-vnc-desktop:/opt/TallyPrime/
```

## Usage

- **Tally Prime**: Desktop shortcut "Tally Prime" or run `wine /opt/TallyPrime/Tally.exe`
- **Python**: Use `/opt/venv/bin/python` or activate the virtual environment:
  ```bash
  docker exec -it tallyprime-vnc-desktop /opt/venv/bin/python
  ```

## Configuration

- **VNC Password**: Change `VNC_PASSWORD` in `docker-compose.yml` or `Dockerfile`
- **Display Resolution**: Edit `start-vnc.sh` (currently 1920x1080)
- **Python Packages**: Update `requirements.txt`

## Reliability Features

- **Auto-restart**: Services automatically restart if they crash
- **Health Checks**: Container health is monitored
- **Persistent Data**: Docker volume `tally-data` preserves your files
- **Supervisor**: Manages VNC and git-sync processes

## Notes

- Container runs in privileged mode for Wine compatibility
- Data persists in Docker volume `tally-data`
- Default VNC password is `vncpass` (change in production)
- DevContainer setup includes VS Code Python extensions