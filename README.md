# SlopTotal Extension

[![CI](https://github.com/pablocaeg/sloptotal-extension/actions/workflows/ci.yml/badge.svg)](https://github.com/pablocaeg/sloptotal-extension/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Chrome extension that detects AI-generated content in **Google Search results** and **LinkedIn feeds** using [SlopTotal](https://github.com/pablocaeg/sloptotal)'s 23 detection engines.

## Features

- **Google Search badges** — AI probability badges injected inline on every search result with expandable detail panels
- **LinkedIn feed scanning** — Detects AI-generated posts in your LinkedIn feed
- **Quick-score popup** — Analyse any page or selected text with one click
- **Context menu** — Right-click any selected text to check it instantly
- **Configurable API** — Point at any SlopTotal backend (self-hosted or public)
- **Zero dependencies** — Pure vanilla JavaScript, no build step

## Installation

### Manual Install (Developer Mode)

1. Download or clone this repository
2. Open Chrome and go to `chrome://extensions`
3. Enable **Developer mode** (top right)
4. Click **Load unpacked** and select the `src/` folder
5. The SlopTotal icon appears in your toolbar

### Chrome Web Store

Coming soon.

## Configuration

Click the SlopTotal extension icon to open settings:

| Setting | Default | Description |
|---------|---------|-------------|
| API URL | `http://localhost:8000` | Your SlopTotal backend address |
| Google scanning | On | Show AI badges on Google search results |
| LinkedIn scanning | On | Show AI badges on LinkedIn feed posts |
| Hide sponsored | On | Collapse sponsored LinkedIn posts |
| Auto-analyze | On | Automatically analyse every page |

### Connecting to a Backend

The extension needs a running SlopTotal backend to work. Options:

1. **Self-host** — Run your own backend: see [SlopTotal](https://github.com/pablocaeg/sloptotal)
2. **Public API** — Set API URL to `https://api.sloptotal.com`

## How It Works

```
Google/LinkedIn page loads
    │
    ▼
Content script extracts text snippets from search results / posts
    │
    ▼
Background service worker batches snippets (max 5 per request)
    │
    ▼
POST /api/scan/snippets → SlopTotal backend (Fakespot engine)
    │
    ▼
Results cached (LRU, 500 entries, 1hr TTL)
    │
    ▼
Badges injected into the page with AI probability scores
    │
    ▼
Click badge → detail panel with score breakdown
```

## API Endpoints Used

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/scan/snippets` | POST | Batch snippet analysis |
| `/api/scan/urls` | POST | Deep URL content analysis |
| `/api/quick-score` | POST | Single text quick score |
| `/api/paragraph-score` | POST | Multi-paragraph analysis |
| `/api/web/analyze` | POST | Full 23-engine analysis |
| `/api/stream/{id}` | GET (SSE) | Live streaming results |
| `/health` | GET | Server health check |

## Extension Permissions

| Permission | Why |
|-----------|-----|
| `activeTab` | Read the current page for analysis |
| `storage` | Store settings and connection status |
| `contextMenus` | "Check with SlopTotal" right-click menu |
| `notifications` | Show analysis result notifications |
| `scripting` | Get selected text for popup analysis |
| `https://*/*` | Content scripts run on Google, LinkedIn, and all sites (for the panel feature) |

## Project Structure

```
src/
  manifest.json          # Chrome extension manifest (V3)
  background.js          # Service worker: caching, batching, SSE relay
  content/
    google.js             # Google SERP badge injection
    google.css
    linkedin.js           # LinkedIn feed badge injection
    linkedin.css
    panel.js              # Full-page analysis panel (any site)
    panel.css
    overlay.js            # Context menu result overlay
  popup/
    popup.html            # Extension popup UI
    popup.js              # Settings and quick analysis
    popup.css
  icons/
    icon16.png, icon48.png, icon128.png
scripts/
  package.sh              # Create .zip for Chrome Web Store
```

## Contributing

Contributions welcome! This extension is pure vanilla JavaScript with zero build dependencies.

1. Fork the repo
2. Make changes in `src/`
3. Load the extension in Developer mode to test
4. Submit a PR

### Important Rules

- Do NOT add npm dependencies — keep it zero-dependency
- Do NOT add a build system (webpack, rollup, etc.)
- Do NOT change the API contract — the extension must work with any compatible SlopTotal backend
- Do NOT remove localhost as the default API URL — self-hosting is a core feature

## Related

- [SlopTotal](https://github.com/pablocaeg/sloptotal) — The backend with 23 AI detection engines

## License

MIT
