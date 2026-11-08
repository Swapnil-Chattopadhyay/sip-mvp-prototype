# Continuity — Zerodha Coin SIP MVP Prototype

> **NEXTLEAP Assignment · Case Study: Zerodha Coin SIP Continuation**

A fully functional, single-file MVP prototype that demonstrates the **Continuity** feature concept for Zerodha Coin — an intelligent system that prevents SIP lapse by proactively alerting investors, showing impact, and providing a grounded, eval-gated AI assistant.

---

## Live Demo

The canonical artifact is hosted at:
**https://claude.ai/artifact/7qTFjWor4tbS6JPJJmSQya**

This repository is the deployable mirror of that exact artifact (version `1794137102-c936`), suitable for local review, offline use, and GitHub Pages hosting.

---

## What's Inside

The entire prototype lives in **one self-contained HTML file**: `index.html` (≈77 KB, no build step, no dependencies, no CDN calls).

### Four Tabs

| Tab | What it shows |
|-----|---------------|
| **SIPs** | Live 12-month instalment timeline with Continuity toggle — shows penalty accrual vs. smooth continuation |
| **Alerts** | Proactive alert log with sent/unsent comparison and severity chips |
| **Impact** | OKR / Key Results dashboard — L0 score, four KRs, with-vs-without penalty table |
| **Ask** | Eval-gated AI assistant (see below) |

### Ask Feature (Eval-Gated AI)

The "Ask" tab is the assignment's core technical requirement:

- Grounded answers cite internal evidence codes (`TQ-07`, `AS-03`, `R-11`, …)
- Advice-seeking questions are **refused** (`isAdviceSeeking()` regex gate)
- A **golden-set evaluation** runs against 10 canonical Q&A pairs before the feature unlocks
- Scores < 70% keep the feature locked; ≥ 70% unlocks it
- All Q&A interactions are logged to `qa_log` (persisted via Claude Artifacts `db` capability when available, `localStorage` otherwise)

### Light / Dark Mode + Settings

- Moon/sun toggle in the topbar switches themes instantly (CSS custom-property token system)
- Gear icon opens a **Settings panel** — stores display name, email, theme preference, and notification opt-in
- Settings persist to `user_settings` collection (db capability) with `localStorage` fallback

### Typography

- Body and headings: **Times New Roman** (falling back to Georgia / serif)
- UI chrome (topbar, chips, buttons): system sans-serif
- Key headers at `font-weight: 600–700`

---

## Running Locally

### Option A — One command (Python, zero install)

```bash
# Clone
git clone https://github.com/YOUR_USERNAME/nextleap-continuity.git
cd nextleap-continuity

# Serve on port 8080
python3 -m http.server 8080
```

Then open **http://localhost:8080** in your browser.

### Option B — Node.js (npx, zero install)

```bash
npx serve . -p 8080
```

### Option C — VS Code Live Server

Open the folder in VS Code → right-click `index.html` → **Open with Live Server**.

> **Why a server and not just `file://`?**
> The Claude Artifacts `db` and `user` capabilities use `postMessage` APIs that require an HTTP origin. Everything else works from `file://` too, but settings persistence won't sync.

---

## Deployment

### GitHub Pages (recommended — free, permanent URL)

```bash
# From your fork/clone:
git checkout -b gh-pages
git push origin gh-pages
```

Then go to **Settings → Pages → Source** and select the `gh-pages` branch, root `/`.  
Your URL will be: `https://YOUR_USERNAME.github.io/nextleap-continuity/`

### Netlify Drop

Drag the entire folder (or just `index.html`) onto **https://app.netlify.com/drop**.

### Vercel

```bash
npx vercel --prod
```

---

## File Structure

```
nextleap-continuity/
├── index.html          ← The entire prototype (single file, self-contained)
├── README.md           ← This file
├── docs/
│   ├── ARCHITECTURE.md ← System design & evidence map
│   ├── EVAL_GATE.md    ← Ask feature eval-gate specification
│   └── WIREFRAMES.md   ← Pitch deck wireframe reference
└── scripts/
    └── verify.sh       ← Local integrity check (hash vs. artifact)
```

---

## No Changes on Deployment

The `index.html` is an **exact export** of artifact version `1794137102-c936`.  
The `scripts/verify.sh` script prints the SHA-256 of your local file so you can confirm it matches what you reviewed:

```bash
bash scripts/verify.sh
```

Expected SHA-256: printed on first run; store it in `docs/CHECKSUMS.txt` after your review.

---

## Technical Notes

- **Zero dependencies** — no React, no npm, no Webpack. Pure HTML/CSS/JS.
- **Claude Artifacts capabilities** — `db` (Firestore-like per-viewer storage) and `user` (stable viewer ID) are used when the page is served from `claude.ai`. On any other host they fall back gracefully to `localStorage`.
- **CSP-safe** — no `eval()`, no inline event handlers, no external fetch calls.
- **Mobile-ready** — viewport meta set, topbar scrolls horizontally on narrow screens.

---

## Assignment Context

**Course:** NEXTLEAP  
**Case:** Zerodha Coin — SIP lapse prevention  
**Feature name:** Continuity  
**Prototype type:** High-fidelity single-file MVP (Zerodha Kite/Coin design system)  
**Wireframes:** https://claude.ai/artifact/FyzseAQxw9ArFhTKLRWDo7

---

*Built with Claude · Artifact version `1794137102-c936` · November 2026*
