// This should trigger fsd_layer_import lint because entities cannot import from features
import '../../features/login/login_flow.dart';

class BadRelativeLayerImport {
  final LoginFlow loginFlow;

  BadRelativeLayerImport(this.loginFlow);
}
