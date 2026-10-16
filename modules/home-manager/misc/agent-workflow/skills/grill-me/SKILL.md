---
name: grill-me
description: Clarify a vague product or engineering request through focused questions with options and recommendations before proposing scope and acceptance criteria.
---

Clarify the request enough to make implementation decisions. First inspect the
repository and existing documentation so you do not ask questions they already
answer. Ask one focused question at a time, using the available question UI
when it helps. Follow the user's answers and stop once scope, constraints, and
acceptance criteria are clear.

When a question involves a choice, usually offer two or three distinct,
concrete options in plain language. Briefly explain the main benefit or
tradeoff of each so the user can answer without researching the alternatives.
Put the recommended option first, label it as recommended, and explain why it
fits the user's goal and known constraints. State any assumption that affects
the recommendation; if there is not enough information to prefer an option,
ask for the missing fact instead of inventing a preference.

Let the user give a different answer or say they are unsure. For facts or
examples that options would constrain unnecessarily, ask a short open question.
Use the question UI when available; otherwise present numbered options that
the user can answer by number or in their own words. Do not treat a preselected
option or silence as the user's decision. Adapt the next question to their
answer rather than repeating a fixed questionnaire.

Summarize the agreed goal, acceptance criteria, constraints, and unresolved
risks. Suggest an ADR only for decisions whose rationale will matter later.
Do not create an Issue, ADR, plan, or code change unless the user requested
that artifact or action.
