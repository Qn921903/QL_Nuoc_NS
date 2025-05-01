
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<String?> getTokenFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  String? jsonString = prefs.getString('user_data');

  if (jsonString != null) {
    final Map<String, dynamic> data = jsonDecode(jsonString);
    return data["result"]?["token"];
  }
  return null;
}

Future<int?> getUidFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  String? jsonString = prefs.getString('user_data');

  if (jsonString != null) {
    final Map<String, dynamic> data = jsonDecode(jsonString);
    return data["result"]?["userid"];
  }
  return null;
}

Future<bool?> getStatusFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  String? jsonString = prefs.getString('user_data');

  if (jsonString != null) {
    final Map<String, dynamic> data = jsonDecode(jsonString);
   // print("Kiểu dữ liệu status trong JSON: ${data["result"]?["status"]} - ${data["result"]?["status"].runtimeType}");
    return data["result"]?["status"];
  }
  return null;
}

Future<String?> getAccountFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  String? jsonString = prefs.getString('user_data');

  if (jsonString != null) {
    final Map<String, dynamic> data = jsonDecode(jsonString);
    return data["result"]?["accountName"];
  }
  return null;
}

Future<String?> getPassFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  String? jsonString = prefs.getString('user_data');

  if (jsonString != null) {
    final Map<String, dynamic> data = jsonDecode(jsonString);

    return data["result"]?["passWord"];
  }
  return null;
}
