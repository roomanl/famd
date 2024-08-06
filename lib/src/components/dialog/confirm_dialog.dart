import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: onCancel,
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: onConfirm,
          child: const Text('确定'),
        ),
      ],
    );
  }
}

showConfirmDialog(
    {required BuildContext context,
    String? title,
    String? content,
    required VoidCallback onConfirm,
    required VoidCallback onCancel}) async {
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          title: title ?? "提示",
          content: content ?? "确定",
          onConfirm: onConfirm,
          onCancel: onCancel,
        );
      });
}
