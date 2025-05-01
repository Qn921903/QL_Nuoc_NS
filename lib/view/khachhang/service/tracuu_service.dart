import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tracuu_data_model.dart';

import '../../../System/Constant.dart';
class HoaDonService {
  static Future<ResponseModel?> fetchHoaDon({
    required int thang,
    required int nam,
    required String maHopDong,
    required String tenKhachHang,
  }) async {

    final response = await http.post(
      Uri.https($GetServer,
          "/api/services/app/WebAppServices/TraCuuHoaDonAppServices"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
            "thang": thang,
            "nam": nam,
            "maHopDong": maHopDong,
            "tenKhachHang": tenKhachHang,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ResponseModel.fromJson(data['result']);
    } else {
      // print("API Error: ${response.statusCode}");
      return null;
    }
  }
}
