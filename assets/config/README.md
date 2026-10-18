# Private app configuration

Files in this directory are bundled as read-only assets at build time.

## `alpaca.json` (gitignored)

Alpaca API credentials for live heatmap quotes. Create it locally:

```sh
cp alpaca.example.json alpaca.json   # then fill in your real values
```

```json
{
  "key": "<your key id>",
  "secret": "<your secret>"
}
```

- **Never commit `alpaca.json`** — it is gitignored on purpose.
- Get keys at <https://alpaca.markets> (a free paper-trading account works).
- Without this file the app runs fine; live percents fall back to a
  one-shot non-live fetch.
