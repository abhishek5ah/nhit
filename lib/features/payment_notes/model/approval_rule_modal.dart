class ApprovalRule {
  final String approverLevel;
  final String users;
  final String paymentRange;

  ApprovalRule({
    required this.approverLevel,
    required this.users,
    required this.paymentRange,
  });

  ApprovalRule copyWith({
    String? approverLevel,
    String? users,
    String? paymentRange,
  }) {
    return ApprovalRule(
      approverLevel: approverLevel ?? this.approverLevel,
      users: users ?? this.users,
      paymentRange: paymentRange ?? this.paymentRange,
    );
  }
}
