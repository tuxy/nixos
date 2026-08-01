---
name: code-review
description: Review changed or modified sections of code for bugs, logic errors, edge cases, code quality, and maintainability. Use when the user asks to review recent changes, a diff, or specific code sections.
---

# Code Review

Review the changed or modified code sections thoroughly. Focus on what has changed, not the entire codebase.

## Instructions

1. **Identify the changes** — use `git diff`, `git show`, or read the specific files/sections the user mentioned
2. **For each changed section, check:**

   - **Correctness** — does the logic handle all cases? Any off-by-one, null pointer, type mismatch?
   - **Edge cases** — empty inputs, boundary values, error states, concurrent access
   - **Side effects** — does the change affect other parts of the system unexpectedly?
   - **Error handling** — are errors caught, logged, and handled gracefully?
   - **Performance** — any unnecessary allocations, N+1 queries, or blocking calls?
   - **Style & conventions** — does it follow the project's established patterns?
   - **Test coverage** — are the changes tested? Are existing tests still valid?

3. **Format your review:**
   - **Summary** — 1-2 sentence overview of what changed and overall verdict
   - **Issues** — list each issue with severity: `🔴 Critical`, `🟡 Warning`, `🔵 Suggestion`
   - **Positives** — call out well-written sections
   - **Questions** — anything unclear that needs clarification

4. **Be constructive.** Explain *why* something is a problem and suggest *how* to fix it.

## Examples

### Issue format

```markdown
🔴 Critical: Null pointer dereference in `processUser()` line 42
When `user.profile` is null, calling `user.profile.name` throws.
Fix: add a null check before accessing `name`.
```

```markdown
🟡 Warning: Unhandled promise rejection in `fetchData()`
The async call on line 15 is not wrapped in try/catch.
Fix: wrap in try/catch and add error logging.
```

```markdown
🔵 Suggestion: Use `const` instead of `let` on line 33
`items` is never reassigned after initialization.
```

## References

- [Google Code Review Guidelines](https://google.github.io/eng-practices/review/)
