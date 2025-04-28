
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showDialogLog(String title, String content, BuildContext context) {
  if (Platform.isIOS) {
    // Hộp thoại kiểu iOS
    showDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text('Đóng'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  } else {
    // Hộp thoại kiểu Android (Material Design)
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: const Text('Đóng'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }
}