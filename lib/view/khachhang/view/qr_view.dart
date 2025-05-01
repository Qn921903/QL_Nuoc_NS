

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';

class QRCodeScreen extends StatefulWidget {
  final dynamic qrString;
  final GlobalKey repaintKey;
  const QRCodeScreen({super.key, required this.qrString, required this.repaintKey});

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: widget.repaintKey,
      child: QrImageView(
        data: widget.qrString,
        version: QrVersions.auto,
        size: 200.0,
        gapless: false,
        backgroundColor: Colors.white,
        errorStateBuilder: (context, error) {
          return const Text(
            'Lỗi khi tạo mã QR!',
            style: TextStyle(color: Colors.red),
          );
        },
      ),
    );
  }
}
