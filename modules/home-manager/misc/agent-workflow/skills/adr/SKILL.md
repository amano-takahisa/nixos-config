---
name: adr
description: Create, list, inspect, or update architecture decision records when a decision is costly to revisit.
---

Manage architecture decision records in the current repository's `docs/adr/`.
Read its README and existing records first; follow the format and status names
already used there. Use Japanese and MADR format when that is the repository
convention.

Create an ADR only for a durable architectural or workflow decision with real
alternatives and tradeoffs. Reuse decisions already made in the conversation
instead of asking again. Mark a new record as proposed until the user approves
the decision. When replacing a record, link the old and new records in both
directions and explain the reason.

Support listing records, displaying one record by number, and updating status
when the user asks. Do not create an ADR merely to document an implementation
detail.
