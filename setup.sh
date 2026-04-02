#!/bin/bash
set -e

AGENTS_DIR="$HOME/.kiro/agents"
mkdir -p "$AGENTS_DIR"

echo "🔧 Kiro Agents Setup"
echo "===================="
echo ""

# Copy agents
cp agents/*.json "$AGENTS_DIR/"
echo "✅ Agent configs copied to $AGENTS_DIR/"

# Skip credentials if already set
if [ -n "$TRELLO_API_KEY" ] && [ -n "$TRELLO_TOKEN" ] && [ -n "$TRELLO_BOARD_ID" ]; then
  echo "✅ Trello credentials already configured — skipping"
  echo ""
  echo "Done! Restart Kiro CLI to pick up changes."
  exit 0
fi

# Collect Trello credentials
echo ""
echo "📋 Trello Setup (get keys from https://trello.com/app-key)"
read -p "TRELLO_API_KEY: " TRELLO_API_KEY
read -p "TRELLO_TOKEN: " TRELLO_TOKEN
read -p "TRELLO_BOARD_ID (from board URL, e.g. R8qWln5B): " TRELLO_BOARD_ID

# Detect shell profile
if [ -f "$HOME/.zshrc" ]; then
  PROFILE="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
  PROFILE="$HOME/.bashrc"
else
  PROFILE="$HOME/.profile"
fi

# Append env vars
echo "" >> "$PROFILE"
echo "# Kiro Trello Agent" >> "$PROFILE"
echo "export TRELLO_API_KEY=\"$TRELLO_API_KEY\"" >> "$PROFILE"
echo "export TRELLO_TOKEN=\"$TRELLO_TOKEN\"" >> "$PROFILE"
echo "export TRELLO_BOARD_ID=\"$TRELLO_BOARD_ID\"" >> "$PROFILE"

echo ""
echo "✅ Credentials added to $PROFILE"
echo "✅ Run 'source $PROFILE' or restart your terminal"
echo ""
echo "Usage: In Kiro CLI, type @trello followed by your request"
