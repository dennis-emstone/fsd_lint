import 'package:example/entities/invoice.dart';

class InvoiceReport {
  final Invoice invoice;

  InvoiceReport(this.invoice);

  void generateReport() {
    print('Report for invoice ${invoice.id}: \$${invoice.amount}');
  }
}
