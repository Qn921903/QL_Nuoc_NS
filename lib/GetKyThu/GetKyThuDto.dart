import 'dart:convert';

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GetBaoCaoThuTheoSoResultDto {
  final bool status;
  final String message;
  final int tongTien;
  final int tongKhachHang;
  final List<SoThanhToanForNhanVienKhongCanSoThanhToanDto> data;

  GetBaoCaoThuTheoSoResultDto({required this.status, required this.message, required this.data, required this.tongTien, required this.tongKhachHang});

  factory GetBaoCaoThuTheoSoResultDto.fromJson(Map<String, dynamic> jsons) {
    var streetsFromJson = jsons['result']['data'];
    List<SoThanhToanForNhanVienKhongCanSoThanhToanDto> posts = [];
    for (var Variable in streetsFromJson) {
      posts.add(new SoThanhToanForNhanVienKhongCanSoThanhToanDto(
          tenSo: Variable['tenSo'],
          soKhachHangDaThu: Variable['soKhachHangDaThu'],
          tongSoKhachHang: Variable['tongSoKhachHang'],
          soTienDaThu: Variable['soTienDaThu'],
          tongSoTien: Variable['tongSoTien'],

      ));
    }


    return GetBaoCaoThuTheoSoResultDto(
        status: jsons['result']['status'],
        message: jsons['result']['message'],
        tongTien: int.parse(jsons['result']['tongTien'].toString()),
        tongKhachHang: int.parse(jsons['result']['tongKhachHang'].toString()),
        data: posts
    );
  }
}

class GetKyThuResultDto {
  final bool status;
  final String message;
  final List<GetKyThuDataDto> data;

  GetKyThuResultDto({required this.status, required this.message, required this.data});

  factory GetKyThuResultDto.fromJson(Map<String, dynamic> jsons) {
    var streetsFromJson = jsons['result']['data'];
    List<GetKyThuDataDto> posts = [];
    for (var Variable in streetsFromJson) {
      posts.add(new GetKyThuDataDto(
          displayText: Variable['displayText'], id: Variable['id']));
    }


    return GetKyThuResultDto(
        status: jsons['result']['status'],
        message: jsons['result']['message'],
        data: posts
    );
  }
}
class GetCommonResultDto {
  final bool status;
  final String message;
  GetCommonResultDto({required this.status, required this.message});
  factory GetCommonResultDto.fromJson(Map<String, dynamic> jsons) {
    return GetCommonResultDto(
        status: jsons['result']['status'],
        message: jsons['result']['message'],
    );
  }
}


class GetKyThuDataDto {
  final String displayText;
  final int id;

  GetKyThuDataDto({required this.displayText, required this.id});

  factory GetKyThuDataDto.fromJson(Map<String, dynamic> json) {
    return GetKyThuDataDto(
      displayText: json['displayText'],
      id: json['id'],
    );
  }
}

class SoThanhToanForNhanVienKhongCanSoThanhToanDto {
  final String tenSo;
  final int soKhachHangDaThu;
  final int tongSoKhachHang;
  final int soTienDaThu;
  final int tongSoTien;
  SoThanhToanForNhanVienKhongCanSoThanhToanDto({
    required this.tenSo,
    required this.soKhachHangDaThu,
    required this.tongSoKhachHang,
    required this.soTienDaThu,
    required this.tongSoTien,
  });

  factory SoThanhToanForNhanVienKhongCanSoThanhToanDto.fromJson(Map<String, dynamic> json) {
    return SoThanhToanForNhanVienKhongCanSoThanhToanDto(
      tenSo: json['tenSo'],
      soKhachHangDaThu: json['soKhachHangDaThu'],
      tongSoKhachHang: json['tongSoKhachHang'],
      soTienDaThu: json['soTienDaThu'],
      tongSoTien: json['tongSoTien'],
    );
  }
}
//
// class GhiChiSoDataDto {
//   int chiSoCu;
//   int chiSoMoi;
//   double toaDoX;
//   double toaDoY;
//   String thoiGianGhiDau;
//   String thoiGianGhiCuoi;
//   int dongHoId;
//   int soGhiChiSoId;
//   int truyThu;
//   String ghiChu;
//   String image;
//   int tongSuDung;
//   int id;
//
//   GhiChiSoDataDto({
//     required this.chiSoCu,
//     required this.chiSoMoi,
//     required this.toaDoX,
//     required this.toaDoY,
//     required this.thoiGianGhiDau,
//     required this.thoiGianGhiCuoi,
//     required this.dongHoId,
//     required this.soGhiChiSoId,
//     required this.truyThu,
//     required this.ghiChu,
//     required this.image,
//     required this.tongSuDung,
//     required this.id,
//   });
//
//   Map<String, dynamic> toJson() =>
//       {
//
//         'chiSoCu': chiSoCu,
//         'chiSoMoi': chiSoMoi,
//         'toaDoX': toaDoX,
//         'toaDoY': toaDoY,
//         'thoiGianGhiDau': thoiGianGhiDau,
//         'thoiGianGhiCuoi': thoiGianGhiCuoi,
//         'dongHoId': dongHoId,
//         'soGhiChiSoId': soGhiChiSoId,
//         'truyThu': truyThu,
//         'ghiChu': ghiChu,
//         'image': image,
//         'tongSuDung': tongSuDung,
//         'id': id,
//
//       };
//
//   factory GhiChiSoDataDto.fromJson(Map<String, dynamic> json) {
//     return GhiChiSoDataDto(
//       chiSoCu: int.parse(json['chiSoCu'].toString()),
//       chiSoMoi: int.parse(json['chiSoMoi'].toString()),
//       toaDoX: (json['toaDoX'] == null) ? 0 : double.parse(
//           json['toaDoX'].toString()),
//       toaDoY: (json['toaDoY'] == null) ? 0 : double.parse(
//           json['toaDoY'].toString()),
//       thoiGianGhiDau: json['thoiGianGhiDau']??'',
//       thoiGianGhiCuoi: json['thoiGianGhiCuoi']??'',
//       dongHoId: int.parse(json['dongHoId'].toString()),
//       soGhiChiSoId: int.parse(json['soGhiChiSoId'].toString()),
//       truyThu: int.parse(json['truyThu'].toString()),
//       ghiChu: json['ghiChu']??'',
//       image: json['image'].toString()??'',
//       tongSuDung: int.parse(json['tongSuDung'].toString()),
//       id: int.parse(json['id'].toString()),
//     );
//   }
// }
//
// class HopdongDonghoKhoDongHoDto {
//   String tenKhachHang;
//   String diaChi;
//   String sdt;
//   String serial;
//   String maHopDong;
//   int dongHoId;
//   int heSoTieuThu;
//   int id;
//
//   HopdongDonghoKhoDongHoDto({
//     required this.tenKhachHang,
//     required this.diaChi,
//     required this.sdt,
//     required this.serial,
//     required this.maHopDong,
//     required this.dongHoId,
//     required this.heSoTieuThu,
//     required this.id,
//   });
//
//   Map<String, dynamic> toJson() =>
//       {
//
//         'tenKhachHang': tenKhachHang,
//         'diaChi': diaChi,
//         'sdt': sdt,
//         'serial': serial,
//         'maHopDong': maHopDong,
//         'dongHoId': dongHoId,
//         'heSoTieuThu': heSoTieuThu,
//         'id': id,
//
//
//       };
//
//   factory HopdongDonghoKhoDongHoDto.fromJson(Map<String, dynamic> json) {
//     return HopdongDonghoKhoDongHoDto(
//       tenKhachHang: json['tenKhachHang'],
//       diaChi: json['diaChi'],
//       sdt: json['sdt'],
//       serial: json['serial'],
//       maHopDong: json['maHopDong'],
//       dongHoId: int.parse(json['dongHoId'].toString()),
//       heSoTieuThu: int.parse(json['heSoTieuThu'].toString()),
//       id: int.parse(json['id'].toString()),
//     );
//   }
// }
//
// class GetGhiChiSoDataDto {
//   GhiChiSoDataDto ghiChiSo;
//   String dongHoDiaChi;
//   String soGhiChiSoTenSo;
//   String kinhDo;
//   String viDo;
//   double distance;
//   HopdongDonghoKhoDongHoDto hopdongDonghoKhoDongHoDto;
//   int stt;
//   int chiSoCuThangTruoc;
//   int chiSoMoiThangTruoc;
//   int tongSuDungThangTruoc;
//   int chiSoCuThangTruocNua;
//   int chiSoMoiThangTruocNua;
//   int tongSuDungThangTruocNua;
//   bool isLapSTT;
//
//   GetGhiChiSoDataDto({
//     required this.ghiChiSo,
//     required this.dongHoDiaChi,
//     required this.soGhiChiSoTenSo,
//     required this.kinhDo,
//     required this.viDo,
//     required this.distance,
//     required this.hopdongDonghoKhoDongHoDto,
//     required this.stt,
//     required this.isLapSTT,
//     required this.chiSoCuThangTruoc,
//     required this.chiSoMoiThangTruoc,
//     required this.tongSuDungThangTruoc,
//     required this.chiSoCuThangTruocNua,
//     required this.chiSoMoiThangTruocNua,
//     required this.tongSuDungThangTruocNua,
//   });
//
//   factory GetGhiChiSoDataDto.fromJson(Map<String, dynamic> json) {
//     return GetGhiChiSoDataDto(
//         ghiChiSo: GhiChiSoDataDto.fromJson(json['ghiChiSo']),
//         dongHoDiaChi: json['dongHoDiaChi']??'',
//         soGhiChiSoTenSo: json['soGhiChiSoTenSo']??'',
//         kinhDo: json['kinhDo']??'',
//         viDo: json['viDo']??'',
//         distance: double.parse(json['distance'].toString()),
//         hopdongDonghoKhoDongHoDto: HopdongDonghoKhoDongHoDto.fromJson(
//             json['hopdongDonghoKhoDongHoDto']),
//         stt: int.parse(json['stt'].toString()),
//         chiSoCuThangTruoc: int.parse(json['chiSoCuThangTruoc'].toString()),
//         chiSoMoiThangTruoc: int.parse(json['chiSoMoiThangTruoc'].toString()),
//         tongSuDungThangTruoc: int.parse(json['tongSuDungThangTruoc'].toString()),
//         chiSoCuThangTruocNua: int.parse(json['chiSoCuThangTruocNua'].toString()),
//         chiSoMoiThangTruocNua: int.parse(json['chiSoMoiThangTruocNua'].toString()),
//         tongSuDungThangTruocNua: int.parse(json['tongSuDungThangTruocNua'].toString()),
//         isLapSTT: (json['isLapSTT'].toString() == 'true')
//     );
//   }
//
//   Map<String, dynamic> toJson() =>
//       {
//         'ghiChiSo': jsonEncode(ghiChiSo.toJson()),
//         'dongHoDiaChi': dongHoDiaChi,
//         'soGhiChiSoTenSo': soGhiChiSoTenSo,
//         'kinhDo': kinhDo,
//         'viDo': viDo,
//         'distance': distance,
//         'hopdongDonghoKhoDongHoDto': jsonEncode(
//             hopdongDonghoKhoDongHoDto.toJson()),
//         'stt': stt,
//         'chiSoCuThangTruoc': chiSoCuThangTruoc,
//         'chiSoMoiThangTruoc': chiSoMoiThangTruoc,
//         'tongSuDungThangTruoc': tongSuDungThangTruoc,
//         'chiSoCuThangTruocNua': chiSoCuThangTruocNua,
//         'chiSoMoiThangTruocNua': chiSoMoiThangTruocNua,
//         'tongSuDungThangTruocNua': tongSuDungThangTruocNua,
//         'isLapSTT': isLapSTT,
//       };
// }




class GhiChiSoDataDto {
  int chiSoCu;
  int chiSoMoi;
  double toaDoX;
  double toaDoY;
  String thoiGianGhiDau;
  String thoiGianGhiCuoi;
  int dongHoId;
  int soGhiChiSoId;
  int truyThu;
  String ghiChu;
  String image;
  int tongSuDung;
  int id;

  GhiChiSoDataDto({
    required this.chiSoCu,
    required this.chiSoMoi,
    required this.toaDoX,
    required this.toaDoY,
    required this.thoiGianGhiDau,
    required this.thoiGianGhiCuoi,
    required this.dongHoId,
    required this.soGhiChiSoId,
    required this.truyThu,
    required this.ghiChu,
    required this.image,
    required this.tongSuDung,
    required this.id,
  });

  factory GhiChiSoDataDto.fromJson(Map<String, dynamic> json) {
    return GhiChiSoDataDto(
      // chiSoCu: int.tryParse(json['chiSoCu'].toString()) ,
        chiSoCu: int.parse(json['chiSoCu'].toString()),
      chiSoMoi: int.parse(json['chiSoMoi'].toString()),
      // chiSoMoi: int.tryParse(json['chiSoMoi'].toString()) ?? 0,
      toaDoX: (json['toaDoX'] == null) ? 0.0 : double.tryParse(json['toaDoX'].toString()) ?? 0.0,
      toaDoY: (json['toaDoY'] == null) ? 0.0 : double.tryParse(json['toaDoY'].toString()) ?? 0.0,
      thoiGianGhiDau: json['thoiGianGhiDau'] ?? '',
      thoiGianGhiCuoi: json['thoiGianGhiCuoi'] ?? '',
      dongHoId: int.tryParse(json['dongHoId'].toString()) ?? 0,
      soGhiChiSoId: int.tryParse(json['soGhiChiSoId'].toString()) ?? 0,
      truyThu: int.tryParse(json['truyThu'].toString()) ?? 0,
      ghiChu: json['ghiChu'] ?? '',
      image: json['image']?.toString() ?? '',
      tongSuDung: int.tryParse(json['tongSuDung'].toString()) ?? 0,
      id: int.tryParse(json['id'].toString()) ?? 0,
    );
  }


  Map<String, dynamic> toJson() =>
      {

        'chiSoCu': chiSoCu,
        'chiSoMoi': chiSoMoi,
        'toaDoX': toaDoX,
        'toaDoY': toaDoY,
        'thoiGianGhiDau': thoiGianGhiDau,
        'thoiGianGhiCuoi': thoiGianGhiCuoi,
        'dongHoId': dongHoId,
        'soGhiChiSoId': soGhiChiSoId,
        'truyThu': truyThu,
        'ghiChu': ghiChu,
        'image': image,
        'tongSuDung': tongSuDung,
        'id': id,

      };

}

class HopdongDonghoKhoDongHoDto {
  String tenKhachHang;
  String diaChi;
  String sdt;
  String serial;
  String maHopDong;
  int dongHoId;
  int heSoTieuThu;
  int id;

  HopdongDonghoKhoDongHoDto({
    required this.tenKhachHang,
    required this.diaChi,
    required this.sdt,
    required this.serial,
    required this.maHopDong,
    required this.dongHoId,
    required this.heSoTieuThu,
    required this.id,
  });

  factory HopdongDonghoKhoDongHoDto.fromJson(Map<String, dynamic> json) {
    return HopdongDonghoKhoDongHoDto(
      tenKhachHang: json['tenKhachHang'] ?? '',
      diaChi: json['diaChi'] ?? '',
      sdt: json['sdt'] ?? '',
      serial: json['serial'] ?? '',
      maHopDong: json['maHopDong'] ?? '',
      dongHoId: int.tryParse(json['dongHoId'].toString()) ?? 0,
      heSoTieuThu: int.tryParse(json['heSoTieuThu'].toString()) ?? 1,
      id: int.tryParse(json['id'].toString()) ?? 0,
    );
  }


  Map<String, dynamic> toJson() =>
      {

        'tenKhachHang': tenKhachHang,
        'diaChi': diaChi,
        'sdt': sdt,
        'serial': serial,
        'maHopDong': maHopDong,
        'dongHoId': dongHoId,
        'heSoTieuThu': heSoTieuThu,
        'id': id,


      };

//   factory HopdongDonghoKhoDongHoDto.fromJson(Map<String, dynamic> json) {
//     return HopdongDonghoKhoDongHoDto(
//       tenKhachHang: json['tenKhachHang'],
//       diaChi: json['diaChi'],
//       sdt: json['sdt'],
//       serial: json['serial'],
//       maHopDong: json['maHopDong'],
//       dongHoId: int.parse(json['dongHoId'].toString()),
//       heSoTieuThu: int.parse(json['heSoTieuThu'].toString()),
//       id: int.parse(json['id'].toString()),
//     );
//   }
}

class GetGhiChiSoDataDto {
  GhiChiSoDataDto ghiChiSo;
  String dongHoDiaChi;
  String soGhiChiSoTenSo;
  String kinhDo;
  String viDo;
  double distance;
  HopdongDonghoKhoDongHoDto hopdongDonghoKhoDongHoDto;
  int stt;
  int chiSoCuThangTruoc;
  int chiSoMoiThangTruoc;
  int tongSuDungThangTruoc;
  int chiSoCuThangTruocNua;
  int chiSoMoiThangTruocNua;
  int tongSuDungThangTruocNua;
  bool isLapSTT;

  GetGhiChiSoDataDto({
    required this.ghiChiSo,
    required this.dongHoDiaChi,
    required this.soGhiChiSoTenSo,
    required this.kinhDo,
    required this.viDo,
    required this.distance,
    required this.hopdongDonghoKhoDongHoDto,
    required this.stt,
    required this.chiSoCuThangTruoc,
    required this.chiSoMoiThangTruoc,
    required this.tongSuDungThangTruoc,
    required this.chiSoCuThangTruocNua,
    required this.chiSoMoiThangTruocNua,
    required this.tongSuDungThangTruocNua,
    required this.isLapSTT,
  });

  factory GetGhiChiSoDataDto.fromJson(Map<String, dynamic> json) {
    return GetGhiChiSoDataDto(
      ghiChiSo: GhiChiSoDataDto.fromJson(json['ghiChiSo'] ?? {}),
      dongHoDiaChi: json['dongHoDiaChi'] ?? '',
      soGhiChiSoTenSo: json['soGhiChiSoTenSo'] ?? '',
      kinhDo: json['kinhDo'] ?? '',
      viDo: json['viDo'] ?? '',
      distance: double.tryParse(json['distance'].toString()) ?? 0.0,
      hopdongDonghoKhoDongHoDto: HopdongDonghoKhoDongHoDto.fromJson(json['hopdongDonghoKhoDongHoDto'] ?? {}),
      stt: int.tryParse(json['stt'].toString()) ?? 0,
      chiSoCuThangTruoc: int.tryParse(json['chiSoCuThangTruoc'].toString()) ?? 0,
      chiSoMoiThangTruoc: int.tryParse(json['chiSoMoiThangTruoc'].toString()) ?? 0,
      tongSuDungThangTruoc: int.tryParse(json['tongSuDungThangTruoc'].toString()) ?? 0,
      chiSoCuThangTruocNua: int.tryParse(json['chiSoCuThangTruocNua'].toString()) ?? 0,
      chiSoMoiThangTruocNua: int.tryParse(json['chiSoMoiThangTruocNua'].toString()) ?? 0,
      tongSuDungThangTruocNua: int.tryParse(json['tongSuDungThangTruocNua'].toString()) ?? 0,
      isLapSTT: (json['isLapSTT'].toString() == 'true'),
    );
  }


  Map<String, dynamic> toJson() =>
      {
        'ghiChiSo': jsonEncode(ghiChiSo.toJson()),
        'dongHoDiaChi': dongHoDiaChi,
        'soGhiChiSoTenSo': soGhiChiSoTenSo,
        'kinhDo': kinhDo,
        'viDo': viDo,
        'distance': distance,
        'hopdongDonghoKhoDongHoDto': jsonEncode(
            hopdongDonghoKhoDongHoDto.toJson()),
        'stt': stt,
        'chiSoCuThangTruoc': chiSoCuThangTruoc,
        'chiSoMoiThangTruoc': chiSoMoiThangTruoc,
        'tongSuDungThangTruoc': tongSuDungThangTruoc,
        'chiSoCuThangTruocNua': chiSoCuThangTruocNua,
        'chiSoMoiThangTruocNua': chiSoMoiThangTruocNua,
        'tongSuDungThangTruocNua': tongSuDungThangTruocNua,
        'isLapSTT': isLapSTT,
      };
}



class GetGhiChiSoDataResultDto {
  bool status;
  String message;
  List<GetGhiChiSoDataDto> data;

  GetGhiChiSoDataResultDto({required this.status, required this.message, required this.data});

  factory GetGhiChiSoDataResultDto.fromJson(Map<String, dynamic> jsons) {
    var streetsFromJson = jsons['result']['data'];
    List<GetGhiChiSoDataDto> posts = [];
    for (var Variable in streetsFromJson) {
      posts.add(new GetGhiChiSoDataDto(
          distance: Variable['distance'],
          dongHoDiaChi: Variable['dongHoDiaChi'],
          ghiChiSo: GhiChiSoDataDto.fromJson(Variable['ghiChiSo']),
          hopdongDonghoKhoDongHoDto: HopdongDonghoKhoDongHoDto.fromJson(
              Variable['hopdongDonghoKhoDongHoDto']),
          isLapSTT: Variable['isLapSTT'],
          kinhDo: Variable['kinhDo'],
          soGhiChiSoTenSo: Variable['soGhiChiSoTenSo'],
          stt: Variable['stt'],
          chiSoCuThangTruoc: int.parse(Variable['chiSoCuThangTruoc'].toString()),
          chiSoMoiThangTruoc: int.parse(Variable['chiSoMoiThangTruoc'].toString()),
          tongSuDungThangTruoc: int.parse(Variable['tongSuDungThangTruoc'].toString()),
          chiSoCuThangTruocNua: int.parse(Variable['chiSoCuThangTruocNua'].toString()),
          chiSoMoiThangTruocNua: int.parse(Variable['chiSoMoiThangTruocNua'].toString()),
          tongSuDungThangTruocNua: int.parse(Variable['tongSuDungThangTruocNua'].toString()),
          viDo: Variable['viDo']
      ));
    }
    return GetGhiChiSoDataResultDto(
        status: jsons['result']['status'],
        message: jsons['result']['message'],
        data: posts
    );
  }
  Map<String, dynamic> toJson() =>
      {
        'result': {
          'status': status,
          'message': message,
          'data': jsonEncode(data.map((e) => e.toJson()).toList()),
        }
      };
}

class ReturnBackFromGhiChiSo {
  final bool status;
  final int chisomoi;
  final String anh;
  final String ghichu;

  ReturnBackFromGhiChiSo({required this.status, required this.chisomoi,required this.anh,required this.ghichu});
}

//sothanhtoan

class SoThanhToanDto {
  String tenSo;
  int thang;
  int id;
  int nam;
  bool status;
  int soGhiChiSoId;
  SoThanhToanDto({required this.tenSo,required this.thang,required this.nam,required this.status,required this.soGhiChiSoId,required this.id});
  factory SoThanhToanDto.fromJson(Map<String, dynamic> json) {
    return SoThanhToanDto(
      tenSo: json['tenSo'].toString(),
      thang: int.parse(json['thang'].toString()),
      nam: int.parse(json['nam'].toString()),
      id: int.parse(json['id'].toString()),
      status: (json['status'].toString()=='true'),
      soGhiChiSoId: int.parse(json['soGhiChiSoId'].toString()),
    );
  }
}

class GetSoThanhToanDataDto {
  SoThanhToanDto soThanhToan;
  String soGhiChiSoTenSo;
  int soTienDaThu;
  int soKhachHangDaThu;
  int tongSoTien;
  int tongSoKhachHang;
  GetSoThanhToanDataDto({required this.soGhiChiSoTenSo,required this.soThanhToan,required this.soTienDaThu,required this.soKhachHangDaThu,required this.tongSoKhachHang,required this.tongSoTien});
  factory GetSoThanhToanDataDto.fromJson(Map<String, dynamic> json) {
    return GetSoThanhToanDataDto(
      soThanhToan: SoThanhToanDto.fromJson(json['soThanhToan']),
      soGhiChiSoTenSo: json['soGhiChiSoTenSo'],
      soTienDaThu: int.parse(json['soTienDaThu']),
      soKhachHangDaThu: int.parse(json['soKhachHangDaThu']),
      tongSoTien: int.parse(json['tongSoTien']),
      tongSoKhachHang: int.parse(json['tongSoKhachHang']),
    );
  }
}

class GetSoThanhToanDataResultDto {
  bool status;
  String message;
  List<GetSoThanhToanDataDto> data;

  GetSoThanhToanDataResultDto({required this.status, required this.message, required this.data});

  factory GetSoThanhToanDataResultDto.fromJson(Map<String, dynamic> jsons) {
    var streetsFromJson = jsons['result']['data'];
    List<GetSoThanhToanDataDto> posts = [];
    for (var Variable in streetsFromJson) {
      posts.add(new GetSoThanhToanDataDto(
          soKhachHangDaThu: Variable['soKhachHangDaThu'],
          tongSoTien: Variable['tongSoTien'],
          tongSoKhachHang: Variable['tongSoKhachHang'],
          soTienDaThu: Variable['soTienDaThu'],
          soGhiChiSoTenSo: Variable['soGhiChiSoTenSo'],
          soThanhToan: SoThanhToanDto.fromJson(Variable['soThanhToan']),
      ));
    }
    return GetSoThanhToanDataResultDto(
        status: jsons['result']['status'],
        message: jsons['result']['message'],
        data: posts
    );
  }
}
//chitietthanhtoan
class ThanhTienChiTietDto{
  int mucDichSuDungId;
  String mucDichSuDungKyHieu;
  String mucDichSuDungMoTa;
  int soLuong;
  int donGia;
  int thanhTien;
  ThanhTienChiTietDto({
    required this.mucDichSuDungId,
    required this.mucDichSuDungKyHieu,
    required this.mucDichSuDungMoTa,
    required this.soLuong,
    required this.donGia,
    required this.thanhTien,
  });
  factory ThanhTienChiTietDto.fromJson(Map<String, dynamic> json) {
    return ThanhTienChiTietDto(
      mucDichSuDungKyHieu: json['mucDichSuDungKyHieu'].toString(),
      mucDichSuDungMoTa: json['mucDichSuDungMoTa'].toString(),
      mucDichSuDungId: int.parse(json['mucDichSuDungId'].toString()),
      soLuong: int.parse(json['soLuong'].toString()),
      donGia: int.parse(json['donGia'].toString()),
      thanhTien: int.parse(json['thanhTien'].toString()),
    );
  }
}

DateTime now_date = DateTime.now();

class ChiTietThanhToanDto {
  int chiSoCu;
  int chiSoMoi;
  int tongSuDung;
  int truyThu;
  int heSoTieuThu;
  int tongThanhTien;
  int vat;
  int status;
  int nguoiThuId;
  String tenNguoiThu;
  DateTime ngayThu;
  int tongThanhTienSauVat;
  String ghiChu;
  int messageStatus;
  bool isCreateInvoice;
  int thuTu;
  int paymentType;
  int phiDuyTriDauNoi;
  int phiBaoVeMoiTruong;
  int id;
  List<ThanhTienChiTietDto> thanhTienChiTiet;
  int dongHoId;
  int hopDongId;
  int soThanhToanId;
  String lichSuThu;
  String maBiMat;
  String soHoaDon;
  int sTT;

  ChiTietThanhToanDto({
    required this.chiSoCu,
    required this.chiSoMoi,
    required this.tongSuDung,
    required this.truyThu,
    required this.heSoTieuThu,
    required this.tongThanhTien,
    required this.vat,
    required this.status,
    required this.nguoiThuId,
    required this.tenNguoiThu,
    required this.ngayThu,
    required this.tongThanhTienSauVat,
    required this.ghiChu,
    required this.messageStatus,
    required this.isCreateInvoice,
    required this.thuTu,
    required this.paymentType,
    required this.phiDuyTriDauNoi,
    required this.phiBaoVeMoiTruong,
    required this.id,
    required this.thanhTienChiTiet,
    required this.dongHoId,
    required this.hopDongId,
    required this.soThanhToanId,
    required this.lichSuThu,
    required this.maBiMat,
    required this.soHoaDon,
    required this.sTT
  });
  factory ChiTietThanhToanDto.fromJson(Map<String, dynamic> json) {
    var streetsFromJson = json['thanhTienChiTiet'];
    List<ThanhTienChiTietDto> posts = [];
    for (var Variable in streetsFromJson) {
      posts.add(new ThanhTienChiTietDto(
        mucDichSuDungKyHieu: Variable['mucDichSuDungKyHieu'],
        mucDichSuDungMoTa: Variable['mucDichSuDungMoTa'],
        mucDichSuDungId: Variable['mucDichSuDungId'],
        soLuong: Variable['soLuong'],
        donGia: Variable['donGia'],
        thanhTien: Variable['thanhTien'],
      ));
    }
    return ChiTietThanhToanDto(
      tenNguoiThu: json['tenNguoiThu'].toString(),
      ghiChu: json['ghiChu'].toString(),
      lichSuThu: json['lichSuThu'].toString(),
      maBiMat: json['maBiMat'].toString(),
      soHoaDon: json['soHoaDon'].toString(),
      ngayThu: ((json['ngayThu']!=null)? new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").parse(json['ngayThu'].toString()):now_date),
      chiSoCu: int.parse(json['chiSoCu'].toString()),
      chiSoMoi: int.parse(json['chiSoMoi'].toString()),
      tongSuDung: int.parse(json['tongSuDung'].toString()),
      truyThu: int.parse(json['truyThu'].toString()),
      heSoTieuThu: int.parse(json['heSoTieuThu'].toString()),
      tongThanhTien: int.parse(json['tongThanhTien'].toString()),
      vat: int.parse(json['vat'].toString()),
      status: int.parse(json['status'].toString()),
      nguoiThuId: int.parse(json['nguoiThuId'].toString()),
      tongThanhTienSauVat: int.parse(json['tongThanhTienSauVat'].toString()),
      messageStatus: int.parse(json['messageStatus'].toString()),
      isCreateInvoice: json['isCreateInvoice'].toString()=="true",
      thuTu: int.parse(json['thuTu'].toString()),
      paymentType: int.parse(json['paymentType'].toString()),
      phiDuyTriDauNoi: int.parse(json['phiDuyTriDauNoi'].toString()),
      phiBaoVeMoiTruong: int.parse(json['phiBaoVeMoiTruong'].toString()),
      id: int.parse(json['id'].toString()),
      thanhTienChiTiet: posts,
      dongHoId: int.parse(json['dongHoId'].toString()),
      hopDongId: int.parse(json['hopDongId'].toString()),
      soThanhToanId: int.parse(json['soThanhToanId'].toString()),
      sTT: int.parse(json['stt'].toString()),
    );
  }
}
class HopdongDonghoKhoDongHoThanhToanDto {
  int id;
  String sdt;
  String serial;
  String diaChi;
  String maHopDong;
  String tenKhachHang;


  HopdongDonghoKhoDongHoThanhToanDto({
    required this.id,
    required this.sdt,
    required this.serial,
    required this.diaChi,
    required this.maHopDong,
    required this.tenKhachHang,
  });
  factory HopdongDonghoKhoDongHoThanhToanDto.fromJson(Map<String, dynamic> json) {

    return HopdongDonghoKhoDongHoThanhToanDto(
     id: int.parse(json['id'].toString()),
     sdt: json['sdt'].toString(),
     serial: json['serial'].toString(),
     diaChi: json['diaChi'].toString(),
     maHopDong: json['maHopDong'].toString(),
     tenKhachHang: json['tenKhachHang'].toString(),
    );
  }
}

class GetChiTietThanhToanDataDto {
  ChiTietThanhToanDto chiTietThanhToan;
  HopdongDonghoKhoDongHoDto hopdongDonghoKhoDongHoDto;
  String dongHoDiaChi;
  String daukycuoiky;
  String kinhDo;
  String viDo;
  String soThanhToanTenSo;
  GetChiTietThanhToanDataDto({required this.chiTietThanhToan,required this.dongHoDiaChi,required this.daukycuoiky,required this.kinhDo,required this.viDo,required this.soThanhToanTenSo,required this.hopdongDonghoKhoDongHoDto});
  factory GetChiTietThanhToanDataDto.fromJson(Map<String, dynamic> json) {
    return GetChiTietThanhToanDataDto(
      chiTietThanhToan: ChiTietThanhToanDto.fromJson(json['chiTietThanhToan']),
      hopdongDonghoKhoDongHoDto: HopdongDonghoKhoDongHoDto.fromJson(json['hopdongDonghoKhoDongHoDto']),
      dongHoDiaChi: json['dongHoDiaChi'],
      daukycuoiky: json['daukycuoiky'],
      kinhDo: json['kinhDo'],
      viDo: json['viDo'],
      soThanhToanTenSo: json['soThanhToanTenSo'],
    );
  }
}

class GetChiTietThanhToanDataResultDto {
  bool status;
  String message;
  List<GetChiTietThanhToanDataDto> data;

  GetChiTietThanhToanDataResultDto({required this.status, required this.message, required this.data});

  factory GetChiTietThanhToanDataResultDto.fromJson(Map<String, dynamic> jsons) {
    var streetsFromJson = jsons['result']['data'];
    List<GetChiTietThanhToanDataDto> posts = [];
    for (var Variable in streetsFromJson) {
      posts.add(new GetChiTietThanhToanDataDto(
        daukycuoiky: Variable['daukycuoiky'],
        dongHoDiaChi: Variable['dongHoDiaChi'],
        kinhDo: Variable['kinhDo'],
        viDo: Variable['viDo'],
        soThanhToanTenSo: Variable['soThanhToanTenSo'],
        chiTietThanhToan: ChiTietThanhToanDto.fromJson(Variable['chiTietThanhToan']),
        hopdongDonghoKhoDongHoDto: HopdongDonghoKhoDongHoDto.fromJson(Variable['hopdongDonghoKhoDongHoDto']),
      ));
    }
    return GetChiTietThanhToanDataResultDto(
        status: jsons['result']['status'],
        message: jsons['result']['message'],
        data: posts
    );
  }
}