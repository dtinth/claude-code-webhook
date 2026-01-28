# Claude Code Webhook Plugin

A lightweight, asynchronous webhook plugin for Claude Code that sends all Claude Code events to a configured webhook endpoint. This plugin is just [a small Bash script](scripts/send-webhook.sh) (less than 80 lines) so you can easily audit it.

## Setting up

**Required dependencies:** A unix-based operating system, `jq`, `bash`, and `curl`.

**Install the plugin:**

```sh
claude plugin marketplace add dtinth/claude-code-webhook
claude plugin install claude-webhook
```

**Configure the plugin** at `~/.claude-webhook/config.json`:

```sh
mkdir -p ~/.claude-webhook
cp config.example.json ~/.claude-webhook/config.json
```

### Configuration Options

- `webhook_url` (required): The endpoint to send webhook events to
- `enabled` (optional): Set to `false` to disable webhook sending (default: `true`)
- `timeout` (optional): Timeout for curl requests in seconds (default: `60`)

## Example Request Body

```json
{
  "session_id": "a03a48b2-f8e2-438d-bec5-c934a4cf53e0",
  "transcript_path": "/config/.claude/projects/-config-scribeditor/a03a48b2-f8e2-438d-bec5-c934a4cf53e0.jsonl",
  "cwd": "/config/scribeditor",
  "hook_event_name": "Notification",
  "message": "Claude is waiting for your input",
  "notification_type": "idle_prompt"
}
```
