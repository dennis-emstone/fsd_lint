import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' as analyzer_error;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:fsd_lint/src/models/fsd_structure.dart';

/// FSD 같은 레이어 내 Slice 간 import 규칙을 검사하는 Lint
///
/// 규칙:
/// - 같은 레이어의 다른 slice를 직접 import 금지
///
/// 예시:
/// ❌ features/server_add -> features/server_list (직접 import 금지)
class FsdSliceImportLint extends DartLintRule {
  const FsdSliceImportLint() : super(code: _code);

  static const _code = LintCode(
    name: 'fsd_slice_import',
    problemMessage:
        'Slice "{0}" cannot directly import from slice "{1}" in the same layer.',
    correctionMessage: 'Move shared functionality to the shared layer.',
    errorSeverity: analyzer_error.DiagnosticSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    DiagnosticReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addImportDirective((node) {
      _checkImport(node, resolver, reporter);
    });
  }

  void _checkImport(
    ImportDirective node,
    CustomLintResolver resolver,
    DiagnosticReporter reporter,
  ) {
    final importPath = node.uri.stringValue;
    if (importPath == null) return;

    // package import만 검사
    if (!importPath.startsWith('package:')) return;

    // 현재 파일의 Slice
    final currentSlice = FsdSlice.fromPath(resolver.path);
    if (currentSlice == null) return;

    // shared 레이어는 검사하지 않음 (공유 코드이므로)
    if (currentSlice.layer == FsdLayer.shared) return;

    // import된 파일의 Slice
    final importedSlice = FsdSlice.fromPath(importPath);
    if (importedSlice == null) return;

    // 같은 레이어의 다른 slice를 import하는지 검사
    if (currentSlice.layer == importedSlice.layer &&
        currentSlice.name != importedSlice.name) {
      reporter.atNode(
        node,
        _code,
        arguments: [currentSlice.toString(), importedSlice.toString()],
      );
    }
  }
}
