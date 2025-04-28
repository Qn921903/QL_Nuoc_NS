// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// Future<String?> generateVietQR({
//   required String accountNo,
//   required String accountName,
//   required String acqId, // Mã ngân hàng VietQR (VD: 970415 - Techcombank)
//   required int amount,
//   required String addInfo,
// }) async {
//   const String apiUrl = "https://api.vietqr.io/v2/generate";
//   const String apiKey = "f59c2e96-b4f9-4ad7-9c9a-1e40455861fd"; // Thay bằng API Key của bạn
//
//   final Map<String, dynamic> requestBody = {
//     "accountNo": accountNo,
//     "accountName": accountName,
//     "acqId": acqId,
//     "amount": amount,
//     "addInfo": addInfo,
//     "format": "text", // Trả về URL QR Code
//   };
//
//   final response = await http.post(
//     Uri.parse(apiUrl),
//     headers: {
//       "Content-Type": "application/json",
//       "x-api-key": apiKey, // API Key để xác thực
//     },
//     body: jsonEncode(requestBody),
//   );
//
//   if (response.statusCode == 200) {
//     final Map<String, dynamic> data = jsonDecode(response.body);
//     return data["data"]["qrData"]; // URL ảnh QR Code hoặc chuỗi QR
//   } else {
//     print("Lỗi tạo QR: ${response.body}");
//     return null;
//   }
// }
