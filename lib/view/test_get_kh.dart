import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';


class QRCodeScreen extends StatelessWidget {
  const QRCodeScreen({super.key});

  // Chuỗi qrCode bạn cung cấp

  final String qrCodeDatas =
      '00020101021238560010A0000007270126000697041501121188570666660208QRIBFTTA530370454061613645802VN62280824TBR 66 TT-TIEN-NUOC-20256304697E';

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hiển thị mã QR
            QrImageView(
              data: qrCodeDatas,
              version: QrVersions.auto,
              size: 200.0,
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