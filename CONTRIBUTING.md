# Contributing

Thanks for helping Flutter developers stop losing review cycles. The most
valuable contributions are **new rules backed by a real rejection** and
**corrections to the data tables** (Apple's privacy vocabulary, the SDK →
data-type map, Play's target API deadlines).

## Development

```bash
dart pub get
dart format .
dart analyze --fatal-infos
dart test
dart pub publish --dry-run
dart run storehound --project test/fixtures/rejected_app
dart run storehound --project test/fixtures/production_app --fail-on info --today 2026-10-01
```

CI runs these on the minimum supported SDK (3.8.0) and a pinned current
stable, with `dart format --output=none --set-exit-if-changed .` (on the
pinned stable only) in place of `dart format .`.

## Adding a rule

1. **Start from evidence.** Open an issue describing the rejection or silent
   failure: the App Review guideline or ITMS code, the reviewer's wording
   (anonymised), or the platform behaviour, plus the public Apple/Google
   documentation that explains it. A rule without a documented source will
   not be merged.
2. **Write the rule** in `lib/src/rules/` by extending `Rule`:
   - `id`: kebab-case, stable forever (users reference it in config).
   - `title`: one line, phrased as the property that should hold.
   - `why`: which rejection or silent failure it prevents, in terms a
     developer who has never seen it can follow.
   - `fix`: what to change, concretely.
   - `docs`: `https://` links to the public documentation it is built on.
   - `check(context)`: yield findings via `finding(message, path:, line:)`.
     Read files only through `context.project` — it parses each file once,
     records unreadable ones, and gives you line numbers.
   - Options: list keys in `optionKeys` and validate them in
     `validateOptions`; read them from `context.options`.
   Prefer false negatives over false positives: a lint people ignore protects
   nobody. Use `Severity.warning` for heuristics.
3. **Register it** in `lib/src/rules/all_rules.dart`.
4. **Test it** in `test/rules/` with at least one passing and one failing
   synthetic fixture (see `test/support/fixtures.dart`). Fixtures must be
   invented: no real app names, bundle ids, hostnames or people.
5. **Document it**: add a row to the README rule table (a test enforces this)
   and a line to `CHANGELOG.md`. If the rule ships a row marked "planned" in
   the "Problems this solves" table in `doc/rules.md`, replace the plan issue
   link with the rule id.

## Updating a data table

`lib/src/data/` holds the tables. Every entry cites where it comes from;
keep it that way, and keep entries conservative (only what an SDK collects
by default, only deadlines Google has published).

## Pull requests

Small, focused commits with clear messages, in English. Run the commands
above before pushing; every CI check must pass before a pull request can be
merged. The `PR rules` check enforces these:

- **Issue first.** Open an issue and wait until a maintainer labels it
  `accepted`, then write `Closes #N` in the pull request.
- **Tests.** Every change to `lib/` or `bin/` needs a test change under
  `test/`. A bug fix needs a test that fails without the fix.
- **Small.** At most 400 changed lines, one issue per pull request.
- **No suppressions.** No `// ignore:`, no changes to
  `analysis_options.yaml`, and no `ignore:` entries or `enabled: false` in a
  `storehound.yaml` outside `test/fixtures/rejected_app/`. Fix the finding.
- **At most 2 open pull requests** per person.

If a rule really does not fit your change, say why in the description. A
maintainer can waive it with a label (`no-tests-needed`, `large-change` or
`suppression-ok`).

## Legal notice

By submitting a contribution you confirm that you wrote it, that you have the
right to submit it, and that it may be distributed under the project license
(see [LICENSE](LICENSE)).

## AI-assisted contributions

Using AI tools is fine; please just be open about it.

- Say in the PR description which AI tools you used, if any: none, some or
  most, plus the tool or agent and the model (for example "Claude Code,
  Opus 5.5" or "Copilot, GPT-5").
- Please write the PR description in your own words; short and plain is fine.
  It shows us what you understood about the change. Please don't paste
  generated text.
- Read, run and test every line you submit, and be ready to explain it in
  review. If you don't understand what a line does, don't submit it.
- Keep the change focused. Agents like to add unrelated "improvements",
  long comments and dead code; remove them before you open the pull request.
- Pull requests that are raw, unreviewed agent output will be closed.
- If you use an agent, point it at [AGENTS.md](AGENTS.md).
- If the disclosure is missing, a check adds a reminder to the PR. It does
  not fail the PR, but a maintainer will ask about it before merging.

## Stay in touch

Don't forget to follow [@saimskywalker](https://github.com/saimskywalker) on
GitHub to see new releases and other open-source projects as they come out.
