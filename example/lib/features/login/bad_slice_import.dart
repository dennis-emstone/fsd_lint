// This should trigger fsd_slice_import lint because features cannot import other features directly
import 'package:example/features/payment/payment.dart';

class BadSliceImport {
  final Payment payment;
  BadSliceImport(this.payment);
}
