import 'package:flutter/material.dart';
import 'package:nhit_frontend/features/designation/model/designation_model.dart';
import 'package:nhit_frontend/common_widgets/custom_table.dart';
import 'package:nhit_frontend/common_widgets/edit_modal.dart';

class DesignationTable extends StatefulWidget {
  final List<Designation> designationData;

  const DesignationTable({super.key, required this.designationData});

  @override
  State<DesignationTable> createState() => _DesignationTableState();
}

class _DesignationTableState extends State<DesignationTable> {
  late List<Designation> filteredDesignations;
  String searchQuery = '';
  int rowsPerPage = 10;
  int currentPage = 0;

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    filteredDesignations = widget.designationData;
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredDesignations = widget.designationData.where((designation) {
        return designation.name.toLowerCase().contains(searchQuery) ||
            designation.description.toLowerCase().contains(searchQuery) ||
            designation.id.toString().contains(searchQuery);
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

  void onDeleteDesignation(Designation designation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete ${designation.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                widget.designationData.removeWhere((d) => d.id == designation.id);
                filteredDesignations.removeWhere((d) => d.id == designation.id);
                int totalPages = (filteredDesignations.length / rowsPerPage).ceil();
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

  void onEditDesignation(Designation designation) {
    formKey = GlobalKey<FormState>();
    nameController = TextEditingController(text: designation.name);
    descriptionController = TextEditingController(text: designation.description);

    Future<void> disposeControllers() async {
      await Future.delayed(const Duration(milliseconds: 200));
      nameController.dispose();
      descriptionController.dispose();
    }

    EditModal.show(
      context,
      title: "Edit Designation",
      formContent: StatefulBuilder(
        builder: (context, setState) {
          return Form(
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
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                  validator: (val) => val == null || val.isEmpty ? "Enter description" : null,
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
            final index = widget.designationData.indexWhere((d) => d.id == designation.id);
            if (index != -1) {
              widget.designationData[index] = designation.copyWith(
                name: nameController.text,
                description: descriptionController.text,
              );
              filteredDesignations = widget.designationData;
            }
          });
        }
      }
      disposeControllers();
    });
  }

  Widget buildActionIcons(Designation designation) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.edit,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          onPressed: () => onEditDesignation(designation),
          tooltip: "Edit",
        ),
        IconButton(
          icon: Icon(
            Icons.delete,
            color: Theme.of(context).colorScheme.error,
            size: 20,
          ),
          onPressed: () => onDeleteDesignation(designation),
          tooltip: "Delete",
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (filteredDesignations.length / rowsPerPage).ceil();
    int start = currentPage * rowsPerPage;
    int end = (start + rowsPerPage).clamp(0, filteredDesignations.length);
    final paginatedDesignations = filteredDesignations.sublist(start, end);

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
                "All Designation",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
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
                    hintText: 'Search designations',
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

        Expanded(
          child: CustomTable(
            minTableWidth: 700,
            columns: const [
              DataColumn(label: Text('#')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Description')),
              DataColumn(label: Text('Actions')),
            ],
            rows: paginatedDesignations.map((designation) {
              return DataRow(
                cells: [
                  DataCell(Text(designation.id.toString())),
                  DataCell(Text(designation.name)),
                  DataCell(Text(designation.description)),
                  DataCell(buildActionIcons(designation)),
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
                "Showing ${filteredDesignations.isEmpty ? 0 : start + 1} to $end of ${filteredDesignations.length} entries",
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
