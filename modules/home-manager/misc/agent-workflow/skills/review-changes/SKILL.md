---
name: review-changes
description: Review a diff for correctness, regressions, scope, and missing verification without editing files.
---

Review the current changes against the task's acceptance criteria and the
repository's local conventions. Determine the intended base from branch and
pull-request context rather than assuming a branch name. Inspect the complete
diff and relevant surrounding code.

Focus on concrete bugs, behavior changes, missing error handling, regressions,
scope violations, and tests that do not cover an acceptance criterion. Do not
edit files. Report actionable findings first, with severity and file/line
references. If there are no findings, say so and list any checks that remain
unverified. Do not treat a test run as a substitute for inspecting the diff.
