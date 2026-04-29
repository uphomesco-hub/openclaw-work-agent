#!/usr/bin/env bash
set -euo pipefail

LABEL="${OPENCLAW_OPSBRAIN_URGENT_LABEL:-com.openclaw.opsbrain.urgent}"
TOOLS_DIR="${OPENCLAW_TOOLS_DIR:-$HOME/.openclaw/tools}"
STATE_DIR="${OPENCLAW_WORK_AGENT_DIR:-$HOME/.openclaw/work-agent}"
PLIST_DIR="$HOME/Library/LaunchAgents"
PLIST_PATH="$PLIST_DIR/$LABEL.plist"
LOG_DIR="$STATE_DIR/logs"

mkdir -p "$PLIST_DIR" "$LOG_DIR"

cat > "$PLIST_PATH" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$LABEL</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/zsh</string>
    <string>-lc</string>
    <string>$TOOLS_DIR/openclaw-work-agent run --scheduled urgent</string>
  </array>
  <key>StartInterval</key>
  <integer>120</integer>
  <key>RunAtLoad</key>
  <true/>
  <key>StandardOutPath</key>
  <string>$LOG_DIR/urgent-watch.out.log</string>
  <key>StandardErrorPath</key>
  <string>$LOG_DIR/urgent-watch.err.log</string>
</dict>
</plist>
EOF

launchctl bootout "gui/$(id -u)/$LABEL" >/dev/null 2>&1 || true
launchctl bootstrap "gui/$(id -u)" "$PLIST_PATH"
launchctl enable "gui/$(id -u)/$LABEL" >/dev/null 2>&1 || true
launchctl kickstart -k "gui/$(id -u)/$LABEL" >/dev/null 2>&1 || true

echo "Installed Ops Brain urgent LaunchAgent: $PLIST_PATH"
echo "Logs:"
echo "  $LOG_DIR/urgent-watch.out.log"
echo "  $LOG_DIR/urgent-watch.err.log"
