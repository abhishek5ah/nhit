import 'package:flutter/material.dart';
import 'package:nhit_frontend/features/vendors/models/vendor_list_model.dart';
import 'package:nhit_frontend/common_widgets/custom_table.dart';

class VendorListTable extends StatefulWidget {
  final List<Vendor> vendorData;

  const VendorListTable({super.key, required this.vendorData});

  @override
  State<VendorListTable> createState() => _VendorListTableState();
}

class _VendorListTableState extends State<VendorListTable> {
  late List<Vendor> filteredVendors;
  String searchQuery = '';
  int rowsPerPage = 10;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    filteredVendors = widget.vendorData;
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredVendors = widget.vendorData.where((vendor) {
        return vendor.name.toLowerCase().contains(searchQuery) ||
            vendor.code.toLowerCase().contains(searchQuery) ||
            vendor.beneficiaryName.toLowerCase().contains(searchQuery);
      }).toList();
      currentPage = 0; // reset to first page on new search
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

  void onDeleteVendor(Vendor vendor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete ${vendor.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                widget.vendorData.removeWhere((v) => v.id == vendor.id);
                filteredVendors.removeWhere((v) => v.id == vendor.id);

                // Adjust currentPage if needed
                int totalPages = (filteredVendors.length / rowsPerPage).ceil();
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
    int totalPages = (filteredVendors.length / rowsPerPage).ceil();
    int start = currentPage * rowsPerPage;
    int end = (start + rowsPerPage).clamp(0, filteredVendors.length);
    final paginatedVendors = filteredVendors.sublist(start, end);

    // Calculate pagination window (max 10 pages displayed)
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
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Add Vendor", style: Theme.of(context).textTheme.titleLarge),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add New"),
                onPressed: () {
                  // Implement navigation or dialog for adding new vendor
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

        // Top Controls: Show entries and Search
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
                  hintText: 'Search vendors',
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

        // Table with paginated vendors
        Expanded(
          child: CustomTable(
            minTableWidth: 1100,
            columns: const [
              DataColumn(label: SizedBox(width: 50, child: Text('ID', overflow: TextOverflow.ellipsis, softWrap: false))),
              DataColumn(label: SizedBox(width: 80, child: Text('Code', overflow: TextOverflow.ellipsis, softWrap: false))),
              DataColumn(label: SizedBox(width: 200, child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Mobile')),
              DataColumn(label: SizedBox(width: 200, child: Text('Beneficiary Name'))),
              DataColumn(label: SizedBox(width: 100, child: Text('Status'))),
              DataColumn(label: SizedBox(width: 110, child: Text('Action'))),
            ],
            rows: paginatedVendors.map((vendor) {
              return DataRow(
                cells: [
                  DataCell(SizedBox(width: 50, child: Text(vendor.id.toString(), overflow: TextOverflow.ellipsis, softWrap: false))),
                  DataCell(SizedBox(width: 80, child: Text(vendor.code, overflow: TextOverflow.ellipsis, softWrap: false))),
                  DataCell(SizedBox(width: 200, child: Text(vendor.name, overflow: TextOverflow.ellipsis, softWrap: false))),
                  DataCell(Text(vendor.email, overflow: TextOverflow.ellipsis, softWrap: false)),
                  DataCell(Text(vendor.mobile, overflow: TextOverflow.ellipsis, softWrap: false)),
                  DataCell(SizedBox(width: 200, child: Text(vendor.beneficiaryName, overflow: TextOverflow.ellipsis, softWrap: false))),
                  DataCell(Container(
                    decoration: BoxDecoration(
                      color: vendor.status == 'Approved' ? Colors.green : Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Text(
                      vendor.status,
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
                            icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
                            onPressed: () {
                              // Implement edit action here
                            },
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            icon: Icon(Icons.remove_red_eye, color: Theme.of(context).colorScheme.primary),
                            onPressed: () {
                              // Implement view action here
                            },
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                            onPressed: () => onDeleteVendor(vendor),
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

        // Pagination controls
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Showing ${filteredVendors.isEmpty ? 0 : start + 1} to $end of ${filteredVendors.length} entries",
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
                      padding: const EdgeInsets.symmetric(horizontal: 2),
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
                        onPressed: () => gotoPage(i),
                        child: Text('${i + 1}'),
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
