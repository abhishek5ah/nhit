import 'package:flutter/material.dart';
import 'package:nhit_frontend/core/utils/role_status.dart';
import 'package:nhit_frontend/features/roles/models/role_list_model.dart';
import 'package:nhit_frontend/common_widgets/custom_table.dart';

class RoleListTable extends StatefulWidget {
  final List<Role> roleData;

  const RoleListTable({super.key, required this.roleData});

  @override
  State<RoleListTable> createState() => _RoleListTableState();
}

class _RoleListTableState extends State<RoleListTable> {
  // Filtered list to display
  late List<Role> filteredRoles;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredRoles = widget.roleData;
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredRoles = widget.roleData.where((role) {
        final name = role.roleName.toLowerCase();
        final id = role.id.toString();
        return name.contains(searchQuery) || id.contains(searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search roles',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                // border radius of searchbar
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
                    'Role Name',
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              DataColumn(label: Text('Permissions')),
              DataColumn(label: SizedBox(width: 110, child: Text('Action'))),
            ],
            rows: filteredRoles.map((role) {
              return DataRow(
                cells: [
                  DataCell(
                    SizedBox(
                      width: 50,
                      child: Text(
                        role.id.toString(),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 160,
                      child: Text(
                        role.roleName,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                  ),
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: role.permissions.map((perm) {
                          final colors = getPermissionColors(perm, context);
                          return Badge(
                            backgroundColor: colors.background,
                            label: Text(
                              perm,
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
