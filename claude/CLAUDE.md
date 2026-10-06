# Git commit conventions

## Commit message format

Follow the format defined in `~/.config/git/template` (git's global `commit.template`): Conventional Commits style.
```
type: [subject]

[optional body]

[optional footer]
```
- `type`: one of `build`, `ci`, `chore`, `docs`, `feat`, `fix`, `perf`,
  `refactor`, `revert`, `style`, `test`.
- `scope` (optional): parenthesized context, e.g. `feat(parser): ...`.
- Subject: imperative present tense ("change" not "changed"/"changes"), capitalized, no trailing period, ≤50 characters.
- Body: imperative present tense, explains *what and why* over *how*, wrapped at 72 characters, separated from the subject by a blank line.
- Language: always write commit messages (subject and body) in English, even when the conversation is conducted in another language.

# Sandbox excluded commands

Commands matched by a `sandbox.excludedCommands` pattern (user or project `settings.json`, e.g. `kill *`, `git push *`, `gh *`, `docker *`, `playwright-cli *`, `pnpm run test*`) only run unsandboxed when the Bash call is **exactly one plain command**. Anything that makes it a compound command stops the pattern from matching, so the whole call runs inside the sandbox and fails there (e.g. `kill` → `operation not permitted`, Playwright → `mach_port_rendezvous` permission error).

- Do not combine an excluded command with pipes (`|`), `;`, `&&`, `||`, redirections (`>`, `2>&1`), subshells/background (`( … )`, `&`), or env-var prefixes (`CI=1 …`).
- Run it as its own Bash call, then do any follow-up (verifying, filtering output, cleanup) in a separate call.
- If an excluded command fails with a sandbox-style error, first check whether the call was compound and retry it alone before concluding it is blocked.
