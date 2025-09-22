import 'package:flutter/material.dart';
import 'package:nhit_frontend/common_widgets/edit_modal.dart';
import 'package:nhit_frontend/common_widgets/view_modal.dart';
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
  late List<Role> filteredRoles;
  String searchQuery = '';
  int rowsPerPage = 10;
  int currentPage = 0;

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
      currentPage = 0; // Reset to first page when search changes
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

  void onViewRole(Role role) {
    DetailModal.show(
      context,
      title: 'Role Details',
      contentWidgets: [
        Text("Role Name: ${role.roleName}"),
        Text("Role ID: ${role.id}"),
        const Divider(height: 24),
        Text("Assigned Permissions"),
        Wrap(
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
                  fontSize: 12,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            );
          }).toList(),
        ),
      ],
    );
  }

  void onEditRole(Role role) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String roleName = role.roleName;
    List<String> selectedPermissions = List.from(role.permissions);

    final List<String> availablePermissions = [
      'view-payment',
      'view-rule',
      'edit-note',
      'create-payment',
      'delete-payment',
      'all-note',
      'view-vendors',

      // here we can add more permissions
    ];

    EditModal.show(
      context,
      title: "Edit Role",
      formContent: StatefulBuilder(
        builder: (context, setState) {
          return Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: roleName,
                  decoration: const InputDecoration(labelText: "Role Name"),
                  validator: (val) =>
                  val == null || val.isEmpty ? "Enter role name" : null,
                  onChanged: (val) => roleName = val,
                ),
                const SizedBox(height: 16),
                Text("Permissions", style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: availablePermissions.map((perm) {
                    final isSelected = selectedPermissions.contains(perm);
                    return FilterChip(
                      label: Text(perm),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedPermissions.add(perm);
                          } else {
                            selectedPermissions.remove(perm);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    ).then((result) {
      if (result == true) {
        setState(() {
          final index = widget.roleData.indexWhere((r) => r.id == role.id);
          if (index != -1) {
            widget.roleData[index] = role.copyWith(
              roleName: roleName,
              permissions: selectedPermissions,
            );
            filteredRoles = List.from(widget.roleData);
          }
        });
      }
    });
  }

  void onDeleteRole(Role role) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete ${role.roleName}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                widget.roleData.removeWhere((r) => r.id == role.id);
                filteredRoles.removeWhere((r) => r.id == role.id);

                int totalPages = (filteredRoles.length / rowsPerPage).ceil();
                if (currentPage >= totalPages && currentPage > 0) {
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
    int totalPages = (filteredRoles.length / rowsPerPage).ceil();
    int start = currentPage * rowsPerPage;
    int end = (start + rowsPerPage).clamp(0, filteredRoles.length);
    final paginatedRoles = filteredRoles.sublist(start, end);

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
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Manage Roles", style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ),
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
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  hintText: 'Search roles',
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
        Expanded(
          child: CustomTable(
            minTableWidth: 1100,
            columns: const [
              DataColumn(
                label: SizedBox(
                  width: 50,
                  child:
                  Text('ID', overflow: TextOverflow.ellipsis, softWrap: false),
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
            rows: paginatedRoles.map((role) {
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
                                horizontal: 12, vertical: 5),
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
                              icon: Icon(Icons.edit,
                                  color: Theme.of(context).colorScheme.primary),
                              onPressed: () => onEditRole(role),
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              icon: Icon(Icons.remove_red_eye,
                                  color: Theme.of(context).colorScheme.primary),
                              onPressed: () => onViewRole(role),
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              icon: Icon(Icons.delete,
                                  color: Theme.of(context).colorScheme.error),
                              onPressed: () => onDeleteRole(role),
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Showing ${filteredRoles.isEmpty ? 0 : start + 1} to $end of ${filteredRoles.length} entries",
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          minimumSize: const Size(0, 36),
                        ),
                        child: Text("${i + 1}"),
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

// Role model example with correct copyWith (for your model file)
