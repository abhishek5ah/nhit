import 'package:flutter/material.dart';
import 'package:nhit_frontend/common_widgets/edit_modal.dart';
import 'package:nhit_frontend/core/utils/role_status.dart';
import 'package:nhit_frontend/features/users/models/user_list_model.dart';
import 'package:nhit_frontend/common_widgets/custom_table.dart';
import 'package:nhit_frontend/features/users/screens/add_user_page.dart';
import 'package:nhit_frontend/common_widgets/view_modal.dart';

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

  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late List<String> selectedRoles;
  late bool isActive;
  late GlobalKey<FormState> formKey;

  // Available roles for selection
  final List<String> availableRoles = ['Admin', 'User', 'Manager', 'Editor', 'Viewer'];

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
      currentPage = 0;
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

  //edit modal section
  void onEditUser(User user) {
    formKey = GlobalKey<FormState>();
    nameController = TextEditingController(text: user.name);
    usernameController = TextEditingController(text: user.username);
    emailController = TextEditingController(text: user.email);
    selectedRoles = List.from(user.roles);
    isActive = user.isActive;

    Future<void> disposeControllers() async {
      await Future.delayed(const Duration(milliseconds: 200));
      nameController.dispose();
      usernameController.dispose();
      emailController.dispose();
    }

    EditModal.show(
      context,
      title: "Edit User",
      formContent: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
              validator: (val) => val == null || val.isEmpty ? "Enter name" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: "Username"),
              validator: (val) => val == null || val.isEmpty ? "Enter username" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
              validator: (val) =>
              val == null || !val.contains("@") ? "Enter valid email" : null,
            ),
            const SizedBox(height: 16),

            // Roles Selection
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Roles", style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: availableRoles.map((role) {
                    final isSelected = selectedRoles.contains(role);
                    return FilterChip(
                      label: Text(role),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            if (!selectedRoles.contains(role)) {
                              selectedRoles.add(role);
                            }
                          } else {
                            selectedRoles.remove(role);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Active Status
            Row(
              children: [
                Text("Active Status: ", style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(width: 8),
                Switch(
                  value: isActive,
                  onChanged: (value) {
                    setState(() {
                      isActive = value;
                    });
                  },
                ),
                Text(isActive ? "Active" : "Inactive"),
              ],
            ),
          ],
        ),
      ),
    ).then((result) {
      if (result == true) {
        setState(() {
          final index = widget.userData.indexWhere((u) => u.id == user.id);
          if (index != -1) {
            widget.userData[index] = user.copyWith(
              name: nameController.text,
              username: usernameController.text,
              email: emailController.text,
              roles: selectedRoles,
              isActive: isActive,
            );
            filteredUsers = widget.userData;
          }
        });
      }
      disposeControllers();
    });
  }

  void onViewUser(User user) {
    DetailModal.show(
      context,
      title: "User Details",
      contentWidgets: [
        Text("Name: ${user.name}"),
        Text("Username: ${user.username}"),
        Text("Email: ${user.email}"),
        Text("Roles: ${user.roles.join(', ')}"),
        Text("Status: ${user.isActive ? 'Active' : 'Inactive'}"),
      ],
    );
  }

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
                widget.userData.removeWhere((u) => u.id == user.id);
                filteredUsers.removeWhere((u) => u.id == user.id);
                int totalPages = (filteredUsers.length / rowsPerPage).ceil();
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
    int totalPages = (filteredUsers.length / rowsPerPage).ceil();
    int start = currentPage * rowsPerPage;
    int end = (start + rowsPerPage).clamp(0, filteredUsers.length);
    final paginatedUsers = filteredUsers.sublist(start, end);

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
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
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
                  items: [5, 10, 20, 50]
                      .map((count) => DropdownMenuItem<int>(
                    value: count,
                    child: Text('$count'),
                  ))
                      .toList(),
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
              DataColumn(label: Text('Active')),
              DataColumn(label: SizedBox(width: 110, child: Text('Action'))),
            ],
            rows: paginatedUsers.map((user) {
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
                  DataCell(
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
                "Showing ${filteredUsers.isEmpty ? 0 : start + 1} to $end of ${filteredUsers.length} entries",
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