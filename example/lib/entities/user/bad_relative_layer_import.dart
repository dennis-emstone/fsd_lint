// This should trigger fsd_layer_import lint because entities cannot import from features
import '../../features/login/login_flow.dart';

class BadRelativeLayerImport {
  // This class doesn't need to do anything, it just needs the import.
}
