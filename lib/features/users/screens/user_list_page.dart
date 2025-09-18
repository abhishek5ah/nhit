import 'package:flutter/material.dart';
import 'package:nhit_frontend/core/utils/role_status.dart';
import 'package:nhit_frontend/features/users/models/user_list_model.dart';
import 'package:nhit_frontend/common_widgets/custom_table.dart';

class UserListTable extends StatefulWidget {
  final List<User> userData;

  const UserListTable({super.key, required this.userData});

  @override
  State<UserListTable> createState() => _UserListTableState();
}

class _UserListTableState extends State<UserListTable> {
  late List<User> filteredUsers;
  String searchQuery = '';

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Bar with padding and styling
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search users',
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
            // Inside your build method, update columns as
            columns: const [
              DataColumn(
                label: SizedBox(
                  width: 50,
                  child: Text(
                    'ID',
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
              ),
              DataColumn(
                label: SizedBox(
                  width: 160,
                  child: Text(
                    'Name',
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              DataColumn(label: Text('Username')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Roles')),
              DataColumn(label: Text('Active')), // NEW COLUMN HERE
              DataColumn(label: SizedBox(width: 110, child: Text('Action'))),
            ],

// And inside rows map, add the Active cell after roles cell:
            rows: filteredUsers.map((user) {
              return DataRow(
                cells: [
                  DataCell(
                    SizedBox(
                      width: 50,
                      child: Text(
                        user.id.toString(),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 160,
                      child: Text(
                        user.name,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      user.username,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                  DataCell(
                    Text(
                      user.email,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                  DataCell(
                    Padding(
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
                    ),
                  ),
                  DataCell( // New Active Status Badge Cell
                    Container(
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
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 110,
                      child: Row(
                        children: [
                          Expanded(
                            child: IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () {},
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () {},
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
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
