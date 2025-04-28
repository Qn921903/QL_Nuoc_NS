import 'dart:convert';

import 'dart:io';

import '../../GetKyThu/GetKyThuDto.dart';
import '../../model/login_data_model.dart';
import '../../System/Constant.dart';
import '../../System/Lib.dart';
import 'ThucHienThu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
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

class ListThanhToan extends StatefulWidget {
  ListThanhToan(
      {Key? key,
        required this.title,
        required this.isLoggedIn,
        required this.isLoggedInOffline,
        required this.token,
        required this.username,
        required this.userid,
        required this.selectedKyThu,
        required this.selectedKyThuName,
        required this.thang,
        required this.nam})
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
  final int selectedKyThu;
  final String selectedKyThuName;
  final int thang;
  final int nam;

  @override
  _ListThanhToanState createState() => _ListThanhToanState();
}

class ItemSelectBox {
  const ItemSelectBox(this.name, this.icon, this.value);

  final String name;
  final Icon icon;
  final int value;
}
List<SelectAction> _selectActions = [];
class _ListThanhToanState extends State<ListThanhToan> {
  var client = http.Client();
  bool sortStt = true;
  String _filter = "";
  int sortDaghi = 1; //1 all 2 chua ghi 3 da ghi
  late Future<GetChiTietThanhToanDataResultDto> _dataChiTietThanhToan;


  Future<GetChiTietThanhToanDataResultDto> getData(
      http.Client client,
      String account,
      bool isLoggedInOffline,
      int soid,
      BuildContext context) async {
    showLoadingIndicator("Tải file dữ liệu", context);
    final responseOffline = await readFile(account + "auth.data");
    final LoginOfflineData data =
    LoginOfflineData.fromJson(json.decode(responseOffline));
    hideOpenDialog(context);
    if (responseOffline == "N/A") {
      return GetChiTietThanhToanDataResultDto(
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
        }),
      );
      hideOpenDialog(context);
      LoginRequestResult loginRequestResult =
      LoginRequestResult.fromJson(jsonDecode(responseLogin.body));
      if (responseLogin.statusCode != 200) {
        return GetChiTietThanhToanDataResultDto(
            status: false,
            message: "Tài khoản hoặc mật khẩu online đã thay đổi!", data: []);
      } else {
        showLoadingIndicator("Lấy dữ liệu từ server ...", context);
        final response = await client.post(
          Uri.https($GetServer,
              "api/services/app/MobileAppServices/GetAllChiTietThanhToan"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'userid': loginRequestResult.result!.userid.toString(),
            'token': loginRequestResult.result!.token,
            'soThanhToanId': soid.toString()
          }),
        );
        hideOpenDialog(context);
        // Use the compute function to run parsePhotos in a separate isolate.
        if (response.statusCode == 200) {
          return GetChiTietThanhToanDataResultDto.fromJson(
              jsonDecode(response.body));
        } else {
          return GetChiTietThanhToanDataResultDto(
              status: false, message: "Thông tin kết nối không chính xác!", data: []);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _selectActions = [];
    Future.delayed(Duration.zero, () {
      _dataChiTietThanhToan =
          getData(client, widget.username, true, widget.selectedKyThu, context);
      _dataChiTietThanhToan.then((value) {
        for (GetChiTietThanhToanDataDto data in value.data) {
          setState(() {
            _selectActions.add(SelectAction(
              name: data.chiTietThanhToan.sTT.toString() +
                  ", " +
                  data.hopdongDonghoKhoDongHoDto.tenKhachHang +
                  ", " +
                  data.hopdongDonghoKhoDongHoDto.maHopDong +
                  ", " +
                  data.hopdongDonghoKhoDongHoDto.serial,
              action: "",
              status: (data.chiTietThanhToan.status==1)
                  ? true
                  : false,
              token: widget.token,
              isLoggedIn: widget.isLoggedIn,
              isLoggedInOffline: widget.isLoggedInOffline,
              username: widget.username,
              userid: widget.userid,
              address: data.dongHoDiaChi,
              thang: widget.thang,
              nam: widget.nam,
              getChiTietThanhToanDataDto: data, id: 0,
            ));
          });
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
    bool isLoggedInOffline = widget.isLoggedInOffline;
    var check = checkInternetConnection();
    check.then((value) {
      if (!value) {
        showNotice("Không thể kết nối internet!", context);
        Navigator.pop(context);
      }
    });
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: <Widget>[],
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
                                "Xin chào " + username,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.selectedKyThuName,
                                style: const TextStyle(),
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            obscureText: false,
                            onChanged: (value) {
                              setState(() {
                                _filter = value;
                              });
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Tìm kiếm',
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          // Center is a layout widget. It takes a single child and positions it
                          // in the middle of the parent.
                          child: Padding(
                              padding: const EdgeInsets.all(0.0),
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
                                    child: Container(
                                      child: ListView.builder(
                                          physics:
                                          const NeverScrollableScrollPhysics(),
                                          reverse: !sortStt,
                                          shrinkWrap: true,
                                          itemCount: _selectActions.length,
                                          itemBuilder: (context, index) {
                                            return (_filter.trim() != "") ? ((_selectActions[index].name.toLowerCase().contains( _filter.toLowerCase()) || _selectActions[index] .address.toLowerCase().contains( _filter.toLowerCase())) ? (sortDaghi == 1) ? _selectActions[index] : ((sortDaghi == 2) ? ((_selectActions[ index] .status) ? Container() : _selectActions[ index]) : ((!_selectActions[ index] .status) ? Container() : _selectActions[ index])) : Container()) : (sortDaghi == 1) ? _selectActions[index] : ((sortDaghi == 2) ? ((_selectActions[ index] .status) ? Container() : _selectActions[ index]) : ((!_selectActions[ index] .status) ? Container() : _selectActions[ index]));
                                          }),
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ],
                    )),
                  )
                ],
              )),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: (sortStt == true)
                  ? const Icon(Icons.arrow_upward_sharp)
                  : const Icon(Icons.arrow_downward_sharp),
              color: Colors.blue,
              onPressed: () {
                setState(() {
                  sortStt = !sortStt;
                });
              },
            ),
            IconButton(
              icon: (sortDaghi == 1)
                  ? const Icon(Icons.clear_all)
                  : ((sortDaghi == 2)
                  ? const Icon(Icons.cancel_presentation)
                  : const Icon(Icons.check_box)),
              color: Colors.blue,
              onPressed: () {
                setState(() {
                  sortDaghi++;
                  if (sortDaghi == 4) {
                    sortDaghi = 1;
                  }
                });
              },
            ),
          ],
        ),
      ),

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
        required this.action,
        required this.token,
        required this.isLoggedIn,
        required this.username,
        required this.isLoggedInOffline,
        required this.getChiTietThanhToanDataDto,
        required this.userid,
        required this.thang,
        required this.nam,
        required this.status})
      : super(key: key) {
    // TODO: implement SelectAction
    throw UnimplementedError();
  }
  final String name;
  final String address;
  final String action;
late  IconData icon;
 late Color color;
  final String token;
  final bool isLoggedIn;
  final bool isLoggedInOffline;
  final String username;
  final int userid;
  final int id;
  final int thang;
  final int nam;
  final GetChiTietThanhToanDataDto getChiTietThanhToanDataDto;
  bool status;

  @override
  _SelectActionState createState() => _SelectActionState();
}

class _SelectActionState extends State<SelectAction> {
  late String name;
  late String address;
  late String action;
  late IconData icon;
  late Color color;
  late String token;
  late bool isLoggedIn;
  late bool isLoggedInOffline;
  late String username;
  late int userid;
  late int id;
  late GetChiTietThanhToanDataDto chiTietThanhToanDto;
  late int chisomoi;
  late int chisocu;
  late int tongsudung;
  late int heSoTieuThu;
  late String ghichu;
  late bool status;

  @override
  void initState() {
    name = widget.name;
    address = widget.address;
    action = widget.action;
    icon = widget.icon;
    color = widget.color;
    token = widget.token;
    isLoggedIn = widget.isLoggedIn;
    isLoggedInOffline = widget.isLoggedInOffline;
    username = widget.username;
    userid = widget.userid;
    id = widget.id;
    chisomoi = widget.getChiTietThanhToanDataDto.chiTietThanhToan.chiSoMoi;
    chiTietThanhToanDto = widget.getChiTietThanhToanDataDto;
    chisocu = widget.getChiTietThanhToanDataDto.chiTietThanhToan.chiSoCu;
    tongsudung = widget.getChiTietThanhToanDataDto.chiTietThanhToan.tongSuDung;
    heSoTieuThu =
        widget.getChiTietThanhToanDataDto.chiTietThanhToan.heSoTieuThu;
    ghichu = widget.getChiTietThanhToanDataDto.chiTietThanhToan.ghiChu;
    status = widget.status;
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ThucHienThu(
              title: name,
              isLoggedIn: isLoggedIn,
              isLoggedInOffline: isLoggedInOffline,
              token: token,
              username: username,
              userid: userid,
              name: name,
              address: address,
              chiTietThanhToanDataDto: widget.getChiTietThanhToanDataDto,
              id: id,
              thang: widget.thang,
              nam: widget.nam,
              status: widget.status)),
      // MaterialPageRoute(builder: (context) => MyApp()),
    );

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    if (result.toString() != "ghichu" && result != null) {
      setState(() {
        status = result.status;
        status=result.status;
        _selectActions[_selectActions.indexOf(widget)].status=result.status;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    icon = (status) ? Icons.check : Icons.remove;
    color = (status) ? Colors.lightGreen : Colors.redAccent;
    final f = NumberFormat("#,### VNĐ", "vi_VN");
    return Container(
        padding: const EdgeInsets.all(2),
        height: 220,
        child: GestureDetector(
          onTap: () {
            _navigateAndDisplaySelection(context);
          },
          child: Card(
              child: Container(
                  color: Colors.white,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Icon(
                            icon,
                            size: 28,
                            color: Colors.black,
                          ),
                        ),
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
                                        text: TextSpan(
                                          children: [
                                            const WidgetSpan(
                                              child: Icon(
                                                Icons.location_on_outlined,
                                                size: 18,
                                                color: Colors.black,
                                              ),
                                            ),
                                            TextSpan(
                                                text: address,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14,
                                                  color: Colors.black,
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
                                                  color: Colors.black),
                                            ),
                                            TextSpan(
                                                text: " CSC: " +
                                                    chisocu.toString() +
                                                    "   ",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                )),
                                            const WidgetSpan(
                                              child: Icon(Icons.lock_clock,
                                                  size: 18,
                                                  color: Colors.black),
                                            ),
                                            TextSpan(
                                                text: " CSM: " +
                                                    chisomoi.toString(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Colors.black,
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
                                                color: Colors.black,
                                              ),
                                            ),
                                            TextSpan(
                                                text: "Tổng sử dụng: " +
                                                    tongsudung.toString(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14,
                                                  color: Colors.black,
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
                                            TextSpan(
                                                text: "Tổng tiền: " +
                                                    f
                                                        .format(chiTietThanhToanDto
                                                        .chiTietThanhToan
                                                        .tongThanhTienSauVat)
                                                        .toString(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding: const EdgeInsets.all(2.0),
                                          margin: const EdgeInsets.all(10) ,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: color,
                                            boxShadow: [
                                              BoxShadow(color: color, spreadRadius: 7),
                                            ],
                                          ),
                                          child: RichText(

                                            text: TextSpan(
                                              children: [
                                                WidgetSpan(
                                                  child: Icon(
                                                    icon,
                                                    size: 18,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: ((status) ? " Đã thu" : " Chưa thu"),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                  ),

                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                    ),
                                  ],
                                )))
                      ]))),
        ));
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
  }
}
