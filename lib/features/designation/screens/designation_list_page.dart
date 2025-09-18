import 'package:flutter/material.dart';
import 'package:nhit_frontend/features/designation/model/designation_model.dart';
import 'package:nhit_frontend/common_widgets/custom_table.dart';

class DesignationTable extends StatefulWidget {
  final List<Designation> designationData;

  const DesignationTable({super.key, required this.designationData});

  @override
  State<DesignationTable> createState() => _DesignationTableState();
}

class _DesignationTableState extends State<DesignationTable> {
  late List<Designation> filteredDesignations;
  String searchQuery = '';

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
            rows: filteredDesignations.map((designation) {
              return DataRow(
                cells: [
                  DataCell(Text(designation.id.toString())),
                  DataCell(Text(designation.name)),
                  DataCell(Text(designation.description)),
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
