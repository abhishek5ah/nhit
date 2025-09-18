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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search vendors',
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
            columns: const [
              DataColumn(
                label: SizedBox(width: 50, child: Text('ID', overflow: TextOverflow.ellipsis, softWrap: false)),
              ),
              DataColumn(label: SizedBox(width: 80, child: Text('Code', overflow: TextOverflow.ellipsis, softWrap: false))),
              DataColumn(label: SizedBox(width: 200, child: Text('Name', overflow: TextOverflow.ellipsis, softWrap: false, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Mobile')),
              DataColumn(label: SizedBox(width: 200, child: Text('Beneficiary Name'))),
              DataColumn(label: SizedBox(width: 100, child: Text('Status'))),
              DataColumn(label: SizedBox(width: 110, child: Text('Action'))),
            ],
            rows: filteredVendors.map((vendor) {
              return DataRow(
                cells: [
                  DataCell(SizedBox(width: 50, child: Text(vendor.id.toString(), overflow: TextOverflow.ellipsis, softWrap: false))),
                  DataCell(SizedBox(width: 80, child: Text(vendor.code, overflow: TextOverflow.ellipsis, softWrap: false))),
                  DataCell(SizedBox(width: 200, child: Text(vendor.name, overflow: TextOverflow.ellipsis, softWrap: false))),
                  DataCell(Text(vendor.email, overflow: TextOverflow.ellipsis, softWrap: false)),
                  DataCell(Text(vendor.mobile, overflow: TextOverflow.ellipsis, softWrap: false)),
                  DataCell(SizedBox(width: 200, child: Text(vendor.beneficiaryName, overflow: TextOverflow.ellipsis, softWrap: false))),
                  DataCell(
                    Container(
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
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 110,
                      child: Row(
                        children: [
                          Expanded(
                            child: IconButton(
                              icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
                              onPressed: () {},
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              icon: Icon(Icons.remove_red_eye, color: Theme.of(context).colorScheme.primary),
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
