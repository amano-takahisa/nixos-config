---
name: verify-change
description: Verify an implementation against its acceptance criteria with focused checks and real application behavior where practical.
---

Read the repository's instructions and identify the acceptance criteria for the
change. Run the narrowest relevant tests first, then the repository's required
lint, type, build, and test checks. Use the project's declared development
environment and documented commands; report unavailable or failing checks
without claiming success.

For a user-visible web change, start the app using its documented setup and
exercise the affected browser flow when a browser tool is available. Inspect
the rendered result and relevant browser console or network errors. Capture a
screenshot or trace when it helps demonstrate a visual or interaction change.
Do not launch a second server or mutate shared test data when an existing
session is using the same resources.

Finish by mapping each acceptance criterion to evidence. State what was run,
what passed or failed, and what could not be verified.
