import 'package:flutter/material.dart';
import 'package:nhit_frontend/features/department/model/department_model.dart';
import 'package:nhit_frontend/common_widgets/custom_table.dart';

class DepartmentTable extends StatefulWidget {
  final List<Department> departmentData;

  const DepartmentTable({super.key, required this.departmentData});

  @override
  State<DepartmentTable> createState() => _DepartmentTableState();
}

class _DepartmentTableState extends State<DepartmentTable> {
  late List<Department> filteredDepartments;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredDepartments = widget.departmentData;
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredDepartments = widget.departmentData.where((department) {
        return department.name.toLowerCase().contains(searchQuery) ||
            department.description.toLowerCase().contains(searchQuery) ||
            department.id.toString().contains(searchQuery);
      }).toList();
    });
  }

  Widget buildActionButtons() {
    return Row(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              minimumSize: const Size(48, 32),
              padding: const EdgeInsets.symmetric(horizontal: 10)),
          onPressed: () {},
          child: const Text("Edit"),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              minimumSize: const Size(48, 32),
              padding: const EdgeInsets.symmetric(horizontal: 10)),
          onPressed: () {},
          child: const Text("Delete"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            onChanged: updateSearch,
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
            rows: filteredDepartments.map((department) {
              return DataRow(
                cells: [
                  DataCell(Text(department.id.toString())),
                  DataCell(Text(department.name)),
                  DataCell(Text(department.description)),
                  DataCell(buildActionButtons()),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
