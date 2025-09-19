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
  late List<PaymentNote> filteredNotes;
  String searchQuery = '';
  int rowsPerPage = 10;
  int currentPage = 0;

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
      currentPage = 0; // Reset page when searching
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

  void onDeleteNote(PaymentNote note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete invoice no. ${note.sno}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                widget.paymentNotes.removeWhere((n) => n.sno == note.sno);
                filteredNotes.removeWhere((n) => n.sno == note.sno);
                int totalPages = (filteredNotes.length / rowsPerPage).ceil();
                if (currentPage >= totalPages && currentPage > 0) {
                  currentPage = totalPages - 1;
                }
              });
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (filteredNotes.length / rowsPerPage).ceil();
    int start = currentPage * rowsPerPage;
    int end = (start + rowsPerPage).clamp(0, filteredNotes.length);
    final paginatedNotes = filteredNotes.sublist(start, end);

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
                "All Payment Notes",
                style: Theme.of(context).textTheme.titleLarge,
              ),

            ],
          ),
        ),

        // Top controls: Show entries and Search bar
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('Show', style: Theme.of(context).textTheme.bodyLarge),
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
                  Text('entries', style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
              SizedBox(
                width: 250,
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    hintText: 'Search payment notes',
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
              DataColumn(label: SizedBox(width: 50, child: Text('S no.'))),
              DataColumn(label: Text('Project Name')),
              DataColumn(label: Text('Vendor Name')),
              DataColumn(label: Text('Invoice Value')),
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Action')),
            ],
            rows: paginatedNotes.map((note) {
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
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Next Approver: ${note.nextApprover}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  )),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                        onPressed: () {
                          // Implement view action here
                        },
                      ),
                      const VerticalDivider(width: 1),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => onDeleteNote(note),
                      ),
                    ],
                  )),
                ],
              );
            }).toList(),
          ),
        ),

        // Pagination controls bottom
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Showing ${filteredNotes.isEmpty ? 0 : start + 1} to $end of ${filteredNotes.length} entries',
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
                        child: Text('${i + 1}'),
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
