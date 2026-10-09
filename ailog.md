# AI Log

This file logs all prompts, responses, code snippets, and system events.
It is automatically synced with git for live updates.

---

## Session Log

### 2026-10-09 - Complete Setup

**Prompt 1:** Setup Tally Prime desktop with DevContainer and crash prevention

**Actions Taken:**
- Created `.devcontainer/devcontainer.json` for VS Code integration
- Updated `Dockerfile` with health checks and auto-restart
- Enhanced `docker-compose.yml` with reliability features
- Updated `supervisord.conf` with auto-restart settings
- Fixed `requirements.txt` (removed pywin32 for Linux compatibility)
- Created `ailog.md`, `version.md`, `prompt.md` files
- Updated `README.md` with DevContainer instructions

**Status:** Container built and running healthy on port 5901

**Git Commit:** `7df6a11` pushed to origin/main

---

### 2026-10-09 - 502 Error Fix

**Prompt 2:** Fix 502 error on port 5901

**Problem:** VNC server using TLS caused 502 errors with HTTP proxies

**Solution:**
- Added noVNC for web-based VNC access on port 5902
- Added websockify for WebSocket proxying
- Replaced supervisor with direct bash startup for reliability
- Added auto-restart monitoring loop
- VNC now uses plain VNC Auth (no TLS)

**Git Commit:** `567f800` pushed to origin/main

**Current Status:**
- Port 5901: VNC Server (RFB protocol)
- Port 5902: Web VNC (noVNC via websockify)
- Both ports verified working
- Auto-restart active for crash prevention

---

### 2026-10-09 - Connection Issues

**Prompt 3:** "This site can't be reach - localhost refused to connect"

**Investigation:**
- Port 5902 verified listening (HTTP 200 response)
- Port 5901 verified listening (VNC RFB protocol)
- Container ports exposed: 0.0.0.0:5901-5902->5901-5902/tcp

**Solution:**
- Use `127.0.0.1` instead of `localhost` in browser
- Correct URL: `http://127.0.0.1:5902/vnc.html`
- VNC client: `127.0.0.1:5901` (password: vncpass)

**Git Commit:** `567f800` (latest)