// This should trigger fsd_slice_import lint because features cannot import other features directly
import '../payment/payment.dart';

class BadRelativeSliceImport {
  final Payment payment;

  BadRelativeSliceImport(this.payment);
}
