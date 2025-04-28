import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeScreen extends StatefulWidget {
  final dynamic qrString;
   QRCodeScreen({super.key, required this.qrString});

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hiển thị mã QR
            QrImageView(
              data:  widget.qrString, // Xoá hết khoảng trắng
              version: QrVersions.auto,
              size: 250.0,
              gapless: false,
              errorStateBuilder: (context, error) {
                return const Text(
                  'Lỗi khi tạo mã QR!',
                  style: TextStyle(color: Colors.red),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}