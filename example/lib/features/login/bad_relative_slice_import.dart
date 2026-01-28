// This should trigger fsd_slice_import lint because features cannot import other features directly
import '../payment/payment.dart';

class BadRelativeSliceImport {
  // This class doesn't need to do anything, it just needs the import.
}
