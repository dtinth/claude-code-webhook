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
echo '{
  "webhook_url": "https://your-webhook-endpoint.com/events",
  "enabled": true,
  "timeout": 60
}' > ~/.claude-webhook/config.json
```

### Configuration Options

- `webhook_url` (required): The endpoint to send webhook events to
- `enabled` (optional): Set to `false` to disable webhook sending (default: `true`)
- `timeout` (optional): Timeout for curl requests in seconds (default: `60`)
