import 'dart:convert';

class ResponseModel {
  final List<ListData> listData;

  ResponseModel({required this.listData});

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      listData: (json['listData'] as List<dynamic>?)
          ?.map((e) => ListData.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'listData': listData.map((e) => e.toJson()).toList(),
    };
  }
}

class ListData {
  final ChiTietThanhToan chiTietThanhToan;
  final HopDong hopDong;

  ListData({required this.chiTietThanhToan, required this.hopDong});

  factory ListData.fromJson(Map<String, dynamic> json) {
    return ListData(
      chiTietThanhToan: ChiTietThanhToan.fromJson(json['chiTietThanhToan'] ?? {}),
      hopDong: HopDong.fromJson(json['hopDong'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chiTietThanhToan': chiTietThanhToan.toJson(),
      'hopDong': hopDong.toJson(),
    };
  }
}

class ChiTietThanhToan {
  final int chiSoCu;
  final int chiSoMoi;
  final int tongSuDung;
  final int truyThu;
  final int heSoTieuThu;
  final int tongThanhTien;
  final List<ThanhTienChiTiet> thanhTienChiTiet;
  final int vat;
  final int status;
  final int nguoiThuId;
  final String tenNguoiThu;
  final int tongThanhTienSauVat;
  final String ghiChu;
  final int messageStatus;
  final bool isCreateInvoice;
  final int thuTu;
  final int paymentType;
  final int phiDuyTriDauNoi;
  final int phiBaoVeMoiTruong;
  final DateTime ngayThu;
  final int dongHoId;
  final int soThanhToanId;
  final int hopDongId;
  final String soHoaDon;
  final String mauHoaDon;
  final String kyHieuHoaDon;
  final DateTime ngayPhatHanhHoaDon;
  final String maBiMat;
  final int trangThaiHoaDon;
  final String transactionUId;
  final String lichSuThu;
  final int stt;
  final int id;

  ChiTietThanhToan({
    required this.chiSoCu,
    required this.chiSoMoi,
    required this.tongSuDung,
    required this.truyThu,
    required this.heSoTieuThu,
    required this.tongThanhTien,
    required this.thanhTienChiTiet,
    required this.vat,
    required this.status,
    required this.nguoiThuId,
    required this.tenNguoiThu,
    required this.tongThanhTienSauVat,
    required this.ghiChu,
    required this.messageStatus,
    required this.isCreateInvoice,
    required this.thuTu,
    required this.paymentType,
    required this.phiDuyTriDauNoi,
    required this.phiBaoVeMoiTruong,
    required this.ngayThu,
    required this.dongHoId,
    required this.soThanhToanId,
    required this.hopDongId,
    required this.soHoaDon,
    required this.mauHoaDon,
    required this.kyHieuHoaDon,
    required this.ngayPhatHanhHoaDon,
    required this.maBiMat,
    required this.trangThaiHoaDon,
    required this.transactionUId,
    required this.lichSuThu,
    required this.stt,
    required this.id,
  });

  factory ChiTietThanhToan.fromJson(Map<String, dynamic> json) {
    return ChiTietThanhToan(
      // chiSoCu: int.tryParse(json['chiSoCu'].toString()) ?? 0,
      chiSoCu: json['chiSoCu']??0,
      chiSoMoi: int.tryParse(json['chiSoMoi'].toString()) ?? 0,
      tongSuDung: int.tryParse(json['tongSuDung'].toString()) ?? 0,
      truyThu: int.tryParse(json['truyThu'].toString()) ?? 0,
      heSoTieuThu: int.tryParse(json['heSoTieuThu'].toString()) ?? 0,
      // tongThanhTien: int.tryParse(json['tongThanhTien'].toString()) ?? 0,
      tongThanhTien: json['tongThanhTien']??001,
      thanhTienChiTiet: (json['thanhTienChiTiet'] as List<dynamic>?)
          ?.map((e) => ThanhTienChiTiet.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      vat: int.tryParse(json['vat'].toString()) ?? 0,
      status: int.tryParse(json['status'].toString()) ?? 0,
      nguoiThuId: int.tryParse(json['nguoiThuId'].toString()) ?? 0,
      tenNguoiThu: json['tenNguoiThu']?.toString() ?? '',
      tongThanhTienSauVat: int.tryParse(json['tongThanhTienSauVat'].toString()) ?? 0,
      ghiChu: json['ghiChu']?.toString() ?? '',
      messageStatus: int.tryParse(json['messageStatus'].toString()) ?? 0,
      isCreateInvoice: json['isCreateInvoice']?.toString() == 'true',
      thuTu: int.tryParse(json['thuTu'].toString()) ?? 0,
      paymentType: int.tryParse(json['paymentType'].toString()) ?? 0,
      phiDuyTriDauNoi: int.tryParse(json['phiDuyTriDauNoi'].toString()) ?? 0,
      phiBaoVeMoiTruong:
      int.tryParse(json['phiBaoVeMoiTruong'].toString()) ?? 0,
      ngayThu: DateTime.tryParse(json['ngayThu']?.toString() ?? '') ??
          DateTime.now(),
      dongHoId: int.tryParse(json['dongHoId'].toString()) ?? 0,
      soThanhToanId: int.tryParse(json['soThanhToanId'].toString()) ?? 0,
      hopDongId: int.tryParse(json['hopDongId'].toString()) ?? 0,
      soHoaDon: json['soHoaDon']?.toString() ?? '',
      mauHoaDon: json['mauHoaDon']?.toString() ?? '',
      kyHieuHoaDon: json['kyHieuHoaDon']?.toString() ?? '',
      ngayPhatHanhHoaDon:
      DateTime.tryParse(json['ngayPhatHanhHoaDon']?.toString() ?? '') ??
          DateTime.now(),
      maBiMat: json['maBiMat']?.toString() ?? '',
      trangThaiHoaDon: int.tryParse(json['trangThaiHoaDon'].toString()) ?? 0,
      transactionUId: json['transactionUId']?.toString() ?? '',
      lichSuThu: json['lichSuThu']?.toString() ?? '',
      stt: int.tryParse(json['stt'].toString()) ?? 0,
      id: int.tryParse(json['id'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chiSoCu': chiSoCu,
      'chiSoMoi': chiSoMoi,
      'tongSuDung': tongSuDung,
      'truyThu': truyThu,
      'heSoTieuThu': heSoTieuThu,
      'tongThanhTien': tongThanhTien,
      'thanhTienChiTiet': thanhTienChiTiet.map((e) => e.toJson()).toList(),
      'vat': vat,
      'status': status,
      'nguoiThuId': nguoiThuId,
      'tenNguoiThu': tenNguoiThu,
      'tongThanhTienSauVat': tongThanhTienSauVat,
      'ghiChu': ghiChu,
      'messageStatus': messageStatus,
      'isCreateInvoice': isCreateInvoice,
      'thuTu': thuTu,
      'paymentType': paymentType,
      'phiDuyTriDauNoi': phiDuyTriDauNoi,
      'phiBaoVeMoiTruong': phiBaoVeMoiTruong,
      'ngayThu': ngayThu.toIso8601String(),
      'dongHoId': dongHoId,
      'soThanhToanId': soThanhToanId,
      'hopDongId': hopDongId,
      'soHoaDon': soHoaDon,
      'mauHoaDon': mauHoaDon,
      'kyHieuHoaDon': kyHieuHoaDon,
      'ngayPhatHanhHoaDon': ngayPhatHanhHoaDon.toIso8601String(),
      'maBiMat': maBiMat,
      'trangThaiHoaDon': trangThaiHoaDon,
      'transactionUId': transactionUId,
      'lichSuThu': lichSuThu,
      'stt': stt,
      'id': id,
    };
  }
}

class ThanhTienChiTiet {
  final int mucDichSuDungId;
  final String mucDichSuDungKyHieu;
  final String mucDichSuDungMoTa;
  final int soLuong;
  final int donGia;
  final int thanhTien;
  final int vat;

  ThanhTienChiTiet({
    required this.mucDichSuDungId,
    required this.mucDichSuDungKyHieu,
    required this.mucDichSuDungMoTa,
    required this.soLuong,
    required this.donGia,
    required this.thanhTien,
    required this.vat,
  });

  factory ThanhTienChiTiet.fromJson(Map<String, dynamic> json) {
    return ThanhTienChiTiet(
      mucDichSuDungId: int.tryParse(json['mucDichSuDungId'].toString()) ?? 0,
      mucDichSuDungKyHieu: json['mucDichSuDungKyHieu']?.toString() ?? '',
      mucDichSuDungMoTa: json['mucDichSuDungMoTa']?.toString() ?? '',
      soLuong: int.tryParse(json['soLuong'].toString()) ?? 0,
      donGia: int.tryParse(json['donGia'].toString()) ?? 0,
      thanhTien: int.tryParse(json['thanhTien'].toString()) ?? 0,
      vat: int.tryParse(json['vat'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mucDichSuDungId': mucDichSuDungId,
      'mucDichSuDungKyHieu': mucDichSuDungKyHieu,
      'mucDichSuDungMoTa': mucDichSuDungMoTa,
      'soLuong': soLuong,
      'donGia': donGia,
      'thanhTien': thanhTien,
      'vat': vat,
    };
  }
}

class HopDong {
  final String maHopDong;
  final String tenKhachHang;
  final String tenThuongGoi;
  final String diaChi;
  final int soHoDungChung;
  final String email;
  final String sdt;
  final String cmnd;
  final DateTime ngayKyHopDong;
  final DateTime ngayLapDat;
  final DateTime ngayNghiemThu;
  final bool haveInHoaDon;
  final String ghiChu;
  final int status;
  final int heSoTieuThu;
  final String mucDichSuDung;
  final int hinhThucThanhToanId;
  final int loaiKhachHangId;
  final int nhaMangId;
  final int id;

  HopDong({
    required this.maHopDong,
    required this.tenKhachHang,
    required this.tenThuongGoi,
    required this.diaChi,
    required this.soHoDungChung,
    required this.email,
    required this.sdt,
    required this.cmnd,
    required this.ngayKyHopDong,
    required this.ngayLapDat,
    required this.ngayNghiemThu,
    required this.haveInHoaDon,
    required this.ghiChu,
    required this.status,
    required this.heSoTieuThu,
    required this.mucDichSuDung,
    required this.hinhThucThanhToanId,
    required this.loaiKhachHangId,
    required this.nhaMangId,
    required this.id,
  });

  factory HopDong.fromJson(Map<String, dynamic> json) {
    return HopDong(
      maHopDong: json['maHopDong']?.toString() ?? '',
      tenKhachHang: json['tenKhachHang']?.toString() ?? '',
      tenThuongGoi: json['tenThuongGoi']?.toString() ?? '',
      diaChi: json['diaChi']?.toString() ?? '',
      soHoDungChung: int.tryParse(json['soHoDungChung'].toString()) ?? 0,
      email: json['email']?.toString() ?? '',
      sdt: json['sdt']?.toString() ?? '',
      cmnd: json['cmnd']?.toString() ?? '',
      ngayKyHopDong:
      DateTime.tryParse(json['ngayKyHopDong']?.toString() ?? '') ??
          DateTime.now(),
      ngayLapDat: DateTime.tryParse(json['ngayLapDat']?.toString() ?? '') ??
          DateTime.now(),
      ngayNghiemThu:
      DateTime.tryParse(json['ngayNghiemThu']?.toString() ?? '') ??
          DateTime.now(),
      haveInHoaDon: json['haveInHoaDon']?.toString() == 'true',
      ghiChu: json['ghiChu']?.toString() ?? '',
      status: int.tryParse(json['status'].toString()) ?? 0,
      heSoTieuThu: int.tryParse(json['heSoTieuThu'].toString()) ?? 0,
      mucDichSuDung: json['mucDichSuDung']?.toString() ?? '',
      hinhThucThanhToanId:
      int.tryParse(json['hinhThucThanhToanId'].toString()) ?? 0,
      loaiKhachHangId: int.tryParse(json['loaiKhachHangId'].toString()) ?? 0,
      nhaMangId: int.tryParse(json['nhaMangId'].toString()) ?? 0,
      id: int.tryParse(json['id'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maHopDong': maHopDong,
      'tenKhachHang': tenKhachHang,
      'tenThuongGoi': tenThuongGoi,
      'diaChi': diaChi,
      'soHoDungChung': soHoDungChung,
      'email': email,
      'sdt': sdt,
      'cmnd': cmnd,
      'ngayKyHopDong': ngayKyHopDong.toIso8601String(),
      'ngayLapDat': ngayLapDat.toIso8601String(),
      'ngayNghiemThu': ngayNghiemThu.toIso8601String(),
      'haveInHoaDon': haveInHoaDon,
      'ghiChu': ghiChu,
      'status': status,
      'heSoTieuThu': heSoTieuThu,
      'mucDichSuDung': mucDichSuDung,
      'hinhThucThanhToanId': hinhThucThanhToanId,
      'loaiKhachHangId': loaiKhachHangId,
      'nhaMangId': nhaMangId,
      'id': id,
    };
  }
}