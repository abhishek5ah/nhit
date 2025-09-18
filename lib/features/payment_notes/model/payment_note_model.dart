class PaymentNote {
  final int sno;
  final String projectName;
  final String vendorName;
  final String invoiceValue;
  final String date;
  final String status;
  final String nextApprover;

  PaymentNote({
    required this.sno,
    required this.projectName,
    required this.vendorName,
    required this.invoiceValue,
    required this.date,
    required this.status,
    required this.nextApprover,
  });
}
