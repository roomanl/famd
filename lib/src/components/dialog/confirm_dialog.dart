import 'package:famd/src/locale/locale.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onCancel,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: onCancel,
          child: Text(FamdLocale.cancel.tr),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text(FamdLocale.confirm.tr),
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
          title: title ?? FamdLocale.tip.tr,
          content: content ?? FamdLocale.confirm.tr,
          onConfirm: onConfirm,
          onCancel: onCancel,
        );
      });
}
