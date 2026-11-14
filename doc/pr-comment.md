# Pull request comment

The action writes a job summary and annotations but never comments. To post
the Markdown report as a pull request comment, and update it on each push,
add a job like this:

```yaml
name: Store preflight comment
on: pull_request

jobs:
  comment:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write   # post and edit the comment
    steps:
      - uses: actions/checkout@v6
        with:
          persist-credentials: false
      - uses: dart-lang/setup-dart@v1
      - run: dart pub global activate storehound '^0.3.0'
      - id: storehound
        continue-on-error: true  # comment first, fail below
        run: dart pub global run storehound --format markdown --output storehound.md
      - if: github.event.pull_request.head.repo.full_name == github.repository
        env:
          GH_TOKEN: ${{ github.token }}
          GH_REPO: ${{ github.repository }}
          PR: ${{ github.event.pull_request.number }}
        run: gh pr comment "$PR" --body-file storehound.md --edit-last --create-if-none
      - if: steps.storehound.outcome == 'failure'
        run: exit 1
```

`--edit-last` edits the newest comment by `github-actions[bot]` on the pull
request. If another workflow also comments as that bot, drop the flag to post
a new comment each time.

**Pull requests from forks.** On `pull_request` from a fork the token is
read-only, so the comment step is skipped by its `if:`; the job summary and
annotations still work. Do not switch to `pull_request_target` to get a write
token while checking out the fork's code: that runs untrusted code with
write access. If fork pull requests need a comment, upload `storehound.md` as
an artifact and post it from a separate workflow triggered by
`workflow_run`, which never checks out the fork.
