import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' as analyzer_error;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:fsd_lint/src/models/fsd_structure.dart';

/// FSD 레이어 간 import 규칙을 검사하는 Lint
///
/// 규칙:
/// - 상위 레이어는 하위 레이어만 import 가능
/// - 하위 레이어가 상위 레이어를 import하면 에러
///
/// 레이어 순서 (상위 -> 하위):
/// app > pages > widgets > features > entities > shared
class FsdLayerImportLint extends DartLintRule {
  const FsdLayerImportLint() : super(code: _code);

  static const _code = LintCode(
    name: 'fsd_layer_import',
    problemMessage:
        'Layer "{0}" cannot import from layer "{1}". '
        'Only lower layers can be imported. '
        'Layer hierarchy: app > pages > widgets > features > entities > shared',
    errorSeverity: analyzer_error.DiagnosticSeverity.ERROR,
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

    // package import만 검사 (상대 경로 import는 제외)
    if (!importPath.startsWith('package:')) return;

    // 현재 파일의 경로
    final currentFilePath = resolver.path;

    // 현재 파일의 레이어
    final currentLayer = FsdLayer.fromPath(currentFilePath);
    if (currentLayer == null) return;

    // import된 파일의 레이어
    final importedLayer = FsdLayer.fromPath(importPath);
    if (importedLayer == null) return;

    // 레이어 import 규칙 검사
    if (!currentLayer.canImport(importedLayer)) {
      reporter.atNode(
        node,
        _code,
        arguments: [currentLayer.name, importedLayer.name],
      );
    }
  }
}
