### ✗ storehound <version>: 2 errors, 2 warnings, 0 info

Failing on findings at or above `error`. 4 rules checked.

| | Rule | Where | Finding |
|---|---|---|---|
| ✗ error | `purpose-string-missing` | `ios/Runner/Info.plist` | `NSPhotoLibraryUsageDescription` is missing, but image_picker needs it. |
| ✗ error | `purpose-string-quality` | `ios/Runner/Info.plist:5` | `NSCameraUsageDescription` only restates the permission. |
| ⚠ warning | `purpose-string-missing` | `ios/Runner/Info.plist` | `NSMicrophoneUsageDescription` is missing; needed only if you record video. |
| ⚠ warning | `privacy-manifest-present` | `ios/Runner/Info.plist` | No privacy manifest at ios/Runner/PrivacyInfo.xcprivacy. |

<details><summary>Why these matter and how to fix them</summary>

**`purpose-string-missing`** — Title of purpose-string-missing

Why: Why purpose-string-missing matters.

Fix: How to fix purpose-string-missing.

Docs: <https://example.com/purpose-string-missing>

**`purpose-string-quality`** — Title of purpose-string-quality

Why: Why purpose-string-quality matters.

Fix: How to fix purpose-string-quality.

Docs: <https://example.com/purpose-string-quality>

**`privacy-manifest-present`** — Title of privacy-manifest-present

Why: Why privacy-manifest-present matters.

Fix: How to fix privacy-manifest-present.

Docs: <https://example.com/privacy-manifest-present>

</details>

Full report: `storehound-report` artifact (JSON). Explain a rule: `storehound --explain <rule>`. Exit code: 1.
