# Claude Code Webhook Plugin

A lightweight, asynchronous webhook plugin that sends all Claude Code events to a configured webhook endpoint. Requires `jq`.

## Configuration

Create `~/.claude-webhook/config.json`:

```json
{
  "webhook_url": "https://your-webhook-endpoint.com/events",
  "enabled": true,
  "timeout": 60
}
```

### Configuration Options

- `webhook_url` (required): The endpoint to send webhook events to
- `enabled` (optional): Set to `false` to disable webhook sending (default: `true`)
- `timeout` (optional): Timeout for curl requests in seconds (default: `60`)
