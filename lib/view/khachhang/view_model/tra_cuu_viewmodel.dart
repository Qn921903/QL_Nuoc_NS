import 'package:flutter/material.dart';
import '../service/tracuu_service.dart';
import '../models/tracuu_data_model.dart';

class HoaDonViewModel extends ChangeNotifier {
  ResponseModel? response;
  bool isLoading = false;

  Future<void> getHoaDon({

    required int thang,
    required int nam,
    required String maHopDong,
    required String tenKhachHang,
  }) async {
    isLoading = true;
    notifyListeners();

    response = await HoaDonService.fetchHoaDon(
      
      thang: thang,
      nam: nam,
      maHopDong: maHopDong,
      tenKhachHang: tenKhachHang,
    );

    isLoading = false;
    notifyListeners();
  }
}
