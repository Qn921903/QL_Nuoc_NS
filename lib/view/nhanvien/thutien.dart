import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

import '../../GetKyThu/GetKyThuDto.dart';
import '../../System/Constant.dart';
import '../../System/Lib.dart';
import 'ds_trangthai_thutien.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../model/login_data_model.dart';
import 'package:intl/intl.dart';

_showCupertinoDialog(String title, String content, BuildContext context) {
  showDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
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

class ThuTien extends StatefulWidget {
  ThuTien(
      {Key ?key,
        required this.title,
        required this.isLoggedIn,
        required this.isLoggedInOffline,
        required this.token,
        required this.username,
        required this.userid})
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

  @override
  _ThuTienState createState() => _ThuTienState();
}

class ItemSelectBox {
  const ItemSelectBox(this.name, this.icon, this.value);

  final String name;
  final Icon icon;
  final int value;
}

class _ThuTienState extends State<ThuTien> {
  var client = http.Client();
  late int selectedKyThu;
  late String selectedKyThuName;
  late Future<GetSoThanhToanDataResultDto> _dataSoThanhToan;
  var selectedKyThuNameArray = [];
  List<Widget> _selectActions = [];

  Future<GetSoThanhToanDataResultDto> getData(http.Client client,
      String account, bool isLoggedInOffline, context) async {
    showLoadingIndicator("Tải file dữ liệu", context);
    final responseOffline = await readFile("${account}auth.data");
    final LoginOfflineData data =
    LoginOfflineData.fromJson(json.decode(responseOffline));
    hideOpenDialog(context);
    if (responseOffline == "N/A") {
      return GetSoThanhToanDataResultDto(
          status: false,
          message:
          'Không tải được file dữ liệu. Vui lòng đăng nhập online trước!', data: []);
    } else {
      showLoadingIndicator("Đăng nhập vào hệ thống ...", context);
      final responseLogin = await client.post(
        Uri.https($GetServer, "api/services/app/MobileAppServices/MobileLogin"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'accountName': account,
          'passWord': data.password,
          'tenantId': data.tenantid.toString(),
        }),
      );
      hideOpenDialog(context);
      LoginRequestResult loginRequestResult =
      LoginRequestResult.fromJson(jsonDecode(responseLogin.body));
      if (responseLogin.statusCode != 200) {
        return GetSoThanhToanDataResultDto(
            status: false,
            message: "Tài khoản hoặc mật khẩu online đã thay đổi!", data: []);
      } else {
        showLoadingIndicator("Lấy dữ liệu từ server ...", context);
        final response = await client.post(
          Uri.https($GetServer,
              "api/services/app/MobileAppServices/GetAllSoThanhToan"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'userid': loginRequestResult.result!.userid.toString(),
            'token': loginRequestResult.result!.token,
            'tenantId':data.tenantid.toString(),
          }),
        );
        hideOpenDialog(context);
        // Use the compute function to run parsePhotos in a separate isolate.
        if (response.statusCode == 200) {
          return GetSoThanhToanDataResultDto.fromJson(
              jsonDecode(response.body));
        } else {
          return GetSoThanhToanDataResultDto(
              status: false, message: "Thông tin kết nối không chính xác!", data: []);
        }
      }
    }
  }

  late Future<GetSoThanhToanDataResultDto> _response;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _response = getData(client, widget.username, false, context);
      _response.then((value) {
        if (value.status) {
          for (GetSoThanhToanDataDto data in value.data) {
            setState(() {
              _selectActions.add(SelectAction(
                name: "[${data.soThanhToan.nam}/${data.soThanhToan.thang}] - ${data.soThanhToan.tenSo}",
                action: "",
                token: widget.token,
                isLoggedIn: true,
                isLoggedInOffline: false,
                username: widget.username,
                userid: widget.userid,
                dathanhtoan: data.soKhachHangDaThu,
                dathu: data.soTienDaThu,
                tongSoTien: data.tongSoTien,
                tongSoKhachHang: data.tongSoKhachHang,
                id: data.soThanhToan.id,
                thang:data.soThanhToan.thang,
                nam:data.soThanhToan.nam, address: '',
              ));
            });
          }
        } else {
          showNotice(value.message, context);
          Navigator.pop(context);
        }
      });
    });
  }

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
    var check = checkInternetConnection();
    check.then((value) {
      if (!value) {
        showNotice("Không thể kết nối internet!", context);
        Navigator.pop(context);
      }
    });

    void _onSelectChanged(int newValue) => setState(() {
      selectedKyThu = newValue;
      for (var t in selectedKyThuNameArray) {
        if (t.id == newValue) {
          selectedKyThuName = t.displayText;
          break;
        }
      }
    });

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          actions: <Widget>[

          ],
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
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
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Xin chào $username",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                          const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Hãy chọn sổ thu!",
                                  style: TextStyle(),
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: (Column(
                              children: _selectActions,
                            )),
                          ),
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

class SelectAction extends StatefulWidget {
  SelectAction(
      {Key? key,
        required this.name,
        required this.address,
        required this.id,
        required this.thang,
        required this.nam,
        required this.dathanhtoan,
        required this.dathu,
        required this.tongSoTien,
        required this.tongSoKhachHang,
        required this.action,
        required this.token,
        required this.isLoggedIn,
        required this.isLoggedInOffline,
        required this.username,
        required this.userid})
      : super(key: key);
  final String name;
  final String address;
  final String action;
  // late IconData icon;
  late Color color;
  final String token;
  final bool isLoggedIn;
  final bool isLoggedInOffline;
  final String username;
  final int userid;
  final int id;
  final int dathanhtoan;
  final int dathu;
  final int tongSoTien;
  final int tongSoKhachHang;
  final int thang;
  final int nam;

  @override
  _SelectActionState createState() => _SelectActionState();
}

class _SelectActionState extends State<SelectAction> {
  late String name;
  late String address;
  late String action;
  late IconData icon;
  // late Color color;
  late String token;
  late bool isLoggedIn;
  late bool isLoggedInOffline;
  late String username;
  late int userid;
  late int id;
  late int chisomoi;
  late int chisocu;
  late int tongsudung;
  late int dathanhtoan;
  late int dathu;
  late int heSoTieuThu;
  late String ghichu;
  late bool status;
  late int thang;
  late int nam;

  @override
  void initState() {
    name = widget.name;
    address = widget.address;
    action = widget.action;
    // icon = widget.icon;
    // color = widget.color;
    token = widget.token;
    isLoggedIn = widget.isLoggedIn;
    isLoggedInOffline = widget.isLoggedInOffline;
    username = widget.username;
    userid = widget.userid;
    id = widget.id;
    dathanhtoan = widget.dathanhtoan;
    dathu = widget.dathu;
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ListThanhToan(
            title: name,
            isLoggedIn: isLoggedIn,
            isLoggedInOffline: isLoggedInOffline,
            token: token,
            username: username,
            userid: userid,
            selectedKyThu: widget.id,
            selectedKyThuName: widget.name,
            thang: widget.thang,
            nam: widget.nam,
          )),
      // MaterialPageRoute(builder: (context) => MyApp()),
    );

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    // if (result.toString() != "ghichu" && result != null) {
    //   setState(() {
    //     chisomoi = result.chisomoi;
    //     status = result.status;
    //     tongsudung = (chisomoi - chisocu) * heSoTieuThu;
    //   });
    // }
  }

  handleList(BuildContext context) async{
    await Navigator.push(
        context,
        MaterialPageRoute(
        builder: (context) => ListThanhToan(
      title: name,
      isLoggedIn: isLoggedIn,
      isLoggedInOffline: isLoggedInOffline,
      token: token,
      username: username,
      userid: userid,
      selectedKyThu: widget.id,
      selectedKyThuName: widget.name,
      thang: widget.thang,
      nam: widget.nam,
    ))
    );
  }

  @override
  Widget build(BuildContext context) {
    final f = NumberFormat("#,### VNĐ", "vi_VN");
    return Container(
        padding: const EdgeInsets.all(2),
        height: 180,
        child: GestureDetector(
          onTap: () {
            // _navigateAndDisplaySelection(context);
            handleList(context);
          },
          child: Card(
              child: Container(
                  // color: color,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                            child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black,
                                          )),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: RichText(
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                                text:
                                                "Các khách hàng đã lập hóa đơn: ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ))
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
                                              child: Icon(Icons.people_alt,
                                                  size: 18,
                                                  color: Colors.black),
                                            ),
                                            const TextSpan(
                                                text: " Đã thanh toán: ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ))
                                            ,
                                            TextSpan(
                                                text:"${widget.dathanhtoan}/",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14,
                                                  color: (widget.dathanhtoan==widget.tongSoKhachHang)?Colors.lightGreen:Colors.redAccent,
                                                )),
                                            TextSpan(
                                                text:widget.tongSoKhachHang.toString(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14,
                                                  color: Colors.lightGreen,
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
                                                color: Colors.black,
                                              ),
                                            ),
                                            const TextSpan(
                                                text: " Đã thu: ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                )),
                                            TextSpan(
                                                text:"${f.format(widget.dathu)}/",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14,
                                                  color: (widget.dathu==widget.tongSoTien)?Colors.lightGreen:Colors.redAccent,
                                                )),
                                            TextSpan(
                                                text:f.format(widget.tongSoTien).toString(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14,
                                                  color: Colors.lightGreen,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )))
                      ]))),
        ));
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isLoggedIn', isLoggedIn));
    properties.add(IntProperty('thang', thang));
  }
}
