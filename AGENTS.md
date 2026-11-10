# AGENTS.md

Rules for AI coding agents working in this repository. People should read
[CONTRIBUTING.md](CONTRIBUTING.md); everything here applies to them too. The
`PR rules` check enforces the rules marked (checked); a pull request that
breaks one cannot be merged.

## What storehound is

A Dart CLI and library that lints a Flutter project's `Info.plist`, privacy
manifest, entitlements, ExportOptions and `AndroidManifest.xml` for mistakes
that get App Store or Google Play builds refused. Rules live in
`lib/src/rules/` (registered in `all_rules.dart`), the store data they rely on
in `lib/src/data/`, configuration (`storehound.yaml`) in `lib/src/config.dart`
and the reporters in `lib/src/report/`.

Read before you touch:

- a rule: the "Adding a rule" section of CONTRIBUTING.md, `doc/rules.md`,
  and `test/support/fixtures.dart`.
- a data table: the "Updating a data table" section of CONTRIBUTING.md and
  the sources cited at the top of each file in `lib/src/data/`.
- configuration or the CLI: `doc/configuration.md`.
- the fixture apps: `test/fixtures/README.md`, including how to regenerate
  `test/fixtures/production_app.golden.txt`.

## Commands

Use the Dart SDK, 3.8 or newer. Every one of these must pass before you open
or update a pull request. CI runs the same ones:

```bash
dart pub get
dart format --output=none --set-exit-if-changed .
dart analyze --fatal-infos
dart test
dart pub publish --dry-run
dart run storehound --project test/fixtures/clean_app
dart run storehound --project test/fixtures/rejected_app --sarif --output rejected.sarif || test $? -eq 1
dart run storehound --project test/fixtures/production_app --fail-on info --today 2026-10-01 --brief --no-color > production.txt
diff -u test/fixtures/production_app.golden.txt production.txt
```

CI runs them on Dart 3.8.0 and 3.13.5 (formatting on 3.13.5 only).

Run one test file while iterating: `dart test test/rules/android_test.dart`.

## Stop and ask the human

Some things must come from the real world. An agent must never invent them.
Stop and ask the person you work for to provide them:

- **A real rejection.** A new rule starts from an App Review guideline number,
  an `ITMS-` code, the reviewer's wording (anonymised) or observed store or
  platform behaviour, provided by the human, plus the public Apple or Google
  page that documents it. Never invent a rejection, a code or a guideline
  number.
- **Store data.** Every privacy data type, purpose and required-reason code,
  every SDK data type mapping, every purpose string a plugin needs (from that
  plugin's README) and every Play target API deadline is copied from the
  public source cited in `lib/src/data/`. Never invent a value, a date or an
  API level; if you cannot find the source, say so.
- **Real Xcode, Gradle or device output.** What Xcode writes into
  `project.pbxproj`, what AGP or the NDK does, or what a binary links (for
  example `nm -u`) must come from a real run the human did.
- **An accepted issue.** If the change has no issue labelled `accepted`, stop
  and ask the human to open one and wait for a maintainer.

## Code

- **English only** for code, identifiers, comments, commit messages and docs.
  Answer the person you work for in their language.
- Target the minimum SDK in `pubspec.yaml` (Dart 3.8). Do not use language or
  library features newer than that.
- Rules read files only through `context.project`, and prefer false
  negatives over false positives; heuristics are `Severity.warning`.
- Public API has doc comments (`public_member_api_docs`). Other comments are
  sparse: only where the code is not self-evident. Do not add comments, doc
  comments or type annotations to code you did not change.

## Tests (checked)

- Every change to `lib/` or `bin/` comes with a test change under `test/`. A
  bug fix has a test that fails without the fix; check that it does before
  you open the pull request.
- A new or changed rule has tests in `test/rules/` with a passing and a
  failing synthetic fixture, and a row in the README rule table (`test/version_test.dart`
  checks it).
- Fixtures are invented: no real app, company, bundle id, hostname, key or
  person (`com.example.*`, `example.com`, placeholder Firebase values).

## Never

- Never silence the analyzer or storehound (checked): no `// ignore:`,
  `// ignore_for_file:`, no changes to `analysis_options.yaml`, and no
  `ignore:` entries or `enabled: false` in a `storehound.yaml` outside
  `test/fixtures/rejected_app/`. Fix the finding instead.
- Never delete, skip, loosen or rewrite an existing test, expectation or
  fixture to make CI pass, and never regenerate
  `production_app.golden.txt` to accept a new finding: on that fixture it is
  a false positive until shown otherwise. If a test looks wrong, say so in
  the issue.
- Never change what users depend on: rule `id`s and `check:<name>` ids,
  `storehound.yaml` keys (and the legacy `imaji_store_preflight.yaml` name),
  CLI flags, exit codes (0 clean, 1 findings, 2 usage or configuration
  problem), and the JSON and SARIF output.
- Never bump the version in `pubspec.yaml`, edit a released `CHANGELOG.md`
  section, publish, tag or release. Add your entry at the top of
  `CHANGELOG.md` under `## Unreleased` (create the heading if it is missing).
- Never add a dependency or change CI workflows unless the issue asks for it.
- Never add unrelated "improvements": no drive-by refactors, renames,
  reformatting of untouched code or dead code.
- Never open pull requests, issues or comments on your own. The human reviews
  your work and posts it.

## Pull requests (checked)

- First an issue, labelled `accepted` by a maintainer. The pull request says
  `Closes #N`.
- One issue per pull request, at most 400 changed lines.
- At most 2 open pull requests per person.
- Fill in the pull request template, including `### AI use` with the tool and
  model.
- The person submitting has read, run and understood every line, and writes
  the description in their own words. Pull requests that are raw, unreviewed
  agent output will be closed.
