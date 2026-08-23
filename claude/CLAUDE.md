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
