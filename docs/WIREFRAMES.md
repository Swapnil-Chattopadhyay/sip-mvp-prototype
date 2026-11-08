# Pitch Deck Wireframes

The wireframes are published as a **Claude Design canvas** (5 editable artboards):

**URL:** https://claude.ai/artifact/FyzseAQxw9ArFhTKLRWDo7

## Screens

| # | Screen | Key elements |
|---|--------|-------------|
| 1 | **Dashboard** | Topbar nav, mandate box, action-needed summary, instalment order-table, problems-answered row |
| 2 | **Alerts** | Alert order-table (severity chips, timestamps), no-alert comparison box |
| 3 | **Impact (OKR)** | L0 box, 4-column KR grid, with-vs-without penalty table, chart placeholder |
| 4 | **Ask (AI)** | Disclaimer, grounded answer bubble (citing TQ-07/AS-03/R-11), refused advice bubble, quality-check panel (95%/100% score chips), text input |
| 5 | **Settings + Dark Mode** | Dark-themed panel (display name, email, light/dark radio, notify checkbox, cancel/save), moon/gear icons in topbar |

## How to Edit

### Text / headings
Click directly into any text in the canvas editor — it's live, editable text, not an image.

### Per-screen levers (properties panel)
Each artboard exposes three editable props in the right-side properties panel:

| Prop | Type | Default | Effect |
|------|------|---------|--------|
| `title` | text | screen name | Main heading of the artboard |
| `note` | text | annotation copy | Annotation label below heading |
| `accent` | color | `#2b2b2b` | Outline color of boxes, pills, and buttons |

Change `accent` to `#ff5722` (Zerodha orange) across all 5 screens to immediately produce a branded variant of the wireframes.

### Shared stylesheet
All 5 artboards link to `wireframe.css`. To change the global typeface, border style, or spacing, ask Claude to update `wireframe.css` — the change propagates to all screens simultaneously.

## Wireframe Conventions

- **Grayscale palette** — no brand colors in the default state
- **Diagonal-hatch blocks** — placeholders for charts/images (CSS `repeating-linear-gradient`)
- **Real copy** — all text is drawn from the actual prototype, not lorem ipsum
- **Dashed borders** — `.wf-box.dashed` indicates a container the user can fill with their own content
- **Times New Roman** — matches the prototype typography
