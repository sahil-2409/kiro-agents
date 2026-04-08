#!/bin/bash
set -e

AGENTS_DIR="$HOME/.kiro/agents"
HOOKS_DIR="$HOME/.kiro/hooks"
mkdir -p "$AGENTS_DIR" "$HOOKS_DIR"

echo "🔧 Kiro Agents Setup"
echo "===================="
echo ""

# Copy agents
cp agents/*.json "$AGENTS_DIR/"
echo "✅ Agent configs copied to $AGENTS_DIR/"

# Copy hooks
cp hooks/*.sh "$HOOKS_DIR/"
chmod +x "$HOOKS_DIR"/*.sh
echo "✅ Hook scripts copied to $HOOKS_DIR/"

# Skip Trello credentials if already set
if [ -n "$TRELLO_API_KEY" ] && [ -n "$TRELLO_TOKEN" ] && [ -n "$TRELLO_BOARD_ID" ]; then
  echo "✅ Trello credentials already configured — skipping"
else
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

  echo "" >> "$PROFILE"
  echo "# Kiro Trello Agent" >> "$PROFILE"
  echo "export TRELLO_API_KEY=\"$TRELLO_API_KEY\"" >> "$PROFILE"
  echo "export TRELLO_TOKEN=\"$TRELLO_TOKEN\"" >> "$PROFILE"
  echo "export TRELLO_BOARD_ID=\"$TRELLO_BOARD_ID\"" >> "$PROFILE"

  echo ""
  echo "✅ Credentials added to $PROFILE"
  echo "✅ Run 'source $PROFILE' or restart your terminal"
fi

echo ""
echo "Done! Restart Kiro CLI to pick up changes."
echo ""
echo "Available agents:"
echo "  @trello         — Create Trello stories"
echo "  @test-reporter  — Generate test reports"
