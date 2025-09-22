import 'package:flutter/material.dart';

class EditModal extends StatelessWidget {
  final String title;
  final Widget formContent;
  final VoidCallback? onCancel;
  final VoidCallback? onSave;
  final double width;

  const EditModal({
    super.key,
    required this.title,
    required this.formContent,
    this.onCancel,
    this.onSave,
    this.width = 600,
  });

  static Future<bool?> show(
      BuildContext context, {
        required String title,
        required Widget formContent,
        VoidCallback? onCancel,
        VoidCallback? onSave,
        double width = 600,
      }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.all(24),
        child: SizedBox(
          width: width,
          child: EditModal(
            title: title,
            formContent: formContent,
            onCancel: onCancel,
            onSave: onSave,
            width: width,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  if (onCancel != null) {
                    onCancel!();
                  } else {
                    Navigator.of(context).pop(false);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Form content
          formContent,

          const SizedBox(height: 24),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  if (onCancel != null) {
                    onCancel!();
                  } else {
                    Navigator.of(context).pop(false);
                  }
                },
                child: const Text("Cancel"),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  if (onSave != null) {
                    onSave!();
                  } else {
                    Navigator.of(context).pop(true);
                  }
                },
                child: const Text("Save"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}