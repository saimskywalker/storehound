# Plugin requirement data: draft schema

Status: draft. Nothing reads this format yet.

storehound knows which Info.plist purpose strings 16 Flutter plugins ask for
(`purposeStringsByPlugin` in `lib/src/data/plugin_requirements.dart`). Other
tools keep similar lists. This draft describes the same data as plain JSON, so
that one list can be shared, corrected by plugin authors, and read by any
tool.

## Format

One JSON document. Field names are camelCase.

```json
{
  "schemaVersion": 1,
  "plugins": [
    {
      "plugin": "example_media_picker",
      "versions": ">=2.0.0 <3.0.0",
      "keys": [
        { "key": "NSPhotoLibraryUsageDescription", "level": "required" },
        {
          "key": "NSMicrophoneUsageDescription",
          "level": "conditional",
          "condition": "you record video"
        }
      ],
      "source": "https://pub.dev/packages/example_media_picker#ios",
      "section": "example_media_picker README, \"iOS\"",
      "checked": "2026-11-14"
    }
  ]
}
```

The example plugin is invented.

## Fields

Top level:

| Field | Type | Meaning |
|---|---|---|
| `schemaVersion` | integer | `1`. Raised only for a change that breaks readers. |
| `plugins` | array | One entry per plugin and version range. |

Each entry in `plugins`:

| Field | Type | Required | Meaning |
|---|---|---|---|
| `plugin` | string | yes | The package name on pub.dev. |
| `versions` | string | yes | The plugin versions the entry covers, as a pub version constraint (`>=2.0.0 <3.0.0`, `^2.1.0`). A plugin whose requirements changed between versions has one entry per range; ranges of one plugin do not overlap. |
| `keys` | array | yes | The Info.plist keys the source asks for. May be empty when a version range needs none. |
| `source` | string | yes | `https://` link to the README section (or setup guide) that lists the keys. |
| `section` | string | no | Where `source` points, as a reader finds it. |
| `checked` | string | yes | The date someone last compared the entry with `source`, as `YYYY-MM-DD`. |

Each entry in `keys`:

| Field | Type | Required | Meaning |
|---|---|---|---|
| `key` | string | yes | The Info.plist key, for example `NSCameraUsageDescription`. |
| `level` | string | yes | `required`: every app that links the plugin needs the key. `conditional`: only apps that use one feature of the plugin need it. |
| `condition` | string | with `conditional` | The feature, completing "needed only if …", taken from the source. Absent for `required`. |

Rules for the data:

- A key is `conditional` only when the plugin's own source says it is needed
  for one feature. Otherwise it is `required`.
- Every value comes from `source`. Nothing is guessed.
- Readers ignore fields they do not know, so new optional fields do not need
  a new `schemaVersion`.

## How storehound's table maps to it

| storehound today | This schema |
|---|---|
| map key (`'image_picker'`) | `plugin` |
| `PluginPurposeStrings.source` | `source` |
| `PluginPurposeStrings.section` | `section` |
| `PluginKey.key` | `keys[].key` |
| `PluginKey.level` (`KeyLevel.required`, `KeyLevel.conditional`) | `keys[].level` |
| `PluginKey.condition` | `keys[].condition` |
| not recorded | `versions` |
| not recorded | `checked` |

Moving the 16 entries over means recording, for each one, the plugin version
whose README was read and the date it was read. Until that is done for an
entry, it cannot be written in this format.

Out of scope for this draft: `linkedApiReferences` (APIs a plugin's binary
references without asking for the permission; a different meaning, kept in
its own table) and `backgroundModeEvidence`.

## License

Proposed: CC0 1.0, so any tool can copy the data without attribution
requirements. Not decided yet.
