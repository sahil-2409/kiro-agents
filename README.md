# Kiro Agents

Drop-in AI agents for Kiro CLI. Clone, run setup, start using.

## Available Agents

| Agent | Command | Description |
|-------|---------|-------------|
| Trello | `@trello` | Creates refined user stories on Trello with labels and acceptance criteria |

## Quick Setup

```bash
git clone https://github.com/sahil-2409/kiro-agents.git
cd kiro-agents
chmod +x setup.sh
./setup.sh
```

The setup script will:
1. Copy agent configs to `~/.kiro/agents/`
2. Ask for your Trello credentials
3. Save them to your shell profile

## Trello Agent Setup (Manual)

If you prefer manual setup:

1. Copy `agents/trello_agent.json` to `~/.kiro/agents/`
2. Get your Trello API key from https://trello.com/app-key
3. Click "Token" on that page to generate a token
4. Get your board ID from the board URL (e.g., `https://trello.com/b/R8qWln5B/...` → `R8qWln5B`)
5. Add to your shell profile (`~/.zshrc` or `~/.bashrc`):

```bash
export TRELLO_API_KEY="your_key"
export TRELLO_TOKEN="your_token"
export TRELLO_BOARD_ID="your_board_id"
```

## Usage

In Kiro CLI:

```
@trello create a user story for adding password reset functionality
@trello add a story for filtering users by geography in the backend
@trello create a BDD story for the team generation flow
```

The agent will:
1. Ask 2-3 clarifying questions (list, labels, ETA)
2. Generate a refined story with acceptance criteria
3. Show you the card for approval
4. Create it on Trello after you confirm

## Adding More Agents

Drop any `.json` agent config into the `agents/` folder and re-run `./setup.sh`.
