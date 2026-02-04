// Flutter imports:
import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final Widget content;
  final void Function()? onDelete;
  final void Function()? onCancel;

  const DeleteConfirmationDialog(
      {super.key, required this.content, this.onDelete, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: content,
      actions: <Widget>[
        TextButton(
          onPressed: () => _handleCancel(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => _handleDelete(context),
          child: const Text('Delete'),
        ),
      ],
    );
  }

  void _handleCancel(BuildContext context) {
    onCancel?.call();
  }

  void _handleDelete(BuildContext context) {
    onDelete?.call();
  }

  static Future<bool> show(BuildContext context, Widget content) async {
    return await showDialog(
          context: context,
          builder: (context) {
            return DeleteConfirmationDialog(
              content: content,
              onDelete: () {
                Navigator.of(context).pop(true);
              },
              onCancel: () {
                Navigator.of(context).pop(false);
              },
            );
          },
        ) ??
        false; // Dialog returns null if dismissed by tapping outside of the dialog
  }
}
