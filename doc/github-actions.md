# GitHub Actions

## The action

```yaml
name: Store preflight
on: [push, pull_request]

jobs:
  storehound:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      security-events: write   # only with sarif: true
      actions: read            # sarif: true in a private repository (unverified)
    steps:
      - uses: actions/checkout@v6
        with:
          persist-credentials: false
      - uses: saimskywalker/storehound@v0
        with:
          project: .           # Flutter project root
          fail-on: error       # default: storehound.yaml, else error
          sarif: true          # a failed upload does not fail the job
```

The action sets up Dart and runs the storehound command line once per
format:

- `--format github`: findings as annotations on the pull request.
- `--format markdown`: appended to the job summary.
- `--format json`: uploaded as the `storehound-report` artifact.
- `--sarif`, only with `sarif: true`: uploaded to code scanning. The upload
  step uses `continue-on-error`, so a repository without code scanning still
  gets the summary, annotations and artifact.

The job fails when there are findings at or above `fail-on`, never because
of an upload. Without `sarif: true` the job needs only `contents: read`.

| Input | Default | |
|---|---|---|
| `project` | `.` | Flutter project root to check. |
| `fail-on` | from `storehound.yaml`, else `error` | `error`, `warning`, `info` or `never`. |
| `version` | the action's own code | A pub.dev version to activate instead, e.g. `0.3.0`. |
| `sarif` | `false` | Upload SARIF to code scanning. |
| `artifact-name` | `storehound-report` | Set a different one for each run when the action runs more than once in a workflow run. |

The action does not comment on pull requests; see
[Pull request comment](pr-comment.md) for a recipe.

## Without the action

With the same `permissions:` as above:

```yaml
    steps:
      - uses: actions/checkout@v6
        with:
          persist-credentials: false
      - uses: dart-lang/setup-dart@v1
      - run: dart pub global activate storehound '^0.2.2'
      - run: dart pub global run storehound --sarif --output preflight.sarif
      - uses: github/codeql-action/upload-sarif@v4
        if: always()           # upload even when the check fails the job
        with:
          sarif_file: preflight.sarif
          category: storehound
```

## Flutter SDK on the runner

If `android/app/build.gradle(.kts)` sets `targetSdk = flutter.targetSdkVersion`
(the `flutter create` default), the value lives in the Flutter SDK, which the
tool finds through `.dart_tool/package_config.json` or `FLUTTER_ROOT`. With
only Dart on the runner neither exists, so `android-target-sdk` reports an
`info` finding instead of checking the deadline. Set its `target_sdk` option,
or install Flutter (e.g. `subosito/flutter-action`) and run `flutter pub get`
before the check.

Without code scanning (it needs a public repository or GitHub Advanced
Security), use the job summary and annotations, or the default text output;
the job log then carries the why/fix for every finding. Suppressed findings
are written to the SARIF with their reason, so code scanning shows them as
dismissed.
