import 'dart:io';

import 'package:storehound/storehound.dart';
import 'package:test/test.dart';

class _Rule extends Rule {
  const _Rule(this.id);

  @override
  final String id;
  @override
  String get title => 'Title of $id';
  @override
  RulePlatform get platform => RulePlatform.general;
  @override
  Severity get defaultSeverity => Severity.error;
  @override
  String get why => 'Why $id matters.';
  @override
  String get fix => id.startsWith('check:')
      ? 'Add to <manifest>:\n    <queries/>'
      : 'How to fix $id.';
  @override
  List<String> get docs => ['https://example.com/$id'];
  @override
  Iterable<Finding> check(RuleContext context) => const [];
}

const _rules = [
  _Rule('purpose-string-missing'),
  _Rule('purpose-string-quality'),
  _Rule('privacy-manifest-present'),
  _Rule('check:min-os'),
];

PreflightReport _report(
  List<Finding> findings, {
  List<SuppressedFinding> suppressed = const [],
}) => PreflightReport(
  projectRoot: '/project',
  rules: _rules,
  findings: findings,
  suppressed: suppressed,
  disabled: const [],
  unusedIgnores: const [],
  failOn: Severity.error,
);

/// [count] findings, one without a path and one that needs escaping.
List<Finding> _many(int count) => [
  for (var i = 0; i < count; i++)
    Finding(
      ruleId: _rules[i.isEven ? 0 : 3].id,
      severity: Severity.values[i % 4 % 3],
      message: i == 3 ? '100% <wrong>,\nsee `a|b` and `<b>`.' : 'Finding $i.',
      path: i == 0 ? null : 'ios/Runner/File$i.plist',
      line: i.isEven && i > 0 ? i : null,
    ),
];

Finding _plist(String rule, Severity severity, String message, [int? line]) =>
    Finding(
      ruleId: rule,
      severity: severity,
      message: message,
      path: 'ios/Runner/Info.plist',
      line: line,
    );

final _four = [
  _plist(
    'purpose-string-missing',
    Severity.warning,
    '`NSMicrophoneUsageDescription` is missing; needed only if you record '
        'video.',
  ),
  _plist(
    'privacy-manifest-present',
    Severity.warning,
    'No privacy manifest at ios/Runner/PrivacyInfo.xcprivacy.',
  ),
  _plist(
    'purpose-string-missing',
    Severity.error,
    '`NSPhotoLibraryUsageDescription` is missing, but image_picker needs it.',
  ),
  _plist(
    'purpose-string-quality',
    Severity.error,
    '`NSCameraUsageDescription` only restates the permission.',
    5,
  ),
];

void _golden(String rendered, String name) => expect(
  rendered.replaceAll(' $packageVersion:', ' <version>:'),
  File('test/goldens/$name').readAsStringSync(),
);

void main() {
  test('markdown without findings', () {
    final ignored = SuppressedFinding(
      _four.first,
      const IgnoreEntry(rule: 'purpose-string-missing', reason: 'No video.'),
    );
    _golden(
      renderMarkdown(_report(const [], suppressed: [ignored])),
      'markdown_0.md',
    );
  });

  test('markdown with 4 findings, most severe first', () {
    _golden(renderMarkdown(_report(_four)), 'markdown_4.md');
  });

  test('markdown lists 50 findings and counts the rest', () {
    _golden(renderMarkdown(_report(_many(52))), 'markdown_52.md');
  });
}
