import 'dart:convert';

class ThanhToanDataDto {
  String qrString;
  ChiTietThanhToan chiTietThanhToan;
  HopDong hopDong;
  DongHo dongHo;

  ThanhToanDataDto({
    required this.qrString,
    required this.chiTietThanhToan,
    required this.hopDong,
    required this.dongHo,
  });

  factory ThanhToanDataDto.fromJson(Map<String, dynamic> json) {
    return ThanhToanDataDto(
      qrString: json['qrString'] ?? '',
      chiTietThanhToan: ChiTietThanhToan.fromJson(json['chiTietThanhToan'] ?? {}),
      hopDong: HopDong.fromJson(json['hopDong'] ?? {}),
      dongHo: DongHo.fromJson(json['dongHo'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'qrString': qrString,
    'chiTietThanhToan': chiTietThanhToan.toJson(),
    'hopDong': hopDong.toJson(),
    'dongHo': dongHo.toJson(),
  };
}

class ChiTietThanhToan {
  int chiSoCu;
  int chiSoMoi;
  int tongSuDung;
  int truyThu;
  int heSoTieuThu;
  int tongThanhTien;
  List<ThanhTienChiTiet> thanhTienChiTiet;
  int vat;
  int status;
  int nguoiThuId;
  String tenNguoiThu;
  int tongThanhTienSauVat;
  String ghiChu;
  int messageStatus;
  bool isCreateInvoice;
  int thuTu;
  int paymentType;
  int phiDuyTriDauNoi;
  int phiBaoVeMoiTruong;
  String ngayThu;
  int dongHoId;
  int soThanhToanId;
  int hopDongId;
  String soHoaDon;
  String mauHoaDon;
  String kyHieuHoaDon;
  String ngayPhatHanhHoaDon;
  String maBiMat;
  int trangThaiHoaDon;
  String transactionUId;
  String lichSuThu;
  int stt;
  int id;

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
      chiSoCu: int.tryParse(json['chiSoCu'].toString()) ?? 0,
      chiSoMoi: int.tryParse(json['chiSoMoi'].toString()) ?? 0,
      tongSuDung: int.tryParse(json['tongSuDung'].toString()) ?? 0,
      truyThu: int.tryParse(json['truyThu'].toString()) ?? 0,
      heSoTieuThu: int.tryParse(json['heSoTieuThu'].toString()) ?? 0,
      tongThanhTien: int.tryParse(json['tongThanhTien'].toString()) ?? 0,
      thanhTienChiTiet: (json['thanhTienChiTiet'] as List<dynamic>?)
          ?.map((item) => ThanhTienChiTiet.fromJson(item))
          .toList() ??
          [],
      vat: int.tryParse(json['vat'].toString()) ?? 0,
      status: int.tryParse(json['status'].toString()) ?? 0,
      nguoiThuId: int.tryParse(json['nguoiThuId'].toString()) ?? 0,
      tenNguoiThu: json['tenNguoiThu'] ?? '',
      tongThanhTienSauVat: int.tryParse(json['tongThanhTienSauVat'].toString()) ?? 0,
      ghiChu: json['ghiChu'] ?? '',
      messageStatus: int.tryParse(json['messageStatus'].toString()) ?? 0,
      isCreateInvoice: json['isCreateInvoice']?.toString() == 'true',
      thuTu: int.tryParse(json['thuTu'].toString()) ?? 0,
      paymentType: int.tryParse(json['paymentType'].toString()) ?? 0,
      phiDuyTriDauNoi: int.tryParse(json['phiDuyTriDauNoi'].toString()) ?? 0,
      phiBaoVeMoiTruong: int.tryParse(json['phiBaoVeMoiTruong'].toString()) ?? 0,
      ngayThu: json['ngayThu'] ?? '',
      dongHoId: int.tryParse(json['dongHoId'].toString()) ?? 0,
      soThanhToanId: int.tryParse(json['soThanhToanId'].toString()) ?? 0,
      hopDongId: int.tryParse(json['hopDongId'].toString()) ?? 0,
      soHoaDon: json['soHoaDon'] ?? '',
      mauHoaDon: json['mauHoaDon'] ?? '',
      kyHieuHoaDon: json['kyHieuHoaDon'] ?? '',
      ngayPhatHanhHoaDon: json['ngayPhatHanhHoaDon'] ?? '',
      maBiMat: json['maBiMat'] ?? '',
      trangThaiHoaDon: int.tryParse(json['trangThaiHoaDon'].toString()) ?? 0,
      transactionUId: json['transactionUId'] ?? '',
      lichSuThu: json['lichSuThu'] ?? '',
      stt: int.tryParse(json['stt'].toString()) ?? 0,
      id: int.tryParse(json['id'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'chiSoCu': chiSoCu,
    'chiSoMoi': chiSoMoi,
    'tongSuDung': tongSuDung,
    'truyThu': truyThu,
    'heSoTieuThu': heSoTieuThu,
    'tongThanhTien': tongThanhTien,
    'thanhTienChiTiet': thanhTienChiTiet.map((item) => item.toJson()).toList(),
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
    'ngayThu': ngayThu,
    'dongHoId': dongHoId,
    'soThanhToanId': soThanhToanId,
    'hopDongId': hopDongId,
    'soHoaDon': soHoaDon,
    'mauHoaDon': mauHoaDon,
    'kyHieuHoaDon': kyHieuHoaDon,
    'ngayPhatHanhHoaDon': ngayPhatHanhHoaDon,
    'maBiMat': maBiMat,
    'trangThaiHoaDon': trangThaiHoaDon,
    'transactionUId': transactionUId,
    'lichSuThu': lichSuThu,
    'stt': stt,
    'id': id,
  };
}

class ThanhTienChiTiet {
  int mucDichSuDungId;
  String mucDichSuDungKyHieu;
  String mucDichSuDungMoTa;
  int soLuong;
  int donGia;
  int thanhTien;
  int vat;

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
      mucDichSuDungKyHieu: json['mucDichSuDungKyHieu'] ?? '',
      mucDichSuDungMoTa: json['mucDichSuDungMoTa'] ?? '',
      soLuong: int.tryParse(json['soLuong'].toString()) ?? 0,
      donGia: int.tryParse(json['donGia'].toString()) ?? 0,
      thanhTien: int.tryParse(json['thanhTien'].toString()) ?? 0,
      vat: int.tryParse(json['vat'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'mucDichSuDungId': mucDichSuDungId,
    'mucDichSuDungKyHieu': mucDichSuDungKyHieu,
    'mucDichSuDungMoTa': mucDichSuDungMoTa,
    'soLuong': soLuong,
    'donGia': donGia,
    'thanhTien': thanhTien,
    'vat': vat,
  };
}

class HopDong {
  String maHopDong;
  String tenKhachHang;
  String tenThuongGoi;
  String diaChi;
  int soHoDungChung;
  String email;
  String sdt;
  String cmnd;
  String ngayKyHopDong;
  String ngayLapDat;
  String ngayNghiemThu;
  bool haveInHoaDon;
  String ghiChu;
  int status;
  int heSoTieuThu;
  String mucDichSuDung;
  int hinhThucThanhToanId;
  int loaiKhachHangId;
  int nhaMangId;
  int id;

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
    required  this.nhaMangId,
    required this.id,
  });

  factory HopDong.fromJson(Map<String, dynamic> json) {
    return HopDong(
      maHopDong: json['maHopDong'] ?? '',
      tenKhachHang: json['tenKhachHang'] ?? '',
      tenThuongGoi: json['tenThuongGoi'] ?? '',
      diaChi: json['diaChi'] ?? '',
      soHoDungChung: int.tryParse(json['soHoDungChung'].toString()) ?? 0,
      email: json['email'] ?? '',
      sdt: json['sdt'] ?? '',
      cmnd: json['cmnd'] ?? '',
      ngayKyHopDong: json['ngayKyHopDong'] ?? '',
      ngayLapDat: json['ngayLapDat'] ?? '',
      ngayNghiemThu: json['ngayNghiemThu'] ?? '',
      haveInHoaDon: json['haveInHoaDon']?.toString() == 'true',
      ghiChu: json['ghiChu'] ?? '',
      status: int.tryParse(json['status'].toString()) ?? 0,
      heSoTieuThu: int.tryParse(json['heSoTieuThu'].toString()) ?? 0,
      mucDichSuDung: json['mucDichSuDung'] ?? '',
      hinhThucThanhToanId: int.tryParse(json['hinhThucThanhToanId'].toString()) ?? 0,
      loaiKhachHangId: int.tryParse(json['loaiKhachHangId'].toString()) ?? 0,
      nhaMangId: int.tryParse(json['nhaMangId'].toString()) ?? 0,
      id: int.tryParse(json['id'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'maHopDong': maHopDong,
    'tenKhachHang': tenKhachHang,
    'tenThuongGoi': tenThuongGoi,
    'diaChi': diaChi,
    'soHoDungChung': soHoDungChung,
    'email': email,
    'sdt': sdt,
    'cmnd': cmnd,
    'ngayKyHopDong': ngayKyHopDong,
    'ngayLapDat': ngayLapDat,
    'ngayNghiemThu': ngayNghiemThu,
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

class DongHo {
  bool isDongHoPhu;
  int stt;
  String ngaySuDung;
  String diaChi;
  String kinhDo;
  String viDo;
  int status;
  int hopDongId;
  int khuVucId;
  int tuyenId;
  int qlDHKhoiId;
  int khoDongHoId;
  String seriDH;
  int id;

  DongHo({
    required this.isDongHoPhu,
    required this.stt,
    required this.ngaySuDung,
    required this.diaChi,
    required this.kinhDo,
    required this.viDo,
    required this.status,
    required this.hopDongId,
    required this.khuVucId,
    required this.tuyenId,
    required this.qlDHKhoiId,
    required this.khoDongHoId,
    required this.seriDH,
    required this.id,
  });

  factory DongHo.fromJson(Map<String, dynamic> json) {
    return DongHo(
      isDongHoPhu: json['isDongHoPhu']?.toString() == 'true',
      stt: int.tryParse(json['stt'].toString()) ?? 0,
      ngaySuDung: json['ngaySuDung'] ?? '',
      diaChi: json['diaChi'] ?? '',
      kinhDo: json['kinhDo'] ?? '',
      viDo: json['viDo'] ?? '',
      status: int.tryParse(json['status'].toString()) ?? 0,
      hopDongId: int.tryParse(json['hopDongId'].toString()) ?? 0,
      khuVucId: int.tryParse(json['khuVucId'].toString()) ?? 0,
      tuyenId: int.tryParse(json['tuyenId'].toString()) ?? 0,
      qlDHKhoiId: int.tryParse(json['qlDHKhoiId'].toString()) ?? 0,
      khoDongHoId: int.tryParse(json['khoDongHoId'].toString()) ?? 0,
      seriDH: json['seriDH'] ?? '',
      id: int.tryParse(json['id'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'isDongHoPhu': isDongHoPhu,
    'stt': stt,
    'ngaySuDung': ngaySuDung,
    'diaChi': diaChi,
    'kinhDo': kinhDo,
    'viDo': viDo,
    'status': status,
    'hopDongId': hopDongId,
    'khuVucId': khuVucId,
    'tuyenId': tuyenId,
    'qlDHKhoiId': qlDHKhoiId,
    'khoDongHoId': khoDongHoId,
    'seriDH': seriDH,
    'id': id,
  };
}