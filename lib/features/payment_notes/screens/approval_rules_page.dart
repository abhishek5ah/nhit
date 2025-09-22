import 'package:flutter/material.dart';
import 'package:nhit_frontend/features/payment_notes/model/approval_rule_modal.dart';
import 'package:nhit_frontend/common_widgets/custom_table.dart';
import 'package:nhit_frontend/common_widgets/edit_modal.dart';

class ApprovalRulesTable extends StatefulWidget {
  final List<ApprovalRule> approvalRuleData;

  const ApprovalRulesTable({super.key, required this.approvalRuleData});

  @override
  State<ApprovalRulesTable> createState() => _ApprovalRulesTableState();
}

class _ApprovalRulesTableState extends State<ApprovalRulesTable> {
  late List<ApprovalRule> filteredRules;
  String searchQuery = '';
  int rowsPerPage = 10;
  int currentPage = 0;

  late TextEditingController approverLevelController;
  late TextEditingController usersController;
  late TextEditingController paymentRangeController;
  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    filteredRules = widget.approvalRuleData;
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredRules = widget.approvalRuleData.where((rule) {
        return rule.approverLevel.toLowerCase().contains(searchQuery) ||
            rule.users.toLowerCase().contains(searchQuery) ||
            rule.paymentRange.toLowerCase().contains(searchQuery);
      }).toList();
      currentPage = 0; // Reset pagination on search
    });
  }

  void changeRowsPerPage(int? value) {
    setState(() {
      rowsPerPage = value ?? 10;
      currentPage = 0;
    });
  }

  void gotoPage(int page) {
    setState(() {
      currentPage = page;
    });
  }

  void onDeleteRule(ApprovalRule rule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete ${rule.approverLevel} rule?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                widget.approvalRuleData.remove(rule);
                filteredRules.remove(rule);
                int totalPages = (filteredRules.length / rowsPerPage).ceil();
                if (currentPage >= totalPages && currentPage > 0) {
                  currentPage = totalPages - 1;
                }
              });
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void onEditRule(ApprovalRule rule) {
    formKey = GlobalKey<FormState>();
    approverLevelController = TextEditingController(text: rule.approverLevel);
    usersController = TextEditingController(text: rule.users);
    paymentRangeController = TextEditingController(text: rule.paymentRange);

    Future<void> disposeControllers() async {
      await Future.delayed(const Duration(milliseconds: 200));
      approverLevelController.dispose();
      usersController.dispose();
      paymentRangeController.dispose();
    }

    EditModal.show(
      context,
      title: "Edit Approval Rule",
      formContent: StatefulBuilder(
        builder: (context, setState) {
          return Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: approverLevelController,
                  decoration: const InputDecoration(labelText: "Approver Level"),
                  validator: (val) => val == null || val.isEmpty ? "Enter approver level" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: usersController,
                  decoration: const InputDecoration(labelText: "Users"),
                  validator: (val) => val == null || val.isEmpty ? "Enter users" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: paymentRangeController,
                  decoration: const InputDecoration(labelText: "Payment Range"),
                  validator: (val) => val == null || val.isEmpty ? "Enter payment range" : null,
                ),
              ],
            ),
          );
        },
      ),
    ).then((result) {
      if (result == true) {
        if (formKey.currentState?.validate() == true) {
          setState(() {
            final index = widget.approvalRuleData.indexOf(rule);
            if (index != -1) {
              widget.approvalRuleData[index] = rule.copyWith(
                approverLevel: approverLevelController.text,
                users: usersController.text,
                paymentRange: paymentRangeController.text,
              );
              filteredRules = widget.approvalRuleData;
            }
          });
        }
      }
      disposeControllers();
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (filteredRules.length / rowsPerPage).ceil();
    int start = currentPage * rowsPerPage;
    int end = (start + rowsPerPage).clamp(0, filteredRules.length);
    final paginatedRules = filteredRules.sublist(start, end);

    int windowSize = 10;
    int startWindow = 0;
    int endWindow = totalPages;

    if (totalPages > windowSize) {
      if (currentPage <= 4) {
        startWindow = 0;
        endWindow = windowSize;
      } else if (currentPage >= totalPages - 5) {
        startWindow = totalPages - windowSize;
        endWindow = totalPages;
      } else {
        startWindow = currentPage - 4;
        endWindow = currentPage + 6;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Approval Rules",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('Show', style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(width: 8),
                  DropdownButton<int>(
                    value: rowsPerPage,
                    items: [5, 10, 20, 50].map((count) {
                      return DropdownMenuItem<int>(
                        value: count,
                        child: Text('$count'),
                      );
                    }).toList(),
                    onChanged: changeRowsPerPage,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(width: 8),
                  Text('entries', style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
              SizedBox(
                width: 250,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search approval rules',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                        width: 0.25,
                      ),
                    ),
                    isDense: true,
                  ),
                  onChanged: updateSearch,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        Expanded(
          child: CustomTable(
            minTableWidth: 800,
            columns: const [
              DataColumn(label: Text('Approver Level')),
              DataColumn(label: Text('Users')),
              DataColumn(label: Text('Payment Range')),
              DataColumn(label: SizedBox(width: 110, child: Text('Action'))),
            ],
            rows: paginatedRules.map((rule) {
              return DataRow(cells: [
                DataCell(Text(rule.approverLevel)),
                DataCell(Text(rule.users)),
                DataCell(Text(rule.paymentRange)),
                DataCell(Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => onEditRule(rule),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => onDeleteRule(rule),
                    ),
                  ],
                )),
              ]);
            }).toList(),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Showing ${filteredRules.isEmpty ? 0 : start + 1} to $end of ${filteredRules.length} entries',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: currentPage > 0 ? () => gotoPage(currentPage - 1) : null,
                  ),
                  for (int i = startWindow; i < endWindow; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: i == currentPage
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.surfaceContainerLow,
                          foregroundColor: i == currentPage
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurface,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          minimumSize: const Size(0, 36),
                        ),
                        child: Text('${i + 1}'),
                        onPressed: () => gotoPage(i),
                      ),
                    ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: currentPage < totalPages - 1
                        ? () => gotoPage(currentPage + 1)
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
