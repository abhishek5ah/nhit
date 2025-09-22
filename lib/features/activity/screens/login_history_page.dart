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
  int rowsPerPage = 10;
  int currentPage = 0;

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
      currentPage = 0; // Reset to first page on search
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
    int totalPages = (filteredLoginHistory.length / rowsPerPage).ceil();
    int start = currentPage * rowsPerPage;
    int end = (start + rowsPerPage).clamp(0, filteredLoginHistory.length);
    final paginatedLoginHistory = filteredLoginHistory.sublist(start, end);

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
        // Add heading here
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "User Login History",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),

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
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    hintText: 'Search login history',
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
                label: SizedBox(
                  width: 50,
                  child: Text('ID', overflow: TextOverflow.ellipsis, softWrap: false),
                ),
              ),
              DataColumn(
                label: SizedBox(
                  width: 160,
                  child: Text('User',
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              DataColumn(label: Text('Login At')),
              DataColumn(label: Text('Login IP')),
              DataColumn(label: SizedBox(width: 280, child: Text('User Agent'))),
              DataColumn(label: Text('Created At')),
            ],
            rows: paginatedLoginHistory.map((entry) {
              return DataRow(
                cells: [
                  DataCell(SizedBox(
                      width: 50,
                      child: Text(entry.id.toString(),
                          overflow: TextOverflow.ellipsis, softWrap: false))),
                  DataCell(SizedBox(
                      width: 160,
                      child: Text(entry.user,
                          overflow: TextOverflow.ellipsis, softWrap: false))),
                  DataCell(Text(entry.loginAt,
                      overflow: TextOverflow.ellipsis, softWrap: false)),
                  DataCell(Text(entry.loginIp,
                      overflow: TextOverflow.ellipsis, softWrap: false)),
                  DataCell(SizedBox(
                      width: 280,
                      child: Text(entry.userAgent,
                          overflow: TextOverflow.ellipsis, softWrap: false))),
                  DataCell(Text(entry.createdAt,
                      overflow: TextOverflow.ellipsis, softWrap: false)),
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
                "Showing ${filteredLoginHistory.isEmpty ? 0 : start + 1} to $end of ${filteredLoginHistory.length} entries",
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
                          padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          minimumSize: const Size(0, 36),
                        ),
                        child: Text("${i + 1}"),
                        onPressed: () => gotoPage(i),
                      ),
                    ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed:
                    currentPage < totalPages - 1 ? () => gotoPage(currentPage + 1) : null,
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
