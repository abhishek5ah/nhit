import 'package:flutter/material.dart';
import 'package:nhit_frontend/common_widgets/custom_table.dart';
import 'package:nhit_frontend/features/activity/model/user_login_history_model.dart';

class UserLoginHistoryTable extends StatefulWidget {
  final List<UserLoginHistory> loginHistoryData;

  const UserLoginHistoryTable({super.key, required this.loginHistoryData});

  @override
  State<UserLoginHistoryTable> createState() => _UserLoginHistoryTableState();
}

class _UserLoginHistoryTableState extends State<UserLoginHistoryTable> {
  late List<UserLoginHistory> filteredLoginHistory;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredLoginHistory = widget.loginHistoryData;
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredLoginHistory = widget.loginHistoryData.where((entry) {
        return entry.user.toLowerCase().contains(searchQuery) ||
            entry.loginAt.toLowerCase().contains(searchQuery) ||
            entry.loginIp.toLowerCase().contains(searchQuery) ||
            entry.userAgent.toLowerCase().contains(searchQuery) ||
            entry.createdAt.toLowerCase().contains(searchQuery) ||
            entry.id.toString().contains(searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search login history',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                  width: 0.25,
                ),
              ),
            ),
            onChanged: updateSearch,
          ),
        ),
        Expanded(
          child: CustomTable(
            minTableWidth: 1100,
            columns: const [
              DataColumn(
                label: SizedBox(
                  width: 50,
                  child: Text('ID', overflow: TextOverflow.ellipsis, softWrap: false),
                ),
              ),
              DataColumn(
                label: SizedBox(
                  width: 160,
                  child: Text('User', overflow: TextOverflow.ellipsis, softWrap: false, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              DataColumn(label: Text('Login At')),
              DataColumn(label: Text('Login IP')),
              DataColumn(label: SizedBox(width: 280, child: Text('User Agent'))),
              DataColumn(label: Text('Created At')),
            ],
            rows: filteredLoginHistory.map((entry) {
              return DataRow(
                cells: [
                  DataCell(SizedBox(width: 50, child: Text(entry.id.toString(), overflow: TextOverflow.ellipsis, softWrap: false))),
                  DataCell(SizedBox(width: 160, child: Text(entry.user, overflow: TextOverflow.ellipsis, softWrap: false))),
                  DataCell(Text(entry.loginAt, overflow: TextOverflow.ellipsis, softWrap: false)),
                  DataCell(Text(entry.loginIp, overflow: TextOverflow.ellipsis, softWrap: false)),
                  DataCell(SizedBox(width: 280, child: Text(entry.userAgent, overflow: TextOverflow.ellipsis, softWrap: false))),
                  DataCell(Text(entry.createdAt, overflow: TextOverflow.ellipsis, softWrap: false)),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
