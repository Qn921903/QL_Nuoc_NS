import 'package:flutter/material.dart';
import '../models/kh_app_model.dart';
import '../service/chitiet_tracuu_service.dart'; // chỉnh đúng đường dẫn service nhé

class ChiTietViewModel extends ChangeNotifier {
  ThanhToanDataDto? chiTietData;
  bool isLoading = false;

  Future<void> fetchChiTiet(int id) async {
    isLoading = true;
    notifyListeners();

    chiTietData = await HoaDonService.fetchChitietHopDong(id: id);

    isLoading = false;
    notifyListeners();
  }
}
