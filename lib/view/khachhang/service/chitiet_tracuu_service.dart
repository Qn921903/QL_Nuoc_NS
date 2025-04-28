import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/kh_app_model.dart';
import '../../../System/Constant.dart';
class HoaDonService {
  static Future<ThanhToanDataDto?> fetchChitietHopDong({
    required int id,

  }) async {

    final response = await http.post(
      Uri.https($GetServer,
          "/api/services/app/WebAppServices/GeneratorAppServices"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "id": id,

      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ThanhToanDataDto.fromJson(data['result']);
    } else {
      print("API Error: ${response.statusCode}");
      return null;
    }
  }
}
