
import 'dart:convert';

import 'dart:io';

import '../../GetKyThu/GetKyThuDto.dart';
import '../../System/Constant.dart';
import '../../System/Lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
// import 'package:cnxd/LoginLib.dart';
import '../../model/login_data_model.dart';
import 'package:intl/intl.dart';

final f = NumberFormat("#,### VNĐ", "vi_VN");

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

Future<GetBaoCaoThuTheoSoResultDto> getDataTheoSo(http.Client client,
    String account, String tuNgay, String denNgay,String type, context) async {
  try {
    showLoadingIndicator("Tải file dữ liệu", context);
    final responseOffline = await readFile(account + "auth.data");
    final LoginOfflineData data =
    LoginOfflineData.fromJson(json.decode(responseOffline));
    hideOpenDialog(context);
    if (responseOffline == "N/A") {
      return await GetBaoCaoThuTheoSoResultDto(
          status: false,
          message:
          'Không tải được file dữ liệu. Vui lòng đăng nhập online trước!', data: [], tongTien: 0 , tongKhachHang: 0);
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
        return await GetBaoCaoThuTheoSoResultDto(
            status: false,
            message: "Tài khoản hoặc mật khẩu online đã thay đổi!", data: [], tongTien: 0, tongKhachHang: 0);
      } else {
        showLoadingIndicator("Lấy dữ liệu từ server ...", context);
        final response = await client.post(
          Uri.https(
              $GetServer, "api/services/app/MobileAppServices/LocTongHop"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'id': loginRequestResult.result!.userid.toString(),
            'token': loginRequestResult.result!.token,
            'tuNgay': tuNgay,
            'denNgay': denNgay,
            'type': type
          }),
        );
        hideOpenDialog(context);
        // Use the compute function to run parsePhotos in a separate isolate.
        if (response.statusCode == 200) {
          return await GetBaoCaoThuTheoSoResultDto.fromJson(
              jsonDecode(response.body));
        } else {
          return await GetBaoCaoThuTheoSoResultDto(
              status: false, message: "Thông tin kết nối không chính xác!", data: [], tongTien: 0, tongKhachHang: 0);
        }
      }
    }
    // throw Exception('Đã có lỗi xảy ra}');
  } catch (e) {
    _showCupertinoDialog('Lỗi', e.toString() + '!', context);
    throw Exception('Đã có lỗi xảy ra: ${e.toString()}');
  }
}

class TongHopThuTien extends StatefulWidget {
  const TongHopThuTien(
      {super.key,
        required this.title,
        required this.isLoggedIn,
        required this.isLoggedInOffline,
        required this.token,
        required this.username,
        required this.userid});

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
  _TongHopThuTienState createState() => _TongHopThuTienState();
}

class ItemSelectBox {
  const ItemSelectBox(this.name, this.icon, this.value);

  final String name;
  final Icon icon;
  final int value;
}

class _TongHopThuTienState extends State<TongHopThuTien> {
  var client = http.Client();
  late int selectedKyThu;
  List<Widget> listWidget = [];
  late String selectedKyThuName;
  late Future<GetSoThanhToanDataResultDto> _dataSoThanhToan;
  var selectedKyThuNameArray = [];
  List<Widget> _selectActions = [];
  String tu = "";
  String den = "";

  @override
  void initState() {
    super.initState();
    listWidget = [];
    Future.delayed(Duration.zero, () {});
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
                              child: Text(
                                "Xin chào " + username,
                                style:
                                const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              alignment: Alignment.centerLeft,
                            )),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              child: Text(
                                "Tổng hợp thu " +
                                    ((tu != "" && den != "")
                                        ? "Từ " + tu + " đến " + den + "!"
                                        : "!"),
                                style: const TextStyle(),
                              ),
                              alignment: Alignment.centerLeft,
                            )),
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: (Column(
                            children: ((listWidget == null)
                                ? [const Text(" ")]
                                : listWidget),
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
            Row(
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.date_range),
                  // color: Colors.blue,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  label: const Text("Lọc theo sổ"),
                  onPressed: () async {
                    final DateTimeRange? picked = await showDateRangePicker(
                        context: context,
                        // initialFirstDate: new DateTime.now(),
                        // initialLastDate:
                        // (new DateTime.now()).add(new Duration(days: 7)),

                        initialDateRange: DateTimeRange(
                    start: DateTime.now(),
                    end: DateTime.now().add(const Duration(days: 7)),
                  ),
                        firstDate: DateTime(2015),
                        lastDate: DateTime(2050));
                    if (picked != null) {
                      GetBaoCaoThuTheoSoResultDto t = await getDataTheoSo(
                          client,
                          widget.username,
                          DateFormat('yyyy-MM-dd').format(picked.start),
                          DateFormat('yyyy-MM-dd').format(picked.end),
                          "Sổ Thu",
                          context);

                      if (t.status) {
                        setState(() {
                          List<DataRow> dataRows = [];
                          for (SoThanhToanForNhanVienKhongCanSoThanhToanDto data
                          in t.data) {
                            dataRows.add(DataRow(cells: <DataCell>[
                              DataCell(Container(
                                width: 200,
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:  Text(data.tenSo)
                                ),
                              )),
                              DataCell(Container(
                                width: 50,
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(data.soKhachHangDaThu.toString())
                                ),
                              )),
                              DataCell(
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(f.format(data.soTienDaThu).toString()),
                                    ),
                                  )
                              ),
                            ]));
                          }
                          dataRows.add(DataRow(cells: <DataCell>[
                            const DataCell(Text("Tổng",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(t.tongKhachHang.toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(f.format(t.tongTien).toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold))),
                          ]));
                          DataTable dataTable = DataTable(
                              horizontalMargin: 0,
                              columnSpacing: 10,
                              columns: const <DataColumn>[
                                DataColumn(
                                  label: Text(
                                    'Sổ thu',
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(

                                  label: Text(
                                    'SL\nĐã thu',
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold),
                                    softWrap: true,
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Số tiền',
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                              rows: dataRows);
                          listWidget.clear();
                          listWidget.add(dataTable);
                          tu = DateFormat('dd-MM-yyyy').format(picked.start);
                          den = DateFormat('dd-MM-yyyy').format(picked.end);
                        });
                      } else {
                        showNotice(t.message, context);
                      }
                    } else {
                      showNotice("Bạn cần chọn từ ngày - đến ngày", context);
                    }
                  },
                ),
                const Text(" "),
                TextButton.icon(
                  icon: const Icon(Icons.lock_clock),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  label: const Text("Lọc theo từng ngày"),
                  onPressed: () async {
                    final DateTimeRange? picked = await showDateRangePicker(
                        context: context,
                        // initialFirstDate: new DateTime.now(),
                        // initialLastDate:
                        // (new DateTime.now()).add(new Duration(days: 7)),
                        initialDateRange: DateTimeRange(
                    start: DateTime.now(),
                    end: DateTime.now().add(const Duration(days: 7)),
                  ),
                        firstDate: DateTime(2015),
                        lastDate: DateTime(2050));
                    if (picked != null ) {
                      GetBaoCaoThuTheoSoResultDto t = await getDataTheoSo(
                          client,
                          widget.username,
                          DateFormat('yyyy-MM-dd').format(picked.start),
                          DateFormat('yyyy-MM-dd').format(picked.end),
                          "Ngày Thu",
                          context);

                      if (t.status) {
                        setState(() {
                          List<DataRow> dataRows = [];
                          for (SoThanhToanForNhanVienKhongCanSoThanhToanDto data
                          in t.data) {
                            dataRows.add(DataRow(cells: <DataCell>[
                              DataCell(Container(
                                width: 150,
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:  Text(data.tenSo)
                                ),
                              )),
                              DataCell(Container(
                                width: 50,
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(data.soKhachHangDaThu.toString())
                                ),
                              )),
                              DataCell(
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(f.format(data.soTienDaThu).toString()),
                                    ),
                                  )
                              ),
                            ]));
                          }
                          dataRows.add(DataRow(cells: <DataCell>[
                            const DataCell(Text("Tổng",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(t.tongKhachHang.toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(f.format(t.tongTien).toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold))),
                          ]));
                          DataTable dataTable = DataTable(
                              horizontalMargin: 0,
                              columnSpacing: 10,
                              columns: const <DataColumn>[
                                DataColumn(
                                  label: Text(
                                    'Ngày thu',
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(

                                  label: Text(
                                    'SL Đã thu',
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold),
                                    softWrap: true,
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Số tiền',
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                              rows: dataRows);
                          listWidget.clear();
                          listWidget.add(dataTable);
                          tu = DateFormat('dd-MM-yyyy').format(picked.start);
                          den = DateFormat('dd-MM-yyyy').format(picked.end);
                        });
                      } else {
                        showNotice(t.message, context);
                      }
                    } else {
                      showNotice("Bạn cần chọn từ ngày - đến ngày", context);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

