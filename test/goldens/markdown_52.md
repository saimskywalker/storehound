### ✗ storehound <version>: 26 errors, 13 warnings, 13 info

Failing on findings at or above `error`. 4 rules checked.

| | Rule | Where | Finding |
|---|---|---|---|
| ✗ error | `purpose-string-missing` | `pubspec.yaml` | Finding 0. |
| ✗ error | `check:min-os` | `ios/Runner/File3.plist` | 100% \<wrong>, see `a\|b` and `<b>`. |
| ✗ error | `purpose-string-missing` | `ios/Runner/File4.plist:4` | Finding 4. |
| ✗ error | `check:min-os` | `ios/Runner/File7.plist` | Finding 7. |
| ✗ error | `purpose-string-missing` | `ios/Runner/File8.plist:8` | Finding 8. |
| ✗ error | `check:min-os` | `ios/Runner/File11.plist` | Finding 11. |
| ✗ error | `purpose-string-missing` | `ios/Runner/File12.plist:12` | Finding 12. |
| ✗ error | `check:min-os` | `ios/Runner/File15.plist` | Finding 15. |
| ✗ error | `purpose-string-missing` | `ios/Runner/File16.plist:16` | Finding 16. |
| ✗ error | `check:min-os` | `ios/Runner/File19.plist` | Finding 19. |
| ✗ error | `purpose-string-missing` | `ios/Runner/File20.plist:20` | Finding 20. |
| ✗ error | `check:min-os` | `ios/Runner/File23.plist` | Finding 23. |
| ✗ error | `purpose-string-missing` | `ios/Runner/File24.plist:24` | Finding 24. |
| ✗ error | `check:min-os` | `ios/Runner/File27.plist` | Finding 27. |
| ✗ error | `purpose-string-missing` | `ios/Runner/File28.plist:28` | Finding 28. |
| ✗ error | `check:min-os` | `ios/Runner/File31.plist` | Finding 31. |
| ✗ error | `purpose-string-missing` | `ios/Runner/File32.plist:32` | Finding 32. |
| ✗ error | `check:min-os` | `ios/Runner/File35.plist` | Finding 35. |
| ✗ error | `purpose-string-missing` | `ios/Runner/File36.plist:36` | Finding 36. |
| ✗ error | `check:min-os` | `ios/Runner/File39.plist` | Finding 39. |
| ✗ error | `purpose-string-missing` | `ios/Runner/File40.plist:40` | Finding 40. |
| ✗ error | `check:min-os` | `ios/Runner/File43.plist` | Finding 43. |
| ✗ error | `purpose-string-missing` | `ios/Runner/File44.plist:44` | Finding 44. |
| ✗ error | `check:min-os` | `ios/Runner/File47.plist` | Finding 47. |
| ✗ error | `purpose-string-missing` | `ios/Runner/File48.plist:48` | Finding 48. |
| ✗ error | `check:min-os` | `ios/Runner/File51.plist` | Finding 51. |
| ⚠ warning | `check:min-os` | `ios/Runner/File1.plist` | Finding 1. |
| ⚠ warning | `check:min-os` | `ios/Runner/File5.plist` | Finding 5. |
| ⚠ warning | `check:min-os` | `ios/Runner/File9.plist` | Finding 9. |
| ⚠ warning | `check:min-os` | `ios/Runner/File13.plist` | Finding 13. |
| ⚠ warning | `check:min-os` | `ios/Runner/File17.plist` | Finding 17. |
| ⚠ warning | `check:min-os` | `ios/Runner/File21.plist` | Finding 21. |
| ⚠ warning | `check:min-os` | `ios/Runner/File25.plist` | Finding 25. |
| ⚠ warning | `check:min-os` | `ios/Runner/File29.plist` | Finding 29. |
| ⚠ warning | `check:min-os` | `ios/Runner/File33.plist` | Finding 33. |
| ⚠ warning | `check:min-os` | `ios/Runner/File37.plist` | Finding 37. |
| ⚠ warning | `check:min-os` | `ios/Runner/File41.plist` | Finding 41. |
| ⚠ warning | `check:min-os` | `ios/Runner/File45.plist` | Finding 45. |
| ⚠ warning | `check:min-os` | `ios/Runner/File49.plist` | Finding 49. |
| ℹ info | `purpose-string-missing` | `ios/Runner/File2.plist:2` | Finding 2. |
| ℹ info | `purpose-string-missing` | `ios/Runner/File6.plist:6` | Finding 6. |
| ℹ info | `purpose-string-missing` | `ios/Runner/File10.plist:10` | Finding 10. |
| ℹ info | `purpose-string-missing` | `ios/Runner/File14.plist:14` | Finding 14. |
| ℹ info | `purpose-string-missing` | `ios/Runner/File18.plist:18` | Finding 18. |
| ℹ info | `purpose-string-missing` | `ios/Runner/File22.plist:22` | Finding 22. |
| ℹ info | `purpose-string-missing` | `ios/Runner/File26.plist:26` | Finding 26. |
| ℹ info | `purpose-string-missing` | `ios/Runner/File30.plist:30` | Finding 30. |
| ℹ info | `purpose-string-missing` | `ios/Runner/File34.plist:34` | Finding 34. |
| ℹ info | `purpose-string-missing` | `ios/Runner/File38.plist:38` | Finding 38. |
| ℹ info | `purpose-string-missing` | `ios/Runner/File42.plist:42` | Finding 42. |

… 2 more: see the job log or the JSON artifact

<details><summary>Why these matter and how to fix them</summary>

**`purpose-string-missing`** — Title of purpose-string-missing

Why: Why purpose-string-missing matters.

Fix: How to fix purpose-string-missing.

Docs: <https://example.com/purpose-string-missing>

**`check:min-os`** — Title of check:min-os

Why: Why check:min-os matters.

Fix: Add to \<manifest>:
```
    <queries/>
```

Docs: <https://example.com/check:min-os>

</details>

Full report: `storehound-report` artifact (JSON). Explain a rule: `storehound --explain <rule>`. Exit code: 1.
