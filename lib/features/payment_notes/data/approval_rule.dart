import 'package:nhit_frontend/features/payment_notes/model/approval_rule_modal.dart';

final List<ApprovalRule> approvalRuleData = [
  ApprovalRule(
    approverLevel: 'Approver 1',
    users: 'Ravi Kant Vij',
    paymentRange: '0 - 250,000',
  ),
  ApprovalRule(
    approverLevel: 'Approver 2',
    users: 'Arun Kumar Jha',
    paymentRange: '0 - 250,000',
  ),
  ApprovalRule(
    approverLevel: 'Approver 1',
    users: 'Ravi Kant Vij',
    paymentRange: '250,000 - 5,000,000',
  ),
  ApprovalRule(
    approverLevel: 'Approver 2',
    users: 'Sunil Kumar',
    paymentRange: '250,000 - 5,000,000',
  ),
  ApprovalRule(
    approverLevel: 'Approver 3',
    users: 'Arun Kumar Jha',
    paymentRange: '250,000 - 5,000,000',
  ),
  ApprovalRule(
    approverLevel: 'Approver 2',
    users: 'Sunil Kumar',
    paymentRange: 'Above 5,000,000',
  ),
  ApprovalRule(
    approverLevel: 'Approver 3',
    users: 'Arun Kumar Jha, Shubhra Bhattacharya',
    paymentRange: 'Above 5,000,000',
  ),
  ApprovalRule(
    approverLevel: 'Approver 4',
    users: 'Rakshit Jain, Mathew George',
    paymentRange: 'Above 5,000,000',
  ),
  ApprovalRule(
    approverLevel: 'Approver 1',
    users: 'Ravi Kant Vij',
    paymentRange: 'Above 5,000,000',
  ),
];
