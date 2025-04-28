import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/foundation.dart';

import '../../GetKyThu/GetKyThuDto.dart';
import '../../System/Lib.dart';
import 'ThucHienGhi.dart';


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

Future<GetGhiChiSoDataResultDto> getData(
    int userid, int selectedKyThu, context) async {
  try {
    final response = await readFile("user" +
        userid.toString() +
        "dataKyThuHoGiaDinh" +
        selectedKyThu.toString() +
        ".data");
    if (response != "N/A") {
      return GetGhiChiSoDataResultDto.fromJson(jsonDecode(response));
    } else {
      return new GetGhiChiSoDataResultDto(
          status: false,
          message:
          "Không tải được file dữ liệu. Vui lòng cập nhật sổ ghi chỉ số!", data: []);
    }

  } catch (e) {
    _showCupertinoDialog('Lỗi', e.toString() + '!', context);
    throw Exception('Lỗi trong getData ======: ${e.toString()}');
  }
}

class ListGhiChiSo extends StatefulWidget {
  ListGhiChiSo(
      {Key? key,
        required this.title,
        required this.isLoggedIn,
        required this.isLoggedInOffline,
        required this.token,
        required this.username,
        required this.userid,
        required this.selectedKyThu,
        required this.selectedKyThuName})
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

  @override
  _ListGhiChiSoState createState() => _ListGhiChiSoState();
}

class ItemSelectBox {
  const ItemSelectBox(this.name, this.icon, this.value);

  final String name;
  final Icon icon;
  final int value;
}

List<SelectAction> _selectActions = [];

class _ListGhiChiSoState extends State<ListGhiChiSo> {
  var client = new http.Client();
  String _filter = "";
  late Future<GetGhiChiSoDataResultDto> _dataGhiChiSo;

  late Future _response;
  bool sortStt = true;
  int sortDaghi = 1; //1 all 2 chua ghi 3 da ghi
  @override
  void initState() {
    super.initState();
    _selectActions = [];
    _dataGhiChiSo = getData(widget.userid, widget.selectedKyThu, context);
    _dataGhiChiSo.then((value) {
      for (GetGhiChiSoDataDto data in value.data) {
        setState(() {
          _selectActions.add(new SelectAction(
            name: data.stt.toString() +
                " - " +
                data.hopdongDonghoKhoDongHoDto.tenKhachHang +
                ", " +
                data.hopdongDonghoKhoDongHoDto.maHopDong +
                ", " +
                data.hopdongDonghoKhoDongHoDto.serial,
            action: "",
            status: (data.ghiChiSo.tongSuDung==-1)?true:(((data.ghiChiSo.chiSoMoi > 0) ||
                (data.ghiChiSo.chiSoMoi == data.ghiChiSo.chiSoCu) ||
                (data.ghiChiSo.chiSoMoi > 0 &&
                    data.ghiChiSo.tongSuDung < 0))
                ? true
                : false),
            token: widget.token,
            isLoggedIn: widget.isLoggedIn,
            isLoggedInOffline: widget.isLoggedInOffline,
            username: widget.username,
            userid: widget.userid,
            address: data.dongHoDiaChi,
            chisomoi: data.ghiChiSo.chiSoMoi,
            chisocu: data.ghiChiSo.chiSoCu,
            tongsudung: data.ghiChiSo.tongSuDung,
            ghichu: data.ghiChiSo.ghiChu,
            id: data.ghiChiSo.id,
            stt: data.stt,
            ghichiso: data.ghiChiSo,
            chiSoCuThangTruoc: data.chiSoCuThangTruoc,
            chiSoMoiThangTruoc: data.chiSoMoiThangTruoc,
            tongSuDungThangTruoc: data.tongSuDungThangTruoc,
            chiSoCuThangTruocNua: data.chiSoCuThangTruocNua,
            chiSoMoiThangTruocNua: data.chiSoMoiThangTruocNua,
            tongSuDungThangTruocNua: data.tongSuDungThangTruocNua,
            heSoTieuThu: data.hopdongDonghoKhoDongHoDto.heSoTieuThu,
            selectedKyThu: widget.selectedKyThu,
          ));
        });
      }
      setState(() {
        _selectActions.sort((a, b) => (a.stt.compareTo(b.stt)));
      });
    });
  }

  updateSort(int t) {}

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

                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: (Column(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              child: Text(
                                "Xin chào " + username,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              alignment: Alignment.centerLeft,
                            )),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              child: Text(
                                "Sổ thu - " + widget.selectedKyThuName,
                                style: const TextStyle(),
                              ),
                              alignment: Alignment.centerLeft,
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
                                            return (_filter.trim() != "")
                                                ? ((_selectActions[index]
                                                .name
                                                .toLowerCase()
                                                .contains(_filter
                                                .toLowerCase()) ||
                                                _selectActions[index]
                                                    .address
                                                    .toLowerCase()
                                                    .contains(_filter
                                                    .toLowerCase()))
                                                ? (sortDaghi == 1)
                                                ? _selectActions[index]
                                                : ((sortDaghi == 2)
                                                ? ((_selectActions[index]
                                                .status)
                                                ? Container()
                                                : _selectActions[
                                            index])
                                                : ((!_selectActions[index]
                                                .status)
                                                ? Container()
                                                : _selectActions[
                                            index]))
                                                : Container())
                                                : (sortDaghi == 1)
                                                ? _selectActions[index]
                                                : ((sortDaghi == 2)
                                                ? ((_selectActions[index]
                                                .status)
                                                ? Container()
                                                : _selectActions[
                                            index])
                                                : ((!_selectActions[index]
                                                .status)
                                                ? Container()
                                                : _selectActions[
                                            index]));
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
        required this.chisomoi,
        required this.chisocu,
        required this.tongsudung,
        required this.heSoTieuThu,
        required this.selectedKyThu,
        required this.ghichu,
        required this.stt,
        required this.chiSoCuThangTruoc,
        required this.chiSoMoiThangTruoc,
        required this.tongSuDungThangTruoc,
        required this.chiSoCuThangTruocNua,
        required this.chiSoMoiThangTruocNua,
        required this.tongSuDungThangTruocNua,
        required this.action,
        required this.token,
        required this.ghichiso,
        required this.isLoggedIn,
        required this.isLoggedInOffline,
        required this.username,
        required this.userid,
        required this.status})
      : super(key: key);
  final String name;
  final String address;
  final String action;
  late IconData icon;
  late Color color;
  final String token;
  final bool isLoggedIn;
  final bool isLoggedInOffline;
  final String username;
  final int userid;
  final int id;
  final int stt;
  int chisomoi;
  final int selectedKyThu;
  final int chisocu;
  int tongsudung;
  GhiChiSoDataDto ghichiso;
  int chiSoCuThangTruoc;
  int chiSoMoiThangTruoc;
  int tongSuDungThangTruoc;
  int chiSoCuThangTruocNua;
  int chiSoMoiThangTruocNua;
  int tongSuDungThangTruocNua;
  final int heSoTieuThu;
  final String ghichu;
  bool status;

  @override
  _SelectActionState createState() => _SelectActionState();
}

class _SelectActionState extends State<SelectAction> {
  late String name;
  late String address;
  late String action;
  // late IconData icon;
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
  late int heSoTieuThu;
  late String ghichu;
  late bool status;

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
    chisomoi = widget.chisomoi;
    chisocu = widget.chisocu;
    tongsudung = widget.tongsudung;
    heSoTieuThu = widget.heSoTieuThu;
    ghichu = widget.ghichu;
    status = widget.status;
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ThucHienGhi(
            title: name,
            isLoggedIn: isLoggedIn,
            isLoggedInOffline: isLoggedInOffline,
            token: token,
            username: username,
            userid: userid,
            name: name,
            address: address,
            chisomoi: chisomoi,
            chisocu: chisocu,
            tongsudung: tongsudung,
            ghichu: ghichu,
            id: id,
            ghichiso: widget.ghichiso,
            chiSoCuThangTruoc: widget.chiSoCuThangTruoc,
            chiSoMoiThangTruoc: widget.chiSoMoiThangTruoc,
            tongSuDungThangTruoc: widget.tongSuDungThangTruoc,
            chiSoCuThangTruocNua: widget.chiSoCuThangTruocNua,
            chiSoMoiThangTruocNua: widget.chiSoMoiThangTruocNua,
            tongSuDungThangTruocNua: widget.tongSuDungThangTruocNua,
            heSoTieuThu: heSoTieuThu,
            selectedKyThu: widget.selectedKyThu,
          )),
      // MaterialPageRoute(builder: (context) => MyApp()),
    );

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    if (result != null && result.status) {
      setState(() {
        chisomoi = result.chisomoi;
        status = result.status;
        // status = result.status;
        chisomoi = result.chisomoi;
        tongsudung = (chisomoi - chisocu) * heSoTieuThu;
        tongsudung = (chisomoi - chisocu) * heSoTieuThu;
        var t = _selectActions.indexOf(widget);
        _selectActions[_selectActions.indexOf(widget)].status = result.status;
        _selectActions[_selectActions.indexOf(widget)].chisomoi =
            result.chisomoi;
        _selectActions[_selectActions.indexOf(widget)].tongsudung =
            (chisomoi - chisocu) * heSoTieuThu;
      });
    } else if (result != null) {
      setState(() {
        widget.ghichiso.image = result.anh;
        ghichu = result.ghichu;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData icon = (status) ? Icons.check : Icons.remove;
    Color color = (status) ? Colors.lightGreen : Colors.redAccent;
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
                                              child: Icon(Icons.lock_clock,
                                                  size: 18,
                                                  color: Colors.black),
                                            ),
                                            TextSpan(
                                                text: " TT1: " +
                                                    widget.tongSuDungThangTruoc
                                                        .toString() +
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
                                                text: " TT2: " +
                                                    widget
                                                        .tongSuDungThangTruocNua
                                                        .toString(),
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
                                        child: Container(
                                          margin: const EdgeInsets.all(10) ,
                                          decoration: BoxDecoration(
                                            color: color,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(color:color, spreadRadius: 7),
                                            ],
                                          ),
                                          padding: const EdgeInsets.all(2.0),
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
                                                    text: ((status) ? " Đã ghi" : " Chưa ghi"),
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    )),
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
    properties.add(IntProperty('id', id));
  }
}
