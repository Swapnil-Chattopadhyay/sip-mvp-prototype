# Eval-Gate Specification — Ask Feature

## Purpose

The Ask tab's AI assistant is **locked by default**. It unlocks only after a golden-set evaluation confirms the underlying evidence pack produces quality-sufficient answers. This prevents an investor from receiving low-quality or hallucinated answers about their SIP.

## Evaluation Flow

```
1. Load evidence_pack  (db → FALLBACK_EVIDENCE_PACK)
2. Load golden_set     (db → FALLBACK_GOLDEN_SET)
3. For each {question, expected} in golden_set (10 pairs):
   a. Build prompt: buildAskPrompt(question, evidencePack)
   b. Call LLM (or mock in fallback mode)
   c. Score: mapSampleError(response, expected) → { match, score }
4. Aggregate: totalScore = Σ scores / golden_set.length
5. If totalScore ≥ 0.70 → unlock Ask feature
   If totalScore < 0.70 → keep locked, show score chip
6. Persist result to eval_runs collection
```

## Golden Set (10 canonical pairs)

| # | Question | Key expected elements |
|---|----------|-----------------------|
| 1 | What happens if I miss a SIP instalment? | penalty, lapse, continuation |
| 2 | How is the ₹350 penalty calculated? | 2%, monthly, outstanding |
| 3 | What is the Continuity feature? | auto-bridge, 90-day, no lapse |
| 4 | What alerts does Coin send before a lapse? | D-7, D-3, D-0, SMS+email |
| 5 | How does SIP continuation affect long-term returns? | compounding, rupee cost averaging |
| 6 | What is my current L0 score? | computed from KRs, evidence R-11 |
| 7 | Which SIPs are at risk this month? | pending instalments, timeline |
| 8 | What is the SEBI rule on SIP lapse? | SEBI circular, 3-miss rule |
| 9 | How do I reactivate a lapsed SIP? | re-registration, new mandate |
| 10 | What is the penalty waiver policy? | first-lapse waiver, one-time |

## Scoring (`mapSampleError`)

```js
function mapSampleError(response, expected) {
  const keywords = expected.toLowerCase().split(/\s+/);
  const resp = response.toLowerCase();
  const hits = keywords.filter(k => k.length > 4 && resp.includes(k)).length;
  const score = hits / keywords.filter(k => k.length > 4).length;
  return { match: score >= 0.5, score };
}
```

A response scores 1.0 if it contains ≥50% of the expected answer's significant words (>4 chars). The aggregate threshold for unlock is **0.70** (70% across all 10 pairs).

## Advice Refusal Gate

Before any answer is generated, `isAdviceSeeking(question)` checks for advisory language:

```js
const ADVICE_PATTERNS = [
  /should i (buy|sell|switch|redeem|invest|exit)/i,
  /is .* (good|bad|worth|safe|risky)/i,
  /recommend|advise|suggest|tell me (what|which|how) to/i,
  /best (fund|sip|scheme|option)/i,
  /where should i (put|invest)/i,
];
```

Matched questions receive `REFUSAL_TEXT` immediately — the LLM is never called.

## Locked State UI

When eval score < 70%:
- Ask input is disabled
- A red chip shows the score: `Quality check: XX% — feature locked`
- A "Re-run evaluation" button is shown
- The last eval timestamp is displayed

## Unlocked State UI

When eval score ≥ 70%:
- Green chip: `Quality check: XX% ✓`
- Input enabled, placeholder: "Ask about your SIPs…"
- Each answer shows cited evidence codes in grey chips below the bubble
