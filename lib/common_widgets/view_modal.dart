import 'package:flutter/material.dart';

class DetailModal extends StatelessWidget {
  final String title;
  final List<Widget> contentWidgets;
  final double width;

  const DetailModal({
    super.key,
    required this.title,
    required this.contentWidgets,
    this.width = 500,
  });

  static Future<void> show(BuildContext context, {
    required String title,
    required List<Widget> contentWidgets,
    double width = 500,
    double borderRadius = 18, // You can adjust this value
  }) {
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        insetPadding: EdgeInsets.all(24),
        child: SizedBox(
          width: width,
          child: DetailModal(
            title: title,
            contentWidgets: contentWidgets,
            width: width,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...contentWidgets
              .map((widget) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: widget,
          ))
              .toList(),
        ],
      ),
    );
  }
}
