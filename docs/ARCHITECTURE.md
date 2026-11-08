# Architecture — Continuity MVP

## Overview

The prototype is a **single-file HTML/CSS/JS application** with no build step and no external dependencies. All logic, styles, and markup are inlined into `index.html`.

## Component Map

```
index.html
├── <style>              CSS custom-property token system (light + dark themes)
├── <body>
│   ├── .disclaimer-ribbon   Legal disclaimer banner
│   ├── .topbar-container
│   │   ├── .indices-container   L0/Risk ticker
│   │   ├── .menu-container
│   │   │   ├── .logo-mark
│   │   │   ├── <ul#navList>     Tab nav (SIPs / Alerts / Impact / Ask)
│   │   │   ├── #themeToggleBtn  Light/dark moon-sun toggle
│   │   │   ├── #settingsBtn     Gear icon → settings modal
│   │   │   └── .profile         Avatar + username
│   │   └── #settingsOverlay     Settings modal (name, email, theme, notify)
│   ├── .control-bar             Continuity toggle + month stepper
│   └── .dashboard-container
│       ├── .watchlist-container  12-month instalment sidebar
│       └── #content              Dynamic render target (tab views)
└── <script>             All application logic
```

## Data Model

### `EVIDENCE` Map
13 evidence entries keyed by code (e.g. `TQ-07`, `AS-03`, `R-11`):

```js
{ code, category, claim, source, detail }
```

Categories: `transaction_quality`, `alert_signal`, `regulatory`, `impact`, `segment`.

### `buildTimeline(continuityOn)` → 12 instalment objects
```js
{ month, label, status, amount, penalty, settled, notes }
```

- `continuityOn=true`: all 12 settled, 0 penalty
- `continuityOn=false`: 3 settled, ₹1,050 total penalty, 9 pending/failed

### `computeKRs(timeline)` → 4 Key Results
```js
{ id, label, target, actual, unit, hit }
```

KRs: completion-rate, penalty-avoided, alert-precision, investor-retention.

## Ask Feature — Evidence-Grounded Q&A

```
User question
    │
    ▼
isAdviceSeeking(q)  ──yes──► REFUSAL_TEXT (hard block)
    │ no
    ▼
buildAskPrompt(q, evidencePack)   ← loads from db or FALLBACK_EVIDENCE_PACK
    │
    ▼
Claude API  (window.claude.use('llm') or fallback text)
    │
    ▼
applyQualityGate(response, goldenSet)  ← compares against FALLBACK_GOLDEN_SET
    │
    ├── score < 0.70  → locked UI, re-run prompt
    └── score ≥ 0.70  → unlocked, response shown, logged to qa_log
```

## Theme System

All colors are CSS custom properties on `:root` (light) and `html[data-theme="dark"]`.
Switching theme = one `setAttribute` call on `<html>`. Zero per-component JS branching.

```
:root { --bg:#fff; --ink:#474747; --orange:#ff5722; … }
html[data-theme="dark"] { --bg:#17140f; --ink:#e9e6e1; … }
```

## Persistence

| Data | Primary | Fallback |
|------|---------|----------|
| Settings | `claudeDb.user_settings/{userId}` | `localStorage['continuity_settings']` |
| Theme | `claudeDb.user_settings/{userId}.theme` | `localStorage['continuity_theme']` |
| Q&A log | `claudeDb.qa_log` | `localStorage['continuity_qa']` |
| Eval runs | `claudeDb.eval_runs` | `localStorage['continuity_eval']` |
| Evidence | `claudeDb.evidence_pack` | `FALLBACK_EVIDENCE_PACK` constant |
| Golden set | `claudeDb.golden_set` | `FALLBACK_GOLDEN_SET` constant |

`claudeDb` resolves to `null` on any non-`claude.ai` host; all code paths handle `null` gracefully.
