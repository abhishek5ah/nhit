import 'package:flutter/material.dart';
import 'package:nhit_frontend/features/payment_notes/model/payment_note_model.dart';
import 'package:nhit_frontend/common_widgets/custom_table.dart';

class PaymentNotesTable extends StatefulWidget {
  final List<PaymentNote> paymentNotes;

  const PaymentNotesTable({super.key, required this.paymentNotes});

  @override
  State<PaymentNotesTable> createState() => _PaymentNotesTableState();
}

class _PaymentNotesTableState extends State<PaymentNotesTable> {
  List<PaymentNote> filteredNotes = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredNotes = widget.paymentNotes;
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredNotes = widget.paymentNotes.where((note) {
        return note.projectName.toLowerCase().contains(searchQuery) ||
            note.vendorName.toLowerCase().contains(searchQuery) ||
            note.invoiceValue.toLowerCase().contains(searchQuery) ||
            note.date.toLowerCase().contains(searchQuery) ||
            note.status.toLowerCase().contains(searchQuery) ||
            note.nextApprover.toLowerCase().contains(searchQuery);
      }).toList();
    });
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
            minTableWidth: 1100,
            columns: const [
              DataColumn(label: SizedBox(width: 50, child: Text('S no.'))),
              DataColumn(label: Text('Project Name')),
              DataColumn(label: Text('Vendor Name')),
              DataColumn(label: Text('Invoice Value')),
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Action')),
            ],
            rows: filteredNotes.map((note) {
              return DataRow(
                cells: [
                  DataCell(Text(note.sno.toString())),
                  DataCell(Text(note.projectName)),
                  DataCell(Text(note.vendorName)),
                  DataCell(Text(note.invoiceValue)),
                  DataCell(Text(note.date)),
                  DataCell(Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        child: Text(
                          note.status,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Next Approver: ${note.nextApprover}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  )),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                        onPressed: () {},
                      ),
                      const VerticalDivider(width: 1),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {},
                      ),
                    ],
                  )),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
