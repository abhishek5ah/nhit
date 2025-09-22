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
  int rowsPerPage = 10;
  int currentPage = 0;

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
      currentPage = 0; // Reset to first page on search change
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

  @override
  Widget build(BuildContext context) {
    int totalPages = (filteredLogs.length / rowsPerPage).ceil();
    int start = currentPage * rowsPerPage;
    int end = (start + rowsPerPage).clamp(0, filteredLogs.length);
    final paginatedLogs = filteredLogs.sublist(start, end);

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
        // Top controls: Show entries and Search
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text("Show", style: Theme.of(context).textTheme.bodyLarge),
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
                  Text("entries", style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
              SizedBox(
                width: 210,
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    hintText: 'Search activity logs',
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

        // Table content
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
            rows: paginatedLogs.map((log) {
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

        // Pagination controls bottom
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Showing ${filteredLogs.isEmpty ? 0 : start + 1} to $end of ${filteredLogs.length} entries",
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
                        child: Text("${i + 1}"),
                        onPressed: () => gotoPage(i),
                      ),
                    ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: currentPage < totalPages - 1 ? () => gotoPage(currentPage + 1) : null,
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
