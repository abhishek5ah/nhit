import 'package:flutter/material.dart';
import 'package:nhit_frontend/common_widgets/form_widget.dart';

final List<FormFieldConfig> addUserFields = [
  FormFieldConfig(label: 'Name', type: FormFieldType.text, name: 'name'),
  FormFieldConfig(label: 'Employee Id', type: FormFieldType.text, name: 'employeeId'),
  FormFieldConfig(label: 'Contact Number', type: FormFieldType.text, name: 'contactNumber'),
  FormFieldConfig(label: 'Username', type: FormFieldType.text, name: 'username'),
  FormFieldConfig(label: 'Active', type: FormFieldType.dropdown, name: 'active', options: ['Active', 'Inactive']),
  FormFieldConfig(label: 'Email Address', type: FormFieldType.text, name: 'email'),
  FormFieldConfig(label: 'Designation', type: FormFieldType.dropdown, name: 'designation', options: ['Manager', 'Developer']),
  FormFieldConfig(label: 'Department', type: FormFieldType.dropdown, name: 'department', options: ['Operations', 'HR & Admin']),
  FormFieldConfig(label: 'Password', type: FormFieldType.password, name: 'password'),
  FormFieldConfig(label: 'Confirm Password', type: FormFieldType.password, name: 'confirmPassword'),
  FormFieldConfig(label: 'Roles', type: FormFieldType.text, name: 'roles'),
  FormFieldConfig(label: 'Add Your Signature', type: FormFieldType.file, name: 'signature'),
  FormFieldConfig(label: 'Name of Account holder', type: FormFieldType.text, name: 'accountHolder'),
  FormFieldConfig(label: 'Bank Name', type: FormFieldType.text, name: 'bankName'),
  FormFieldConfig(label: 'Bank Account', type: FormFieldType.text, name: 'bankAccount'),
  FormFieldConfig(label: 'IFSC', type: FormFieldType.text, name: 'ifsc'),


];

class AddUserPage extends StatelessWidget {
  const AddUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReusableForm(
        title: 'Add User',
        fields: addUserFields,
        onSubmit: (values) {
          // handle form submission
        },
      ),
    );
  }
}

