import 'package:flutter/material.dart';
import 'package:nhit_frontend/common_widgets/custom_table.dart';
import 'package:nhit_frontend/features/activity/model/activity_log_model.dart';

class ActivityLogTable extends StatefulWidget {
  final List<ActivityLog> activityLogs;

  const ActivityLogTable({super.key, required this.activityLogs});

  @override
  State<ActivityLogTable> createState() => _ActivityLogTableState();
}

class _ActivityLogTableState extends State<ActivityLogTable> {
  late List<ActivityLog> filteredLogs;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredLogs = widget.activityLogs;
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredLogs = widget.activityLogs.where((log) {
        return log.name.toLowerCase().contains(searchQuery) ||
            log.description.toLowerCase().contains(searchQuery) ||
            log.timeAgo.toLowerCase().contains(searchQuery) ||
            log.id.toString().contains(searchQuery);
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
              hintText: 'Search activity logs',
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
                label: SizedBox(width: 50, child: Text('ID', overflow: TextOverflow.ellipsis, softWrap: false)),
              ),
              DataColumn(
                label: SizedBox(width: 320, child: Text('Name', overflow: TextOverflow.ellipsis, softWrap: false, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
              ),
              DataColumn(label: SizedBox(width: 220, child: Text('Description'))),
              DataColumn(label: SizedBox(width: 120, child: Text('Time Ago'))),
            ],
            rows: filteredLogs.map((log) {
              return DataRow(
                cells: [
                  DataCell(
                    SizedBox(width: 50, child: Text(log.id.toString(), overflow: TextOverflow.ellipsis, softWrap: false)),
                  ),
                  DataCell(
                    SizedBox(width: 320, child: Text(log.name, overflow: TextOverflow.ellipsis, softWrap: false)),
                  ),
                  DataCell(
                    SizedBox(width: 220, child: Text(log.description, overflow: TextOverflow.ellipsis, softWrap: false)),
                  ),
                  DataCell(
                    SizedBox(width: 120, child: Text(log.timeAgo, overflow: TextOverflow.ellipsis, softWrap: false)),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
