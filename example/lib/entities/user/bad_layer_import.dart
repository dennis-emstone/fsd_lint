// This should trigger fsd_layer_import lint because entities cannot import features
import 'package:example/features/login/login_flow.dart';

class BadLayerImport {
  final LoginFlow loginFlow;
  BadLayerImport(this.loginFlow);
}
