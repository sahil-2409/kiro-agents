# Kiro Agents

Drop-in AI agents for Kiro CLI. Clone, run setup, start using.

## Available Agents

| Agent | Command | Description |
|-------|---------|-------------|
| Trello | `@trello` | Creates refined user stories on Trello with labels and acceptance criteria |
| Test Reporter | `@test-reporter` | Generates structured test reports after test runs, saves to reports/ folder |

## Quick Setup

```bash
git clone https://github.com/sahil-2409/kiro-agents.git
cd kiro-agents
chmod +x setup.sh
./setup.sh
```

The setup script will:
1. Copy agent configs to `~/.kiro/agents/`
2. Copy hook scripts to `~/.kiro/hooks/`
3. Ask for your Trello credentials (if not already set)

## Test Reporter Agent

Automatically detects test runs and generates structured markdown reports.

### How it works

1. A `postToolUse` hook watches for `execute_bash` commands
2. When a test command is detected (cypress, jest, gradle test, pytest, etc.), the hook captures the output
3. The agent generates a structured report and saves it to `reports/`

### Usage

In Kiro CLI:

```
@test-reporter run the cypress e2e tests and generate a report
@test-reporter run gradle test and create a report
```

### Supported test frameworks

Jest, Cypress, Vitest, Pytest, Mocha, Gradle test, and any command containing "test" in it.

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

## Project Structure

```
kiro-agents/
├── agents/
│   ├── trello_agent.json
│   └── test_reporter_agent.json
├── hooks/
│   └── detect-test-run.sh
├── setup.sh
└── README.md
```
