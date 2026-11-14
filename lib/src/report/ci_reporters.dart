import '../engine.dart';
import '../finding.dart';
import '../version.dart';
import 'paths.dart';
import 'text_reporter.dart';

const _maxRows = 50;
const _symbols = ['✗', '⚠', 'ℹ'];

// GitHub drops `<tag>` outside code spans as HTML; indented lines are code.
String _escape(String line) => [
  for (final (i, part) in line.split('`').indexed)
    i.isEven ? part.replaceAll('<', r'\<') : part,
].join('`');

String _markdown(String text) {
  final out = <String>[];
  var code = false;
  for (final line in text.split('\n')) {
    final indented = line.startsWith(' ');
    if (indented != code) out.add('```');
    code = indented;
    out.add(code ? line : _escape(line));
  }
  if (code) out.add('```');
  return out.join('\n');
}

/// Renders the report as GitHub-flavoured Markdown for a job summary
/// (`$GITHUB_STEP_SUMMARY`) or a pull request comment: a status heading, the
/// first 50 findings by severity, and why and how to fix each rule found.
String renderMarkdown(PreflightReport report, {String pathPrefix = ''}) {
  final out = StringBuffer();
  final checked = [
    '${plural(report.rules.length, 'rule')} checked',
    if (report.suppressed.isNotEmpty)
      '${report.suppressed.length} suppressed (reason in the report)',
    if (report.disabled.isNotEmpty)
      '${plural(report.disabled.length, 'rule')} disabled',
  ].join(', ');
  final tool = '$packageName $packageVersion';
  if (report.findings.isEmpty) {
    out
      ..writeln('### ✓ $tool: no findings')
      ..writeln('$checked. Rules and sources: `$packageName --list-rules`.');
    return out.toString();
  }
  final status = switch ((report.failOn, report.failed)) {
    (null, _) => 'Not failing on findings (`--fail-on never`)',
    (final s?, true) => 'Failing on findings at or above `${s.name}`',
    (final s?, false) => 'Not failing: no finding at or above `${s.name}`',
  };
  out
    ..writeln(
      '### ${report.failed ? '✗' : '⚠'} $tool: ${severityCounts(report)}',
    )
    ..writeln()
    ..writeln('$status. $checked.')
    ..writeln()
    ..writeln('| | Rule | Where | Finding |')
    ..writeln('|---|---|---|---|');
  String cell(String s) =>
      _escape(s).replaceAll('|', r'\|').replaceAll('\n', ' ');
  final sorted = [
    for (final s in Severity.values)
      ...report.findings.where((f) => f.severity == s),
  ];
  for (final f in sorted.take(_maxRows)) {
    // Findings without a file point at pubspec.yaml, as in SARIF.
    final path = displayPath(pathPrefix, f.path ?? 'pubspec.yaml');
    final where = f.line == null ? path : '$path:${f.line}';
    out.writeln(
      '| ${_symbols[f.severity.index]} ${f.severity.name} | `${cell(f.ruleId)}` '
      '| `${cell(where)}` | ${cell(f.message)} |',
    );
  }
  if (sorted.length > _maxRows) {
    out
      ..writeln()
      ..writeln(
        '… ${sorted.length - _maxRows} more: '
        'see the job log or the JSON artifact',
      );
  }
  out
    ..writeln()
    ..writeln(
      '<details><summary>Why these matter and how to fix them</summary>',
    )
    ..writeln();
  for (final id in {for (final f in sorted) f.ruleId}) {
    final rule = report.ruleById(id);
    if (rule == null) continue;
    out
      ..writeln('**`$id`** — ${_escape(rule.title)}')
      ..writeln()
      ..writeln(_markdown('Why: ${rule.why}'))
      ..writeln()
      ..writeln(_markdown('Fix: ${rule.fix}'))
      ..writeln();
    if (rule.docs.isNotEmpty) {
      out
        ..writeln('Docs: <${rule.docs.first}>')
        ..writeln();
    }
  }
  out
    ..writeln('</details>')
    ..writeln()
    ..writeln(
      'Full report: `$packageName-report` artifact (JSON). Explain a rule: '
      '`$packageName --explain <rule>`. Exit code: ${report.failed ? 1 : 0}.',
    );
  return out.toString();
}
