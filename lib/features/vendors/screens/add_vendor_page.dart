import 'package:flutter/material.dart';
import 'package:nhit_frontend/common_widgets/form_widget.dart';
import 'package:nhit_frontend/common_widgets/primary_button.dart';

final List<FormFieldConfig> addVendorFields = [
  // Left column
  FormFieldConfig(
    label: 'From Account Type',
    type: FormFieldType.dropdown,
    name: 'accountType',
    options: ['Internal', 'External'],
    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
  ),
  FormFieldConfig(
    label: 'Status',
    type: FormFieldType.dropdown,
    name: 'status',
    options: ['Active', 'Inactive'],
    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
  ),
  FormFieldConfig(
    label: 'Vendor Code',
    type: FormFieldType.text,
    name: 'vendorCode',
    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
  ),
  FormFieldConfig(
    label: 'Vendor Mobile',
    type: FormFieldType.text,
    name: 'vendorMobile',
    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
  ),
  FormFieldConfig(
    label: 'State Name',
    type: FormFieldType.text,
    name: 'stateName',
    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
  ),
  FormFieldConfig(
    label: 'Account Number',
    type: FormFieldType.text,
    name: 'accountNumber',
    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
  ),
  FormFieldConfig(
    label: 'Name Of Bank',
    type: FormFieldType.text,
    name: 'bankName',
    validator: (v) {},
  ),
  FormFieldConfig(
    label: 'PAN',
    type: FormFieldType.text,
    name: 'pan',
    validator: (v) {},
  ),
  FormFieldConfig(
    label: 'MSME Classification',
    type: FormFieldType.dropdown,
    name: 'msmeClassification',
    options: ['Micro', 'Small', 'Medium'],
    validator: (v) {},
  ),
  FormFieldConfig(
    label: 'MSME Start Date',
    type: FormFieldType.date,
    name: 'msmeStartDate',
    validator: (v) {},
  ),
  FormFieldConfig(
    label: 'Remarks Address',
    type: FormFieldType.text,
    name: 'remarksAddress',
    validator: (v) {},
  ),
  FormFieldConfig(
    label: 'Short Name',
    type: FormFieldType.text,
    name: 'shortName',
    validator: (v) {},
  ),
  FormFieldConfig(
    label: 'City Name',
    type: FormFieldType.text,
    name: 'cityName',
    validator: (v) {},
  ),
  FormFieldConfig(
    label: 'MSME Registration Number',
    type: FormFieldType.text,
    name: 'msmeRegNumber',
    validator: (v) {},
  ),
  FormFieldConfig(
    label: 'Material Nature',
    type: FormFieldType.text,
    name: 'materialNature',
    validator: (v) {},
  ),
  FormFieldConfig(
    label: 'Common Bank Details',
    type: FormFieldType.text,
    name: 'commonBankDetails',
    validator: (v) {},
  ),


  // Right column
  FormFieldConfig(
    label: 'Project',
    type: FormFieldType.dropdown,
    name: 'project',
    options: ['Select Project', 'Project 1', 'Project 2'],
    validator: (v) {},
  ), // Replace 'Select Project' with actual options
  FormFieldConfig(
    label: 'Vendor Name',
    type: FormFieldType.text,
    name: 'vendorName',
    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
  ),
  FormFieldConfig(
    label: 'Vendor Email',
    type: FormFieldType.text,
    name: 'vendorEmail',
    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
  ),
  FormFieldConfig(
    label: 'Country Name',
    type: FormFieldType.text,
    name: 'countryName',
    validator: (v) {},
  ),
  FormFieldConfig(
    label: 'PIN Code',
    type: FormFieldType.text,
    name: 'pinCode',
    validator: (v) {},
  ),
  FormFieldConfig(
    label: 'Ifsc',
    type: FormFieldType.text,
    name: 'ifsc',
    validator: (v) {},
  ),
  FormFieldConfig(
    label: 'Beneficiary Name',
    type: FormFieldType.text,
    name: 'beneficiaryName',
    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
  ),
  FormFieldConfig(
    label: 'Gstin',
    type: FormFieldType.text,
    name: 'gstin',
    validator: (v) {},
  ),
  FormFieldConfig(
    label: 'Activity Type',
    type: FormFieldType.dropdown,
    name: 'activityType',
    options: ['N/A', 'Service', 'Supply'],
    validator: (v) {},
  ),
  FormFieldConfig(
    label: 'Section 206AB Verified',
    type: FormFieldType.dropdown,
    name: 'section206ABVerified',
    options: ['Yes', 'No'],
    validator: (v) {},
  ),
  FormFieldConfig(
    label: 'Account Name',
    type: FormFieldType.text,
    name: 'accountName',
    validator: (v) {},
  ),
  FormFieldConfig(
    label: 'Parent',
    type: FormFieldType.text,
    name: 'parent',
    validator: (v) {},
  ),
  FormFieldConfig(
    label: 'MSME',
    type: FormFieldType.text,
    name: 'msme',
    validator: (v) {},
  ),
  FormFieldConfig(
    label: 'MSME End Date',
    type: FormFieldType.date,
    name: 'msmeEndDate',
    validator: (v) {},
  ),
  FormFieldConfig(
    label: 'Gst Defaulted',
    type: FormFieldType.text,
    name: 'gstDefaulted',
    validator: (v) {},
  ),
  FormFieldConfig(
    label: 'Income Tax Type',
    type: FormFieldType.text,
    name: 'incomeTaxType',
    validator: (v) {},
  ),

  FormFieldConfig(
    label: 'Attach File',
    type: FormFieldType.file,
    name: 'attachment',
    validator: (v) {
      if (v == null) return 'Required';
      return null;
    },
  ),
];

// Vendor Form Page Widget
class AddVendorPage extends StatelessWidget {
  const AddVendorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReusableForm(
        title: 'Add Vendor',
        fields: addVendorFields,
        onSubmit: (values) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Vendor saved successfully'),
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        submitButtonBuilder: (onPressed) =>
            PrimaryButton(label: 'Save', onPressed: onPressed),
      ),
    );
  }
}
