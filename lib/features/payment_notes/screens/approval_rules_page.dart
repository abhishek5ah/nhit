import 'package:flutter/material.dart';
import 'package:nhit_frontend/common_widgets/custom_table.dart';
import 'package:nhit_frontend/features/payment_notes/model/approval_rule_modal.dart';

class ApprovalRulesTable extends StatefulWidget {
  final List<ApprovalRule> approvalRules;

  const ApprovalRulesTable({super.key, required this.approvalRules});

  @override
  State<ApprovalRulesTable> createState() => _ApprovalRulesTableState();
}

class _ApprovalRulesTableState extends State<ApprovalRulesTable> {
  late List<ApprovalRule> filteredRules;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredRules = widget.approvalRules;
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredRules = widget.approvalRules.where((rule) {
        return rule.approverLevel.toLowerCase().contains(searchQuery) ||
            rule.users.toLowerCase().contains(searchQuery) ||
            rule.paymentRange.toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            onChanged: updateSearch,
          ),
        ),
        Expanded(
          child: CustomTable(
            minTableWidth: 900,
            columns: const [
              DataColumn(label: Text('Approver Level')),
              DataColumn(label: Text('Users')),
              DataColumn(label: Text('Payment Range')),
              DataColumn(label: Text('Action')),
            ],
            rows: filteredRules.map((rule) {
              return DataRow(
                cells: [
                  DataCell(Text(rule.approverLevel)),
                  DataCell(Text(rule.users)),
                  DataCell(Text(rule.paymentRange)),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {},
                      ),
                      const VerticalDivider(width: 1),
                      IconButton(
                        icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                        onPressed: () {},
                      ),
                    ],
                  )),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
