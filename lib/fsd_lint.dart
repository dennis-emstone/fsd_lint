import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:fsd_lint/src/lints/fsd_layer_import_lint.dart';
import 'package:fsd_lint/src/lints/fsd_slice_import_lint.dart';

PluginBase createPlugin() => _FsdLintPlugin();

class _FsdLintPlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
    const FsdLayerImportLint(),
    const FsdSliceImportLint(),
  ];
}
