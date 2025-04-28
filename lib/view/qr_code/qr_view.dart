// // import 'package:flutter/material.dart';
// // import 'package:qly_chi_so_nuoc/view/qr_code/qr_model.dart';
// // import 'package:qr_flutter/qr_flutter.dart';
// //
// // class VietQRScreen extends StatefulWidget {
// //   @override
// //   _VietQRScreenState createState() => _VietQRScreenState();
// // }
// //
// // class _VietQRScreenState extends State<VietQRScreen> {
// //   String? qrCodeData;
// //   int cost = 9000;
// //   late String url;
// //
// //   TextEditingController sotien = TextEditingController();
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     sotien.text == 0 ? url = 'https://api.vietqr.io/image/970418-2152959875-lobJZl3.jpg?accountName=NGUYEN%20TRUNG%20QUY&amount=$cost&addInfo=mammaks':url = 'https://api.vietqr.io/image/970418-2152959875-lobJZl3.jpg?accountName=NGUYEN%20TRUNG%20QUY&amount=${sotien.text}&addInfo=mammaks';
// //     // url = 'https://api.vietqr.io/image/970418-2152959875-lobJZl3.jpg?accountName=NGUYEN%20TRUNG%20QUY&amount=${sotien.text}&addInfo=mammaks';
// //
// //     _fetchQRCode();
// //   }
// //   handleTest(){
// //     print('url: ___---------: $url');
// //     setState(() {});
// //   }
// //
// //   Future<void> _fetchQRCode() async {
// //     String? qrData = await generateVietQR(
// //       accountNo: "123456789",
// //       accountName: "NGUYEN VAN A",
// //       acqId: "970415",
// //       // Techcombank
// //       amount: 10000,
// //       addInfo: "Thanh toan don hang ABC",
// //     );
// //
// //     if (qrData != null) {
// //       setState(() {
// //         qrCodeData = qrData;
// //       });
// //     }
// //   }
// //
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("Thanh toán VietQR")),
// //       // body: Center(
// //       //   child: qrCodeData == null
// //       //       ? CircularProgressIndicator()
// //       //       : QrImageView(
// //       //     data: qrCodeData!,
// //       //     version: QrVersions.auto,
// //       //     size: 200.0,
// //       //   ),
// //       // ),
// //
// //       body: Center(
// //         child: Column(
// //           children: [
// //             Image(
// //               image: NetworkImage(url),
// //             ),
// //             TextField(
// //               controller: sotien,
// //               keyboardType: TextInputType.number,
// //               decoration: InputDecoration(
// //                 labelText: "Số tiền"
// //               ),
// //             ),
// //             ElevatedButton(onPressed: handleTest, child: Text('Test'))
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }import 'package:flutter/material.dart';
// // import 'package:qr_flutter/qr_flutter.dart';
// //
// // class VietQRScreen extends StatefulWidget {
// //   @override
// //   _VietQRScreenState createState() => _VietQRScreenState();
// // }
// //
// // class _VietQRScreenState extends State<VietQRScreen> {
// //   final TextEditingController _amountController = TextEditingController();
// //   String qrData = "https://api.vietqr.io/image/970418-2152959568-lobJZl3.jpg?accountName=NGUYEN%20TRUNG%20QUY&amount=10000&addInfo=mammaks";
// //   int amount = 10000;  // Số tiền mặc định
// //
// //   void _updateQRCode() {
// //     int? newAmount = int.tryParse(_amountController.text);
// //     if (newAmount == null || newAmount <= 0) {
// //       _showErrorDialog("Vui lòng nhập số tiền hợp lệ (lớn hơn 0).");
// //       return;
// //     }
// //
// //     setState(() {
// //       amount = newAmount;
// //       qrData = "https://api.vietqr.io/image/970418-2152959568-lobJZl3.jpg?accountName=NGUYEN%20TRUNG%20QUY&amount=$amount&addInfo=mammaks";
// //     });
// //   }
// //
// //   void _showErrorDialog(String message) {
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: const Text("Lỗi nhập liệu"),
// //         content: Text(message),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text("OK"),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("Thanh toán VietQR")),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             TextField(
// //               controller: _amountController,
// //               keyboardType: TextInputType.number,
// //               decoration: const InputDecoration(
// //                 labelText: 'Nhập số tiền',
// //                 border: OutlineInputBorder(),
// //               ),
// //             ),
// //             const SizedBox(height: 20),
// //             ElevatedButton(
// //               onPressed: _updateQRCode,
// //               child: const Text("Tạo mã QR"),
// //             ),
// //             const SizedBox(height: 20),
// //             QrImage(
// //               data: qrData,
// //               size: 200,
// //               backgroundColor: Colors.white,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
//
//
//
//
//
//
// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';
//
// class VietQRScreen extends StatefulWidget {
//   @override
//   _VietQRScreenState createState() => _VietQRScreenState();
// }
//
// class _VietQRScreenState extends State<VietQRScreen> {
//   final TextEditingController _amountController = TextEditingController();
//   String qrData = "https://api.vietqr.io/image/970418-2152959875-lobJZl3.jpg?accountName=NGUYEN%20TRUNG%20QUY&amount=10000&addInfo=mammaks";
//   int amount = 10000;  // Số tiền mặc định
//
//   void _updateQRCode() {
//     int? newAmount = int.tryParse(_amountController.text);
//     if (newAmount == null || newAmount <= 0) {
//       _showErrorDialog("Vui lòng nhập số tiền hợp lệ (lớn hơn 0).");
//       return;
//     }
//
//     setState(() {
//       amount = newAmount;
//       qrData = "https://api.vietqr.io/image/970418-2152959875-lobJZl3.jpg?accountName=NGUYEN%20TRUNG%20QUY&amount=$amount&addInfo=mammaks";
//     });
//   }
//
//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Lỗi nhập liệu"),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // TextField(
//             //   controller: _amountController,
//             //   keyboardType: TextInputType.number,
//             //   decoration: const InputDecoration(
//             //     labelText: 'Nhập số tiền',
//             //     border: OutlineInputBorder(),
//             //   ),
//             // ),
//             // const SizedBox(height: 20),
//             // ElevatedButton(
//             //   onPressed: _updateQRCode,
//             //   child: const Text("Tạo mã QR"),
//             // ),
//             // const SizedBox(height: 20),
//             Image.network(qrData),
//           ],
//         ),
//
//     );
//   }
// }
//
