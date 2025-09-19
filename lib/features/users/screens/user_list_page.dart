import 'package:flutter/material.dart';
import 'package:nhit_frontend/core/utils/role_status.dart';
import 'package:nhit_frontend/features/users/models/user_list_model.dart';
import 'package:nhit_frontend/common_widgets/custom_table.dart';
import 'package:nhit_frontend/features/users/screens/add_user_page.dart';

class UserListTable extends StatefulWidget {
  final List<User> userData;

  const UserListTable({super.key, required this.userData});

  @override
  State<UserListTable> createState() => _UserListTableState();
}

class _UserListTableState extends State<UserListTable> {
  late List<User> filteredUsers;
  String searchQuery = '';
  int rowsPerPage = 10;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    filteredUsers = widget.userData;
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredUsers = widget.userData.where((user) {
        final name = user.name.toLowerCase();
        final username = user.username.toLowerCase();
        final email = user.email.toLowerCase();
        return name.contains(searchQuery) ||
            username.contains(searchQuery) ||
            email.contains(searchQuery);
      }).toList();
      currentPage = 0; //pagination current page is reset when we search
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

  void onEditUser(User user) {
    // here we implement user edit dialog
  }

  void onViewUser(User user) {
    // here also we implement user view detail
  }

  //delete the user form the list
  void onDeleteUser(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete ${user.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                // remove user from the original list and filtered list
                widget.userData.removeWhere((u) => u.id == user.id);
                filteredUsers.removeWhere((u) => u.id == user.id);

                // adjust currentPage
                int totalPages = (filteredUsers.length / rowsPerPage).ceil();
                if(currentPage >= totalPages && currentPage > 0) {
                  currentPage = totalPages - 1;
                }
              });
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    int totalPages = (filteredUsers.length / rowsPerPage).ceil();
    int start = currentPage * rowsPerPage;
    int end = (start + rowsPerPage).clamp(0, filteredUsers.length);
    final paginatedUsers = filteredUsers.sublist(start, end);

    // --- Sliding window calculation for pagination buttons ---
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
        // Title and "Add New" Button
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Manage User",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add New"),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AddUserPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Top controls: Show entries and Search
        Row(
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
                  hintText: 'Search users',
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
                  child: Text('Name', overflow: TextOverflow.ellipsis, softWrap: false,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              DataColumn(label: Text('Username')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Roles')),
              DataColumn(label: Text('Active')),
              DataColumn(label: SizedBox(width: 110, child: Text('Action'))),
            ],
            rows: paginatedUsers.map((user) {
              return DataRow(
                cells: [
                  DataCell(SizedBox(
                    width: 50,
                    child: Text(
                      user.id.toString(),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  )),
                  DataCell(SizedBox(
                    width: 160,
                    child: Text(
                      user.name,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  )),
                  DataCell(Text(
                    user.username,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  )),
                  DataCell(Text(
                    user.email,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  )),
                  DataCell(Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: user.roles.map((role) {
                        final colors = getPermissionColors(role, context);
                        return Badge(
                          backgroundColor: colors.background,
                          label: Text(
                            role,
                            style: TextStyle(
                              color: colors.text,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                        );
                      }).toList(),
                    ),
                  )),
                  DataCell(Container(
                    decoration: BoxDecoration(
                      color: user.isActive ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Text(
                      user.isActive ? 'Active' : 'Inactive',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  )),
                  DataCell(SizedBox(
                    width: 110,
                    child: Row(
                      children: [
                        Expanded(
                          child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () => onEditUser(user),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            icon: Icon(
                              Icons.remove_red_eye,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () => onViewUser(user),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            onPressed: () => onDeleteUser(user),
                          ),
                        ),
                      ],
                    ),
                  )),
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
                "Showing ${filteredUsers.isEmpty ? 0 : start + 1} to $end of ${filteredUsers.length} entries",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Row(
                children: [
                  // Previous
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: currentPage > 0 ? () => gotoPage(currentPage - 1) : null,
                  ),
                  // ----- Sliding window for page numbers -----
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
                  // Next
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
