import 'dart:convert';

import 'dart:io';
import 'dart:typed_data';

import '../../GetKyThu/GetKyThuDto.dart';
import '../../System/Lib.dart';
import '../../screens/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

//update ghichiso
Future updateGhichiso(int id, int chisomoi, int userid, int selectedKyThu,
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
          if (chisomoi != -1) {
            if (chisomoi == 0 && data.ghiChiSo.chiSoCu == 0) {
              data.ghiChiSo.chiSoMoi = chisomoi;
              data.ghiChiSo.tongSuDung = -1;
            } else {
              data.ghiChiSo.chiSoMoi = chisomoi;
              data.ghiChiSo.tongSuDung = tongsudung;
            }
          }
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
//
// Future<String> updateAnh(int id, String image, int userid, int selectedKyThu,
//     BuildContext context) async {
//   try {
//     final response = await readFile("user" +
//         userid.toString() +
//         "dataKyThuHoGiaDinh" +
//         selectedKyThu.toString() +
//         ".data");
//     if (response != "N/A") {
//       var images = "";
//       GetGhiChiSoDataResultDto result =
//           GetGhiChiSoDataResultDto.fromJson(jsonDecode(response));
//       showLoadingIndicator("Đang chuyển ảnh thành dữ liệu ...", context);
//
//       for (GetGhiChiSoDataDto data in result.data) {
//         if (data.ghiChiSo.id == id) {
//           data.ghiChiSo.image = (image).toString();
//           images = data.ghiChiSo.image;
//           hideOpenDialog(context);
//           break;
//         }
//       }
//       var t = jsonEncode(result.toJson())
//           .replaceAll("\\", "")
//           .replaceAll('"[', "[")
//           .replaceAll(']"', ']')
//           .replaceAll('"{', '{')
//           .replaceAll('}",', '},');
//
//       writeFile(
//           "user" +
//               userid.toString() +
//               "dataKyThuHoGiaDinh" +
//               selectedKyThu.toString() +
//               ".data",
//           t);
//       return images;
//     } else {
//       ScaffoldMessenger.of(context)
//         ..removeCurrentSnackBar()
//         ..showSnackBar(const SnackBar(
//             content: Text(
//                 "Không tải được file dữ liệu. Vui lòng cập nhật sổ ghi chỉ số!")));
//       return "";
//     }
//   } catch (e) {
//     _showCupertinoDialog('Lỗi', e.toString() + '!', context);
//     return "";
//   }
// }
//end update ghi chi so

class ThucHienGhi extends StatefulWidget {
  ThucHienGhi(
      {Key? key,
      required this.name,
      required this.address,
      required this.id,
      required this.ghichiso,
      required this.chiSoCuThangTruoc,
      required this.chiSoMoiThangTruoc,
      required this.tongSuDungThangTruoc,
      required this.chiSoCuThangTruocNua,
      required this.chiSoMoiThangTruocNua,
      required this.tongSuDungThangTruocNua,
      required this.chisomoi,
      required this.ghichu,
      required this.chisocu,
      required this.tongsudung,
      required this.heSoTieuThu,
      required this.selectedKyThu,
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
  final String name;
  final String address;
  final int id;
  final int chiSoCuThangTruoc;
  final int chiSoMoiThangTruoc;
  final int tongSuDungThangTruoc;
  final int chiSoCuThangTruocNua;
  final int chiSoMoiThangTruocNua;
  final int tongSuDungThangTruocNua;
  final int chisomoi;
  final int heSoTieuThu;
  final int selectedKyThu;
  final String ghichu;
  final int chisocu;
  final int tongsudung;
  final GhiChiSoDataDto ghichiso;

  @override
  _ThucHienGhiState createState() => _ThucHienGhiState();
}

class ItemSelectBox {
  const ItemSelectBox(this.name, this.icon, this.value);

  final String name;
  final Icon icon;
  final int value;
}

class _ThucHienGhiState extends State<ThucHienGhi> {
  late TextEditingController _chisomoi;
  late TextEditingController _ghichu;
  ReturnBackUint8List? returnBackUint8ListContainer = null;
  String imgPath = "";
  String imgData = "";

  @override
  void initState() {
    imgPath = "";
    super.initState();
    _chisomoi = TextEditingController(text: widget.chisomoi.toString());
    _ghichu = TextEditingController(
        text: (widget.ghichu != null) ? widget.ghichu.toString() : "");
  }

  //
  _navigateAnhAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraScreen()),
      // MaterialPageRoute(builder: (context) => MyApp()),
    );

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    if (result.status) {
      setState(() {
        returnBackUint8ListContainer = result;
        imgPath = result.path;
        widget.ghichiso.image = result.path;
      });
    }
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
                              child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.blueAccent),
                                    borderRadius: BorderRadius.circular(7),
                                    color: Colors.lightGreen,
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          widget.name.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          widget.address.toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Tiêu thụ tháng trước: " +
                                              widget.tongSuDungThangTruoc
                                                  .toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Tiêu thụ tháng trước 2: " +
                                              widget.tongSuDungThangTruocNua
                                                  .toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ))),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  padding: const EdgeInsets.all(18.0),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.blueAccent),
                                    borderRadius: BorderRadius.circular(7),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                              labelText: "Chỉ số cũ",
                                              labelStyle:
                                                  TextStyle(fontSize: 24)),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          // Only numbers can be entered
                                          initialValue:
                                              widget.chisocu.toString(),
                                          enabled: false,
                                        ),
                                      ),
                                    ],
                                  ))),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  padding: const EdgeInsets.all(18.0),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.blueAccent),
                                    borderRadius: BorderRadius.circular(7),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextFormField(
                                          controller: _chisomoi,
                                          decoration: const InputDecoration(
                                              labelText: "Chỉ số mới",
                                              labelStyle:
                                                  TextStyle(fontSize: 24)),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ], // Only numbers can be entered
                                        ),
                                      ),
                                    ],
                                  ))),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  padding: const EdgeInsets.all(18.0),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.blueAccent),
                                    borderRadius: BorderRadius.circular(7),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextFormField(
                                          controller: _ghichu,
                                          decoration: const InputDecoration(
                                              labelText: "Ghi chú",
                                              labelStyle:
                                                  TextStyle(fontSize: 24)),
                                          keyboardType: TextInputType.text,
                                        ),
                                      ),
                                    ],
                                  ))),
                          // const Padding(
                          //   padding: EdgeInsets.all(0),
                          //   child: Text("Ảnh"),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.all(0),
                          //   child: (imgPath == "" &&
                          //           (widget.ghichiso.image == "" ||
                          //               widget.ghichiso.image == "null"))
                          //       ? Image.asset(
                          //           // "./assets/image/logo1.png",
                          //           "./assets/image/noimg.jpg",
                          //           width: 120,
                          //         )
                          //       : ((widget.ghichiso.image != "" &&
                          //               widget.ghichiso.image != "null")
                          //           ? Image.file(
                          //               File(widget.ghichiso.image),
                          //               fit: BoxFit.cover,
                          //             )
                          //           : ((imgPath != "")
                          //               ? Image.file(
                          //                   File(imgPath),
                          //                   fit: BoxFit.cover,
                          //                 )
                          //               : Image.asset(
                          //                   "./assets/image/noimg.jpg",
                          //                   width: 120,
                          //                 ))),
                          // ),
                          Padding(
                              padding: const EdgeInsets.all(0),
                              child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: const BoxDecoration(),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          ElevatedButton(
                                              onPressed: () async {
                                                if (_chisomoi.text.toString() ==
                                                    "") {
                                                  _showCupertinoDialog(
                                                      "Cảnh báo",
                                                      "Chưa nhập chỉ số mới",
                                                      context);
                                                } else {
                                                  if ((int.parse(_chisomoi.text
                                                              .toString()) -
                                                          widget.chisocu) <
                                                      0) {
                                                    bool resultcheckam =
                                                        await showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Chú ý'),
                                                          content: const Text(
                                                              'Chỉ số mới nhỏ hơn chỉ số cũ! Tiếp tục?'),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context,
                                                                        rootNavigator:
                                                                            true)
                                                                    .pop(
                                                                        false); // dismisses only the dialog and returns false
                                                              },
                                                              child: const Text(
                                                                  'No'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context,
                                                                        rootNavigator:
                                                                            true)
                                                                    .pop(
                                                                        true); // dismisses only the dialog and returns true
                                                              },
                                                              child: const Text(
                                                                  'Yes'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                    if (!resultcheckam) {
                                                      // return false;
                                                    }
                                                  }

                                                  if (((int.parse(_chisomoi.text
                                                                      .toString()) -
                                                                  widget
                                                                      .chisocu) *
                                                              widget
                                                                  .heSoTieuThu) >
                                                          2 *
                                                              widget
                                                                  .tongSuDungThangTruoc &&
                                                      ((int.parse(_chisomoi.text
                                                                      .toString()) -
                                                                  widget
                                                                      .chisocu) *
                                                              widget
                                                                  .heSoTieuThu) >
                                                          10) {
                                                    bool result =
                                                        await showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Chú ý'),
                                                          content: Text('Tổng sử dụng tăng đột biến so với tháng trước (' +
                                                              ((int.parse(_chisomoi
                                                                              .text
                                                                              .toString()) -
                                                                          widget
                                                                              .chisocu) *
                                                                      widget
                                                                          .heSoTieuThu)
                                                                  .toString() +
                                                              ' - ' +
                                                              widget
                                                                  .tongSuDungThangTruoc
                                                                  .toString() +
                                                              ')! Tiếp tục?'),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context,
                                                                        rootNavigator:
                                                                            true)
                                                                    .pop(
                                                                        false); // dismisses only the dialog and returns false
                                                              },
                                                              child: const Text(
                                                                  'No'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context,
                                                                        rootNavigator:
                                                                            true)
                                                                    .pop(
                                                                        true); // dismisses only the dialog and returns true
                                                              },
                                                              child: const Text(
                                                                  'Yes'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                    if (!result) {
                                                      // return false;
                                                    }
                                                  }
                                                  // var anh = "";
                                                  // if (returnBackUint8ListContainer !=
                                                  //     null) {
                                                  //   anh = await updateAnh(
                                                  //       widget.id,
                                                  //       imgPath,
                                                  //       widget.userid,
                                                  //       widget.selectedKyThu,
                                                  //       context);
                                                  // }
                                                  await updateGhichiso(
                                                      widget.id,
                                                      int.parse(_chisomoi.text
                                                          .toString()),
                                                      widget.userid,
                                                      widget.selectedKyThu,
                                                      (int.parse(_chisomoi.text
                                                                  .toString()) -
                                                              widget.chisocu) *
                                                          widget.heSoTieuThu,
                                                      _ghichu.text,
                                                      context);
                                                  if (int.parse(_chisomoi.text
                                                          .toString()) ==
                                                      widget.chisomoi) {
                                                    Navigator.pop(
                                                        context,
                                                        ReturnBackFromGhiChiSo(
                                                            status:
                                                                (int.parse(_chisomoi
                                                                            .text) ==
                                                                        0 &&
                                                                    widget.chisocu ==
                                                                        0),
                                                            chisomoi: int.parse(
                                                                _chisomoi.text),
                                                            // anh: anh,
                                                            ghichu:
                                                                _ghichu.text));
                                                  } else {
                                                    Navigator.pop(
                                                        context,
                                                        ReturnBackFromGhiChiSo(
                                                            status: true,
                                                            chisomoi: int.parse(
                                                                _chisomoi.text),
                                                            // anh: anh,
                                                            ghichu:
                                                                _ghichu.text));
                                                  }
                                                }
                                              },
                                              child: const Text("Lưu lại")),
                                          const Text("   "),
                                          ElevatedButton(
                                              onPressed: () async {
                                                var anh = "";
                                                // if (returnBackUint8ListContainer !=
                                                //     null) {
                                                //   anh = await updateAnh(
                                                //       widget.id,
                                                //       imgPath,
                                                //       widget.userid,
                                                //       widget.selectedKyThu,
                                                //       context);
                                                // }
                                                await updateGhichiso(
                                                    widget.id,
                                                    -1,
                                                    widget.userid,
                                                    widget.selectedKyThu,
                                                    (int.parse(_chisomoi.text
                                                                .toString()) -
                                                            widget.chisocu) *
                                                        widget.heSoTieuThu,
                                                    _ghichu.text,
                                                    context);
                                                Navigator.pop(
                                                    context,
                                                    ReturnBackFromGhiChiSo(
                                                        status: false,
                                                        chisomoi: int.parse(
                                                            _chisomoi.text),
                                                        // anh: anh,
                                                        ghichu: _ghichu.text));
                                              },
                                              child: const Text("Lưu ghi chú")),
                                          const Text("   "),
                                          // ElevatedButton(
                                          //     onPressed: () {
                                          //       _navigateAnhAndDisplaySelection(
                                          //           context);
                                          //     },
                                          //     child: const Text("Chụp ảnh")),
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
