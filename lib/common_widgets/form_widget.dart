import 'package:flutter/material.dart';

enum FormFieldType { text, password, dropdown, checkbox, file }

class FormFieldConfig {
  final String label;
  final FormFieldType type;
  final String name;
  final String? initialValue;
  final List<String>? options;

  FormFieldConfig({
    required this.label,
    required this.type,
    required this.name,
    this.initialValue,
    this.options,
  });
}

class ReusableForm extends StatefulWidget {
  final String title;
  final List<FormFieldConfig> fields;
  final void Function(Map<String, dynamic> values) onSubmit;

  const ReusableForm({
    super.key,
    required this.title,
    required this.fields,
    required this.onSubmit,
  });

  @override
  State<ReusableForm> createState() => _ReusableFormState();
}

class _ReusableFormState extends State<ReusableForm> {
  late final Map<String, TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = {
      for (var field in widget.fields)
        if (field.type == FormFieldType.text ||
            field.type == FormFieldType.password)
          field.name: TextEditingController(text: field.initialValue ?? ''),
    };
  }

  @override
  void dispose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget buildField(FormFieldConfig field) {
    switch (field.type) {
      case FormFieldType.text:
      case FormFieldType.password:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TextField(
            controller: controllers[field.name],
            obscureText: field.type == FormFieldType.password,
            decoration: InputDecoration(
              labelText: field.label,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        );
      case FormFieldType.dropdown:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            value: field.initialValue ?? (field.options?.first ?? ''),
            items: field.options
                ?.map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
                .toList(),
            onChanged: (_) {},
            decoration: InputDecoration(
              labelText: field.label,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        );
      case FormFieldType.file:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(field.label, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 6),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Choose File"),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "No file chosen",
                    style: TextStyle(fontSize: 13, color: Colors.black45),
                  ),
                ],
              ),
            ],
          ),
        );
      case FormFieldType.checkbox:
        return CheckboxListTile(
          title: Text(field.label),
          value: field.initialValue == 'true',
          onChanged: (_) {},
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;
        List<List<FormFieldConfig>> fieldRows = [];
        final perRow = isWide ? 2 : 1;
        for (var i = 0; i < widget.fields.length; i += perRow) {
          fieldRows.add(widget.fields.sublist(
            i,
            (i + perRow) > widget.fields.length ? widget.fields.length : i + perRow,
          ));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: theme.dividerColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // keep size tight to content
              children: [
                // Title and form fields as before
                Text(widget.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 16),
                ...fieldRows.map((row) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < row.length; i++) ...[
                        Expanded(child: buildField(row[i])),
                        if (i == 0 && row.length == 1 && isWide) const SizedBox(width: 24),
                        if (i == 0 && row.length == 2) const SizedBox(width: 24),
                      ]
                    ],
                  );
                }),
                const SizedBox(height: 18),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                    onPressed: () {
                      // Collect values
                      final Map<String, dynamic> values = {};
                      for (final field in widget.fields) {
                        if (controllers.containsKey(field.name)) {
                          values[field.name] = controllers[field.name]?.text ?? '';
                        }
                      }
                      widget.onSubmit(values);
                    },
                    child: const Text('Save'),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

}