import 'dart:convert';

import 'dart:io';
import 'dart:typed_data';
import '../../GetKyThu/GetKyThuDto.dart';
import '../../System/Constant.dart';
import '../../System/Lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../model/login_data_model.dart';
import 'package:intl/intl.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
_showCupertinoDialog(String title, String content, BuildContext context) {
  showDialog(
      context: context,
      builder: (_) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(content),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Đóng!'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ));
}

//update ghichiso
void updateGhichiso(int id, int chisomoi, int userid, int selectedKyThu,
    int tongsudung, String ghichu, BuildContext context) async {
  try {
    final response = await readFile("user" +
        userid.toString() +
        "dataKyThuHoGiaDinh" +
        selectedKyThu.toString() +
        ".data");
    if (response != "N/A") {
      GetGhiChiSoDataResultDto result =
      GetGhiChiSoDataResultDto.fromJson(jsonDecode(response));
      for (GetGhiChiSoDataDto data in result.data) {
        if (data.ghiChiSo.id == id) {
          data.ghiChiSo.chiSoMoi = chisomoi;
          data.ghiChiSo.tongSuDung = tongsudung;
          data.ghiChiSo.ghiChu = ghichu;
          break;
        }
      }
      var t = jsonEncode(result.toJson())
          .replaceAll("\\", "")
          .replaceAll('"[', "[")
          .replaceAll(']"', ']')
          .replaceAll('"{', '{')
          .replaceAll('}",', '},');

      writeFile(
          "user" +
              userid.toString() +
              "dataKyThuHoGiaDinh" +
              selectedKyThu.toString() +
              ".data",
          t);
    } else {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(const SnackBar(
            content: Text(
                "Không tải được file dữ liệu. Vui lòng cập nhật sổ ghi chỉ số!")));
    }
  } catch (e) {
    _showCupertinoDialog('Lỗi', e.toString() + '!', context);
  }
}
//end update ghi chi so

class ThucHienThu extends StatefulWidget {
  ThucHienThu(
      {Key? key,
        required this.name,
        required this.address,
        required this.id,
        required this.title,
        required this.isLoggedIn,
        required this.isLoggedInOffline,
        required this.token,
        required this.username,
        required this.userid,
        required this.thang,
        required this.nam,
        required this.status,
        required this.chiTietThanhToanDataDto})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final String token;
  final bool isLoggedIn;
  final bool isLoggedInOffline;
  final String username;
  final int userid;
  final String name;
  final String address;
  final int id;
  final int thang;
  final int nam;
  final bool status;
  final GetChiTietThanhToanDataDto chiTietThanhToanDataDto;

  @override
  _ThucHienThuState createState() => _ThucHienThuState();
}

class ItemSelectBox {
  const ItemSelectBox(this.name, this.icon, this.value);

  final String name;
  final Icon icon;
  final int value;
}

class _ThucHienThuState extends State<ThucHienThu> {
  var client = new http.Client();
  late TextEditingController _chisomoi;
  // BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  // List<BluetoothDevice> _devices = [];
  // BluetoothDevice _device;
  bool _connected = false;
  bool _pressed = false;
  late String pathImage;
  @override
  void initState() {
    super.initState();

    // Future.delayed(Duration.zero, () {
    //   initPlatformState();
    // });
    _chisomoi = TextEditingController(
        text: widget.chiTietThanhToanDataDto.chiTietThanhToan.chiSoMoi
            .toString());
  }

  //printer
  // Future<void> initPlatformState() async {
  //   List<BluetoothDevice> devices = [];
  //
  //   try {
  //     devices = await bluetooth.getBondedDevices();
  //   } on PlatformException {
  //     // TODO - Error
  //   }
  //
  //   bluetooth.onStateChanged().listen((state) {
  //     switch (state) {
  //       case BlueThermalPrinter.CONNECTED:
  //         setState(() {
  //           _connected = true;
  //           _pressed = false;
  //         });
  //         break;
  //       case BlueThermalPrinter.DISCONNECTED:
  //         setState(() {
  //           _connected = false;
  //           _pressed = false;
  //         });
  //         break;
  //       default:
  //         print(state);
  //         break;
  //     }
  //   });
  //
  //   if (!mounted) return;
  //   setState(() {
  //     _devices = devices;
  //     if(devices.length>0){
  //       for(var _devicesss in devices){
  //         if(_devicesss.name=="EP-58A"){
  //           _device=_devicesss;
  //           break;
  //         }
  //       }
  //     }
  //   });
  // }
  //
  // List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
  //   List<DropdownMenuItem<BluetoothDevice>> items = [];
  //   if (_devices.isEmpty) {
  //     items.add(DropdownMenuItem(
  //       child: Text('NONE'),
  //     ));
  //   } else {
  //     _devices.forEach((device) {
  //       items.add(DropdownMenuItem(
  //         child: Text(device.name),
  //         value: device,
  //       ));
  //     });
  //   }
  //   return items;
  // }
  //
  // void _connect() {
  //   if (_device == null) {
  //     showNotice('Không có máy in bluetooth nào được kết nối',context);
  //   } else {
  //
  //     bluetooth.isConnected.then((isConnected) {
  //       if (!isConnected) {
  //         if (!isConnected) {
  //           bluetooth.connect(_device).catchError((error) {
  //             showNotice("Lỗi: Không thể kết nối thiết bị bluetooth", context);
  //             setState(() => _pressed = false);
  //           });
  //           setState(() => _pressed = true);
  //         }
  //       }
  //     });
  //   }
  // }

  // void _disconnect() {
  //   bluetooth.disconnect();
  //   setState(() => _pressed = true);
  // }
//write to app path
  int Indexcut(String str) {
    int i;
    int i2 = 31;
    while (true) {
      if (i2 < 0) {
        i = 0;
        break;
      }
      i = i2 + 1;
      if (str.substring(i2, i).compareTo(" ") == 0) {
        break;
      }
      i2--;
    }
    if (i == 0) {
      return 31;
    }
    return i;
  }

  String GetStringFormatBlueTooth(String str) {
     String str2 = "";
    String str3 = "";
    if (str.length == 0) {
      return "";
    }
    String str4 = str;
    bool z = true;
    while (z) {
      try {
        if (str4.length <= 32) {
          str3 = str3 + str4;
          z = false;
        } else {
          int indexcut = Indexcut(str4);
          str3 = str3 + str4.substring(0, indexcut) + "\n";
          str4 = str4.substring(indexcut, str4.length);
        }
      } catch (unused) {
    return "";
    }
    }
    String str5 = "";
    int i = 0;
    while (i <= str3.length - 1) {
    int i2 = i + 1;
    int indexOf = CharList().indexOf(str3.substring(i, i2), 0);
    if (indexOf > 0) {
    String sb="";
    sb+=str5;
    str2 =sb+CharToHexCode(str3.substring(i, i2));
    }
    else {

    }
    str5 = str2;
    i = i2;
    }
    return str5;
  }
  Uint8List SendByteData(String str) {
    String replace = str.replaceAll(" ", "");
    Uint8List bArr = new Uint8List(replace.length ~/ 2);
    int i = 0;
    int i2 = 0;
    while (i < replace.length - 1) {
      int i3 = i + 2;
      bArr[i2] = int.parse(replace.substring(i, i3),radix: 16);
      i2++;
      i = i3;
    }
    return bArr;
  }
  // void _tesPrint(GetChiTietThanhToanDataDto chiTietThanhToanDataDto,String title) async {
  //   //SIZE
  //   // 0- normal size text
  //   // 1- only bold text
  //   // 2- bold with medium text
  //   // 3- bold with large text
  //   //ALIGN
  //   // 0- ESC_ALIGN_LEFT
  //   // 1- ESC_ALIGN_CENTER
  //   // 2- ESC_ALIGN_RIGHT
  //
  //   bluetooth.isConnected.then((isConnected) async {
  //
  //     if (isConnected) {
  //       final f = NumberFormat("#,###", "vi_VN");
  //       // String testString = "CÔNG TY CỔ PHẦN ĐẦU TƯ XÂY DỰNG DƯƠNG KINH";
  //       // bluetooth.printCustom(testString, 1, 1, charset: "utf-8");
  //       // List<int> tts=[450];
  //       //
  //       // Uint8List encoded = await CharsetConverter.encode("UTF8", "CÔNG TY CỔ PHẦN ĐẦU TƯ XÂY DỰNG DƯƠNG KINH");
  //       // Uint8List encoded = Uint8List.fromList(tts);
  //       // var t = encoded.toString();
  //       // bluetooth.writeBytes(encoded);
  //       // bluetooth.printCustom("CÔNG TY CỔ PHẦN ĐẦU TƯ XÂY DỰNG DƯƠNG KINH", 1, 1, charset: "utf-8");
  //
  //       bluetooth.writeBytes(SendByteData( GetStringFormatBlueTooth("CÔNG TY CỔ PHẦN ĐẦU TƯ XÂY DỰNG DƯƠNG KINH")));
  //       bluetooth.printNewLine();
  //       bluetooth.writeBytes(SendByteData( GetStringFormatBlueTooth(title)));
  //       bluetooth.printNewLine();
  //       bluetooth.printCustom("-----------------", 1, 1);
  //       bluetooth.writeBytes(SendByteData( GetStringFormatBlueTooth("Kỳ hóa đơn: "+widget.thang.toString()+"/"+widget.nam.toString())));
  //       bluetooth.printNewLine();
  //       bluetooth.writeBytes(SendByteData( GetStringFormatBlueTooth("Mã KH: "+widget.chiTietThanhToanDataDto.hopdongDonghoKhoDongHoDto.maHopDong)));
  //       bluetooth.printNewLine();
  //       bluetooth.writeBytes(SendByteData( GetStringFormatBlueTooth("KH: "+widget.chiTietThanhToanDataDto.hopdongDonghoKhoDongHoDto.tenKhachHang)));
  //       bluetooth.printNewLine();
  //       bluetooth.writeBytes(SendByteData( GetStringFormatBlueTooth("Đ/c: "+widget.chiTietThanhToanDataDto.hopdongDonghoKhoDongHoDto.diaChi)));
  //       bluetooth.printNewLine();
  //       bluetooth.writeBytes(SendByteData( GetStringFormatBlueTooth("Điện thoại: "+widget.chiTietThanhToanDataDto.hopdongDonghoKhoDongHoDto.sdt)));
  //       bluetooth.printNewLine();
  //       bluetooth.writeBytes(SendByteData( GetStringFormatBlueTooth("Số hóa đơn: "+widget.chiTietThanhToanDataDto.chiTietThanhToan.soHoaDon)));
  //       bluetooth.printNewLine();
  //       bluetooth.writeBytes(SendByteData( GetStringFormatBlueTooth(widget.chiTietThanhToanDataDto.daukycuoiky)));
  //       bluetooth.printNewLine();
  //
  //       bluetooth.printLeftRight("CSC: "+widget.chiTietThanhToanDataDto.chiTietThanhToan.chiSoCu.toString(), "CSM: "+widget.chiTietThanhToanDataDto.chiTietThanhToan.chiSoMoi.toString(), 0, charset: "utf-8");
  //       bluetooth.printLeftRight("SL(m3) x DG", "T.Tien", 1, charset: "utf-8");
  //       for(ThanhTienChiTietDto t in widget.chiTietThanhToanDataDto.chiTietThanhToan.thanhTienChiTiet) {
  //         bluetooth.printLeftRight(
  //             f.format(t.soLuong).toString()+" x "+f.format(t.donGia).toString(),
  //             f.format(t.thanhTien), 1);
  //       }
  //       bluetooth.printCustom("-------------------", 1, 1);
  //       bluetooth.printLeftRight(f.format(widget.chiTietThanhToanDataDto.chiTietThanhToan.tongSuDung).toString(), f.format(widget.chiTietThanhToanDataDto.chiTietThanhToan.tongThanhTien).toString(), 1, charset: "utf-8");
  //       bluetooth.printLeftRight("Thue GTGT (5%):", f.format(widget.chiTietThanhToanDataDto.chiTietThanhToan.vat).toString(), 1, charset: "utf-8");
  //       bluetooth.printLeftRight("Tong tien:", f.format(widget.chiTietThanhToanDataDto.chiTietThanhToan.tongThanhTienSauVat).toString(), 1, charset: "utf-8");
  //       bluetooth.printNewLine();
  //       bluetooth.writeBytes(SendByteData( GetStringFormatBlueTooth("Bằng chữ: "+DocTienBangChu(widget.chiTietThanhToanDataDto.chiTietThanhToan.tongThanhTienSauVat, " đồng"))));
  //
  //       bluetooth.printNewLine();
  //       //
  //       var formatter = new DateFormat('dd/MM/yyyy');
  //       bluetooth.writeBytes(SendByteData( GetStringFormatBlueTooth("Ngày in phiếu: "+formatter.format(DateTime.now()))));
  //       bluetooth.printNewLine();
  //       bluetooth.writeBytes(SendByteData( GetStringFormatBlueTooth("NV Thu:"+widget.chiTietThanhToanDataDto.chiTietThanhToan.tenNguoiThu)));
  //       bluetooth.printNewLine();
  //       bluetooth.writeBytes(SendByteData( GetStringFormatBlueTooth("Tra cứu hóa đơn điện tử tại Website: https://sinvoice.viettel.vn/tracuuhoadon. Mã số bí mật: "+widget.chiTietThanhToanDataDto.chiTietThanhToan.maBiMat+" hoặc liên hệ số điện thoại: 02252.835.069")));
  //       bluetooth.printNewLine();
  //       bluetooth.printNewLine();
  //       bluetooth.printNewLine();
  //       bluetooth.paperCut();
  //     }
  //   });
  // }



  //endprinter

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    bool isLoggedIn = widget.isLoggedIn;
    String token = widget.token;
    String username = widget.username;
    int userid = widget.userid;
    final f = NumberFormat("#,### VNĐ", "vi_VN");
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          actions: <Widget>[],
        ),
        body: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  // Column is also a layout widget. It takes a list of children and
                  // arranges them vertically. By default, it sizes itself to fit its
                  // children horizontally, and tries to be as tall as its parent.
                  //
                  // Invoke "debug painting" (press "p" in the console, choose the
                  // "Toggle Debug Paint" action from the Flutter Inspector in Android
                  // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
                  // to see the wireframe for each widget.
                  //
                  // Column has various properties to control how it sizes itself and
                  // how it positions its children. Here we use mainAxisAlignment to
                  // center the children vertically; the main axis here is the vertical
                  // axis because Columns are vertical (the cross axis would be
                  // horizontal).
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: (Column(
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  color: Colors.green,
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(widget.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.white,
                                            )),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              const WidgetSpan(
                                                child: Icon(
                                                  Icons.location_on_outlined,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              TextSpan(
                                                  text: widget.address,
                                                  style: const TextStyle(
                                                    fontWeight:
                                                    FontWeight.normal,
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              const WidgetSpan(
                                                child: Icon(
                                                  Icons.phone,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              TextSpan(
                                                  text: widget.chiTietThanhToanDataDto.hopdongDonghoKhoDongHoDto.sdt,
                                                  style: const TextStyle(
                                                    fontWeight:
                                                    FontWeight.normal,
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),

                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              const WidgetSpan(
                                                child: Icon(Icons.lock_clock,
                                                    size: 18,
                                                    color: Colors.white),
                                              ),
                                              TextSpan(
                                                  text: " CSC: " +
                                                      widget
                                                          .chiTietThanhToanDataDto
                                                          .chiTietThanhToan
                                                          .chiSoCu
                                                          .toString() +
                                                      "   ",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                  )),
                                              const WidgetSpan(
                                                child: Icon(Icons.lock_clock,
                                                    size: 18,
                                                    color: Colors.white),
                                              ),
                                              TextSpan(
                                                  text: " CSM: " +
                                                      widget
                                                          .chiTietThanhToanDataDto
                                                          .chiTietThanhToan
                                                          .chiSoMoi
                                                          .toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              const WidgetSpan(
                                                child: Icon(
                                                  Icons.calculate,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              TextSpan(
                                                  text: "Tổng sử dụng: " +
                                                      widget
                                                          .chiTietThanhToanDataDto
                                                          .chiTietThanhToan
                                                          .tongSuDung
                                                          .toString(),
                                                  style: const TextStyle(
                                                    fontWeight:
                                                    FontWeight.normal,
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              const WidgetSpan(
                                                child: Icon(
                                                  Icons.money_outlined,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              TextSpan(
                                                  text: "Tổng tiền: " +
                                                      f
                                                          .format(widget
                                                          .chiTietThanhToanDataDto
                                                          .chiTietThanhToan
                                                          .tongThanhTienSauVat)
                                                          .toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),Align(
                                        alignment: Alignment.centerLeft,
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              const WidgetSpan(
                                                child: Icon(
                                                  Icons.money_outlined,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              TextSpan(
                                                  text: "Bằng chữ: " +
                                                      DocTienBangChu(widget
                                                          .chiTietThanhToanDataDto
                                                          .chiTietThanhToan
                                                          .tongThanhTienSauVat," đồng"),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              const WidgetSpan(
                                                child: Icon(
                                                  Icons.date_range,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              TextSpan(
                                                  text: "Ngày thu: "+((widget.chiTietThanhToanDataDto.chiTietThanhToan.ngayThu!=null)?DateFormat("dd/MM/yyyy hh:mm:ss a").format(widget.chiTietThanhToanDataDto.chiTietThanhToan.ngayThu):""),
                                                  style: const TextStyle(
                                                    fontWeight:
                                                    FontWeight.normal,
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              const WidgetSpan(
                                                child: Icon(
                                                  Icons.people_alt_outlined,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              TextSpan(
                                                  text: "Nguoi thu: "+widget.chiTietThanhToanDataDto.chiTietThanhToan.tenNguoiThu,
                                                  style: const TextStyle(
                                                    fontWeight:
                                                    FontWeight.normal,
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))),
                          Padding(
                              padding: const EdgeInsets.all(0),
                              child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: const BoxDecoration(),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          ((!widget.status)?ElevatedButton(
                                              onPressed: () async {
                                                bool result = await showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: const Text('Xác nhận thanh toán'),
                                                      content: const Text('Bạn có muốn thanh toán cho hộ này không?'),
                                                      actions: <Widget>[
                                                        new TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context, rootNavigator: true)
                                                                .pop(false); // dismisses only the dialog and returns false
                                                          },
                                                          child: const Text('No'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context, rootNavigator: true)
                                                                .pop(true); // dismisses only the dialog and returns true
                                                          },
                                                          child: const Text('Yes'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );

                                                if (result) {
                                                  if(!_connected){
                                                    // _connect();
                                                  };

                                                  if(!_connected){
                                                    // _tesPrint(widget.chiTietThanhToanDataDto,"BIÊN NHẬN THANH TOÁN");
                                                    var t = updateThanhToan(client, widget.username, widget.chiTietThanhToanDataDto.chiTietThanhToan.id, context);
                                                    t.then((value){
                                                      if(value){
                                                        Navigator.pop(
                                                            context,
                                                            new ReturnBackFromGhiChiSo(
                                                                status: true,
                                                                chisomoi: int.parse(
                                                                    _chisomoi.text),
                                                                anh: "",
                                                                ghichu: ""
                                                            ));
                                                      }else{
                                                        Navigator.pop(
                                                            context,
                                                            new ReturnBackFromGhiChiSo(
                                                                status: false,
                                                                chisomoi: int.parse(
                                                                    _chisomoi.text),
                                                                anh: "",
                                                                ghichu: ""
                                                            ));
                                                      }
                                                    });

                                                  }
                                                } else {

                                                }

                                              },
                                              child: const Text(
                                                  "Thanh toán và in phiếu thu")):
                                          ElevatedButton(
                                              onPressed: () async {
                                                bool result = await showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: const Text('Xác nhận hủy thanh toán'),
                                                      content: const Text('Bạn có muốn hủy thanh toán hộ này không?'),
                                                      actions: <Widget>[
                                                        new TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context, rootNavigator: true)
                                                                .pop(false); // dismisses only the dialog and returns false
                                                          },
                                                          child: const Text('No'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context, rootNavigator: true)
                                                                .pop(true); // dismisses only the dialog and returns true
                                                          },
                                                          child: const Text('Yes'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );

                                                if (result) {
                                                  if(!_connected){
                                                    // _connect();
                                                  };

                                                  if(!_connected){

                                                    var t = updateHuyThanhToan(client, widget.username, widget.chiTietThanhToanDataDto.chiTietThanhToan.id, context);
                                                    t.then((value){
                                                      if(value){
                                                        Navigator.pop(
                                                            context,
                                                            new ReturnBackFromGhiChiSo(
                                                                status: false,
                                                                chisomoi: int.parse(
                                                                    _chisomoi.text),
                                                                anh: "",
                                                                ghichu: ""
                                                            ));
                                                      }else{
                                                        Navigator.pop(
                                                            context,
                                                            new ReturnBackFromGhiChiSo(
                                                                status: true,
                                                                chisomoi: int.parse(
                                                                    _chisomoi.text),
                                                                anh: "",
                                                                ghichu: ""
                                                            ));
                                                      }
                                                    });

                                                  }
                                                } else {

                                                }

                                              },
                                              child: const Text(
                                                  "Hủy Thanh toán"))
                                          ),
                                          const Text("   "),
                                          ElevatedButton(
                                              onPressed: () {
                                                if(!_connected){
                                                  // _connect();
                                                };
                                                if(!_connected){
                                                  // _tesPrint(widget.chiTietThanhToanDataDto,"    GIẤY BÁO");
                                                  Navigator.pop(
                                                      context, 'ghichu');
                                                }
                                              },
                                              child: const Text("In thông báo")),
                                        ],
                                      )
                                    ],
                                  ))),

                        ],
                      )),
                    )
                  ],
                )),
          ),
        )

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
Future<bool> updateThanhToan(http.Client client,String account, int id, BuildContext context) async {
  showLoadingIndicator("Tải file dữ liệu", context);
  final responseOffline = await readFile(account+"auth.data");
  final LoginOfflineData data = LoginOfflineData.fromJson(
      json.decode(responseOffline));
  hideOpenDialog(context);
  if(responseOffline == "N/A"){
    _showCupertinoDialog('Lỗi',
        'Không tải được file dữ liệu. Vui lòng đăng nhập online trước!',
        context);
    return false;
  }
  else{
    showLoadingIndicator("Đăng nhập vào hệ thống ...", context);
    final responseLogin = await client.post(
      Uri.https($GetServer,
          "api/services/app/MobileAppServices/MobileLogin"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'accountName': account,
        'passWord': data.password,
      }),
    );
    hideOpenDialog(context);
    LoginRequestResult loginRequestResult = LoginRequestResult.fromJson(jsonDecode(responseLogin.body));
    if (responseLogin.statusCode != 200) {
      _showCupertinoDialog('Lỗi', 'Tài khoản hoặc mật khẩu online đã thay đổi!', context);
      return false;
    }
    else{
      showLoadingIndicator("Cập nhật dữ liệu lên server ...", context);
      final response = await client.post(
        Uri.https($GetServer,
            "api/services/app/MobileAppServices/ThanhToan"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userid': loginRequestResult.result!.userid.toString(),
          'token': loginRequestResult.result!.token,
          'thanhToanId': id.toString()
        }),
      );
      hideOpenDialog(context);
      // Use the compute function to run parsePhotos in a separate isolate.
      if (response.statusCode == 200) {


        var value= GetCommonResultDto.fromJson(jsonDecode(response.body));

        if (value.status) {
          showNotice("Thành công! "+value.message, context);
          return true;
        } else {
          showNotice("Lỗi! "+value.message, context);
          return false;
        }
      } else {
        _showCupertinoDialog(
            'Lỗi', 'Thông tin kết nối không chính xác!', context);
        return false;
      }
    }
  }
}
Future<bool> updateHuyThanhToan(http.Client client,String account, int id, BuildContext context) async {
  showLoadingIndicator("Tải file dữ liệu", context);
  final responseOffline = await readFile(account+"auth.data");
  final LoginOfflineData data = LoginOfflineData.fromJson(
      json.decode(responseOffline));
  hideOpenDialog(context);
  if(responseOffline == "N/A"){
    _showCupertinoDialog('Lỗi',
        'Không tải được file dữ liệu. Vui lòng đăng nhập online trước!',
        context);
    return false;
  }
  else{
    showLoadingIndicator("Đăng nhập vào hệ thống ...", context);
    final responseLogin = await client.post(
      Uri.https($GetServer,
          "api/services/app/MobileAppServices/MobileLogin"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'accountName': account,
        'passWord': data.password,
      }),
    );
    hideOpenDialog(context);
    LoginRequestResult loginRequestResult = LoginRequestResult.fromJson(jsonDecode(responseLogin.body));
    if (responseLogin.statusCode != 200) {
      _showCupertinoDialog('Lỗi', 'Tài khoản hoặc mật khẩu online đã thay đổi!', context);
      return false;
    }
    else{
      showLoadingIndicator("Cập nhật dữ liệu lên server ...", context);
      final response = await client.post(
        Uri.https($GetServer,
            "api/services/app/MobileAppServices/HuyThanhToan"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userid': loginRequestResult.result!.userid.toString(),
          'token': loginRequestResult.result!.token,
          'thanhToanId': id.toString()
        }),
      );
      hideOpenDialog(context);
      // Use the compute function to run parsePhotos in a separate isolate.
      if (response.statusCode == 200) {


        var value= GetCommonResultDto.fromJson(jsonDecode(response.body));

        if (value.status) {
          showNotice("Thành công! "+value.message, context);
          return true;
        } else {
          showNotice("Lỗi! "+value.message, context);
          return false;
        }
      } else {
        _showCupertinoDialog(
            'Lỗi', 'Thông tin kết nối không chính xác!', context);
        return false;
      }
    }
  }
}