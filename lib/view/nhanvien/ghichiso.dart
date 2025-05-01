
import 'dart:convert';

import 'dart:io';
import 'dart:typed_data';

import '/GetKyThu/GetKyThuDto.dart';
import '../../System/Constant.dart';
import '../../System/Lib.dart';
import 'ds_ghichiso.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../model/login_data_model.dart';
import 'package:path_provider/path_provider.dart';


Future<GetKyThuResultDto> getKyThu(http.Client client, int userid,int tenantid, String token,
    bool isLoggedInOffline, context) async {
  try {
    if (!isLoggedInOffline) {
      final response = await client.post(
        Uri.https($GetServer,
            "api/services/app/MobileAppServices/GetKyThuForMobile"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userid': userid.toString(),
          'token': token,
          'tenantId': tenantid.toString(),
        }),
      );

      // Use the compute function to run parsePhotos in a separate isolate.
      if (response.statusCode == 200) {
        writeFile("user" + userid.toString() + "dataKyThu.data", response.body);
        return GetKyThuResultDto.fromJson(jsonDecode(response.body));
      } else {
        _showCupertinoDialog(
            'Lỗi', 'Thông tin kết nối không chính xác!', context);
      }
      throw Exception('Lỗi trong getKyThu ======');
    } else {
      final response = await readFile(
          "user" + userid.toString() + "dataKyThu.data");
      if (response != "N/A") {
        return GetKyThuResultDto.fromJson(jsonDecode(response));
      } else {
        return GetKyThuResultDto(status: false,
            message: "Không tải được file dữ liệu. Vui lòng cập nhật!",
            data: []);
      }
    }
  } catch (e) {
    _showCupertinoDialog('Lỗi', e.toString() + '!', context);
    throw Exception('Lỗi ___----------: ${e.toString()}');
  }
}


_showCupertinoDialog(String title, String content, BuildContext context) {
  showDialog(
      context: context,
      builder: (_) =>
      CupertinoAlertDialog(
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

class GhiChiSo extends StatefulWidget {
  const GhiChiSo({Key? key,
    required this.title,
    required this.isLoggedIn,
    required this.isLoggedInOffline,
    required this.token,
    required this.username,
    required this.userid,
    required this.tenantid,
  })
      : super(key: key);


  final String title;
  final String token;
  final bool isLoggedIn;
  final bool isLoggedInOffline;
  final String username;
  final int userid;
  final int tenantid;

  @override
  _GhiChiSoState createState() => _GhiChiSoState();
}

class ItemSelectBox {
  const ItemSelectBox(this.name, this.icon, this.value);

  final String name;
  final Icon icon;
  final int value;
}

Future<GetGhiChiSoDataResultDto> getGhiChiSoData(int userid, int selectedKyThu,
    context) async {
  try {
    final response = await readFile("user" +
        userid.toString() +
        "dataKyThuHoGiaDinh" +
        selectedKyThu.toString() +
        ".data");
    if (response != "N/A") {
      return GetGhiChiSoDataResultDto.fromJson(jsonDecode(response));
    } else {
      return GetGhiChiSoDataResultDto(
          status: false,
          message:
          "Không tải được file dữ liệu. Vui lòng cập nhật sổ ghi chỉ số!",
          data: []);
    }
    throw Exception('Lỗi trong ');
  } catch (e) {
    _showCupertinoDialog('Lỗi', e.toString() + '!', context);
    throw Exception('Lỗi trong getGhiChiSoData--: ${e.toString()}');
  }
}


Future<GetGhiChiSoDataResultDto> getDataghichiso(int userid, int selectedKyThu,
    context) async {
  try {
    final response = await readFile("user" +
        userid.toString() +
        "dataKyThuHoGiaDinh" +
        selectedKyThu.toString() +
        ".data");
    if (response != "N/A") {
      return GetGhiChiSoDataResultDto.fromJson(jsonDecode(response));
    } else {
      return GetGhiChiSoDataResultDto(
          status: false,
          message:
          "Không tải được file dữ liệu. Vui lòng cập nhật sổ ghi chỉ số!",
          data: []);
    }
    throw Exception('Lỗi trong getDataghichiso -----');
  } catch (e) {
    _showCupertinoDialog('Lỗi', e.toString() + '!', context);
    throw Exception('Lỗi ___----------: ${e.toString()}');
  }
}

class _GhiChiSoState extends State<GhiChiSo> {
  var client = http.Client();
  late int selectedKyThu;
  late String selectedKyThuName;
  var selectedKyThuNameArray = [];

  TextEditingController _searchController = TextEditingController();
  List<GetKyThuDataDto> _filteredKyThuList = [];
  late Future<GetKyThuResultDto> _getKyThuData;
  List<DropdownMenuItem<int>> kythus = [
    DropdownMenuItem(
      value: 0,
      child: Row(
        children: <Widget>[
          const Icon(Icons.arrow_drop_down_outlined),
          Container(
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Chọn sổ",
                  style: TextStyle(color: Colors.black, fontSize: 22),
                  textAlign: TextAlign.left,
                ),
              ))
        ],
      ),
    )
  ];

  Future updateKyThu(http.Client client, String account,
      bool isLoggedInOffline, context) async
  {
    setState(() {
      selectedKyThu = 0;
      selectedKyThuName = "";
    });
    showLoadingIndicator("Tải file dữ liệu", context);
    final responseOffline = await readFile(account + "auth.data");
    final LoginOfflineData data = LoginOfflineData.fromJson(
        json.decode(responseOffline));
    hideOpenDialog(context);
    if (responseOffline == "N/A") {
      _showCupertinoDialog('Lỗi',
          'Không tải được file dữ liệu. Vui lòng đăng nhập online trước!',
          context);
    }
    else {
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
          'tenantId': data.tenantid.toString(),
        }),
      );
      hideOpenDialog(context);
      LoginRequestResult loginRequestResult = LoginRequestResult.fromJson(
          jsonDecode(responseLogin.body));
      if (responseLogin.statusCode != 200) {
        _showCupertinoDialog(
            'Lỗi', 'Tài khoản hoặc mật khẩu online đã thay đổi!', context);
      }
      else {
        showLoadingIndicator("Lấy dữ liệu từ server ...", context);
        final response = await client.post(
          Uri.https($GetServer,
              "api/services/app/MobileAppServices/GetKyThuForMobile"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'userid': loginRequestResult.result!.userid.toString(),
            'token': loginRequestResult.result!.token,
            'tenantId': data.tenantid.toString(),
          }),
        );
        hideOpenDialog(context);
        // Use the compute function to run parsePhotos in a separate isolate.
        if (response.statusCode == 200) {
          var value = GetKyThuResultDto.fromJson(jsonDecode(response.body));
          writeFile("user" + loginRequestResult.result!.userid.toString() +
              "dataKyThu.data", response.body);
          if (value.status) {
            if (value.data.length > 0) {
              int t = 1;
              int len = value.data.length;
              int dem = 1;
              int demdongbo = 0;
              int demdongbothanhcong = 0;
              for (GetKyThuDataDto dataKyThu in value.data) {
                dem++;
                //dong bo file
                showLoadingIndicator("Đồng bộ sổ ghi " + dataKyThu.displayText +
                    " lên server ...", context);
                String filename = "user" +
                    loginRequestResult.result!.userid.toString() +
                    "dataKyThuHoGiaDinh" +
                    dataKyThu.id.toString() +
                    ".data";
                var docFile = await readFile(filename);
                // print("Đang xử lý ID: ${dataKyThu.id}");
                // print("Tên file: $filename");
                if (docFile == "N/A") {
                  // File chưa có, gọi API để lấy dữ liệu
                  showLoadingIndicator("Tải dữ liệu sổ " + dataKyThu.displayText + " từ server ...", context);
                  final responseHoGiaDinh = await client.post(
                    Uri.https($GetServer, "api/services/app/MobileAppServices/GetKyThuDataForMobile"),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(<String, String>{
                      'userid': loginRequestResult.result!.userid.toString(),
                      'token': loginRequestResult.result!.token,
                      'soGhiChiSoId': dataKyThu.id.toString(),
                      'tenantId': data.tenantid.toString(),
                    }),
                  );
                  hideOpenDialog(context);

                  if (responseHoGiaDinh.statusCode == 200) {
                    docFile = responseHoGiaDinh.body;
                    await writeFile(filename, docFile);
                  } else {
                    showNotice("Không thể lấy dữ liệu sổ " + dataKyThu.displayText, context);
                    continue; // bỏ qua sổ này nếu thất bại
                  }
                }

// tiếp tục xử lý đồng bộ với docFile như cũ
                demdongbo++;
                String sendJson = jsonEncode(<String, dynamic>{
                  'userid': loginRequestResult.result!.userid.toString(),
                  'token': loginRequestResult.result!.token,
                  "data": docFile,
                  'tenantId': data.tenantid.toString()
                }).replaceAll("\\", "").replaceAll('"{', '{').replaceAll('}"', '}');

                final responseghi = await client.post(
                  Uri.https($GetServer, "api/services/app/MobileAppServices/UpdateSoGhi"),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: sendJson,
                );

                if (responseghi.statusCode == 200) {
                  demdongbothanhcong++;
                } else {
                  // print("Lỗi khi gửi dữ liệu sổ ${dataKyThu.displayText}: ${responseghi.body}");
                  _showCupertinoDialog("Lỗi khi gửi dữ liệu sổ ",
                      "${dataKyThu.displayText}",
                      context);
                }

                //end dong bo file


                hideOpenDialog(context);
                //end dongbo anh
              }
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(
                    "Đã đồng bộ " + demdongbothanhcong.toString() + "/" +
                        demdongbo.toString() + "!")));
            } else {
              _showCupertinoDialog(
                  "Lỗi", "Bạn chưa được cấp sổ ghi nào!", context);
            }
          } else {
            _showCupertinoDialog("Lỗi", value.message, context);
          }
        } else {
          _showCupertinoDialog(
              'Lỗi', 'Thông tin kết nối không chính xác!', context);
        }
      }
    }
  }

  Future getDuLieu(http.Client client, String account,
      bool isLoggedInOffline, context) async
  {
    setState(() {
      selectedKyThu = 0;
      selectedKyThuName = "";
    });
    showLoadingIndicator("Tải file dữ liệu", context);
    final responseOffline = await readFile(account + "auth.data");
    final LoginOfflineData data = LoginOfflineData.fromJson(
        json.decode(responseOffline));
    hideOpenDialog(context);
    if (responseOffline == "N/A") {
      _showCupertinoDialog('Lỗi',
          'Không tải được file dữ liệu. Vui lòng đăng nhập online trước!',
          context);
    }
    else {
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
          'tenantId': data.tenantid.toString(),
        }),
      );
      hideOpenDialog(context);
      LoginRequestResult loginRequestResult = LoginRequestResult.fromJson(
          jsonDecode(responseLogin.body));
      if (responseLogin.statusCode != 200) {
        _showCupertinoDialog(
            'Lỗi', 'Tài khoản hoặc mật khẩu online đã thay đổi!', context);
      }
      else {
        showLoadingIndicator("Lấy dữ liệu từ server ...", context);
        final response = await client.post(
          Uri.https($GetServer,
              "api/services/app/MobileAppServices/GetKyThuForMobile"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'userid': loginRequestResult.result!.userid.toString(),
            'token': loginRequestResult.result!.token,
            'tenantId': data.tenantid.toString(),
          }),
        );
        hideOpenDialog(context);
        // Use the compute function to run parsePhotos in a separate isolate.
        if (response.statusCode == 200) {
          var value = GetKyThuResultDto.fromJson(jsonDecode(response.body));
          writeFile("user" + loginRequestResult.result!.userid.toString() +
              "dataKyThu.data", response.body);
          delFile("user" + loginRequestResult.result!.userid.toString() +
              "dataKyThuHoGiaDinh");
          if (value.status) {
            showLoadingIndicator("Nạp dữ liệu ...", context);
            kythus = [
              DropdownMenuItem(
                value: 0,
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.arrow_drop_down_outlined),
                    Container(
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Chọn sổ",
                            style: TextStyle(color: Colors.black,

                            ),
                            textAlign: TextAlign.left,
                          ),
                        ))
                  ],
                ),
              )
            ];
            hideOpenDialog(context);
            if (value.data.length > 0) {
              int t = 1;
              int len = value.data.length;
              int dem = 1;
              int demdongbo = 0;
              int demdongbothanhcong = 0;
              for (GetKyThuDataDto dataKyThu in value.data) {
                showLoadingIndicator(
                    "Nạp dữ liệu " + dem.toString() + "/" + len.toString(),
                    context);
                dem++;
                setState(() {
                  selectedKyThuNameArray.add(dataKyThu);
                });
                kythus.add(DropdownMenuItem(
                  value: dataKyThu.id,
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.arrow_drop_down_outlined),
                      Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.65,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              dataKyThu.displayText,
                              style: const TextStyle(color: Colors.black),
                              textAlign: TextAlign.left,
                            ),
                          ))
                    ],
                  ),
                ));
                hideOpenDialog(context);

                //dong bo file

                //end dong bo file

                //lay du lieu ghi chi so
                showLoadingIndicator("Lấy dữ liệu các hộ gia đình thuộc sổ " +
                    dataKyThu.displayText + " từ server ...", context);
                final responseHoGiaDinh = await client.post(
                  Uri.https($GetServer,
                      "api/services/app/MobileAppServices/GetKyThuDataForMobile"),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, String>{
                    'userid': loginRequestResult.result!.userid.toString(),
                    'token': loginRequestResult.result!.token,
                    'soGhiChiSoId': dataKyThu.id.toString(),
                    'tenantId': data.tenantid.toString(),
                  }),
                );
                hideOpenDialog(context);
                showLoadingIndicator(
                    "Lưu dữ liệu các hộ thuộc sổ " + dataKyThu.displayText +
                        " từ server ...", context);
                demdongbo++;
                if (responseHoGiaDinh.statusCode == 200) {
                  demdongbothanhcong++;
                  writeFile(
                      "user" + loginRequestResult.result!.userid.toString() +
                          "dataKyThuHoGiaDinh" + dataKyThu.id.toString() +
                          ".data", responseHoGiaDinh.body);
                }
                hideOpenDialog(context);
                //end lay du lieu ghi chi so
              }
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(
                    "Đã tải xuống " + demdongbothanhcong.toString() + "/" +
                        demdongbo.toString() + "!")));
            } else {
              _showCupertinoDialog(
                  "Lỗi", "Bạn chưa được cấp sổ ghi nào!", context);
            }
          } else {
            _showCupertinoDialog("Lỗi", value.message, context);
          }
        } else {
          _showCupertinoDialog(
              'Lỗi', 'Thông tin kết nối không chính xác!', context);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    selectedKyThu = 0;
    _getKyThuData = getKyThu(
        client, widget.userid, widget.tenantid, widget.token, widget.isLoggedInOffline, context);
    _getKyThuData.then((value) {
      if (value.status) {
        if (value.data.length > 0) {
          int t = 1;
          for (GetKyThuDataDto dataKyThu in value.data) {
            setState(() {
              selectedKyThuNameArray.add(dataKyThu);
            });
            kythus.add(DropdownMenuItem(
              value: dataKyThu.id,
              child: Row(
                children: <Widget>[
                  const Icon(Icons.arrow_drop_down_outlined),
                  Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.65,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          dataKyThu.displayText,
                          style: const TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                        ),
                      ))
                ],
              ),
            ));
          }
        } else {
          _showCupertinoDialog("Lỗi", "Bạn chưa được cấp sổ ghi nào!", context);
        }
      } else {
        _showCupertinoDialog("Lỗi", value.message, context);
      }
    }
    );
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

    void _onSelectChanged(int? newValue) =>
        setState(() {
          selectedKyThu = newValue!;
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

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: (Column(
                        children: <Widget>[
                          // Padding(
                          //     padding: const EdgeInsets.all(8.0),
                          //     child: Align(
                          //       alignment: Alignment.centerLeft,
                          //       child: Text(
                          //         "Xin chào " + username + $GetServer,
                          //         style: const TextStyle(fontWeight: FontWeight.bold),
                          //       ),
                          //     )),
                          Container(

                            child: ElevatedButton(

                                onPressed: () async {
                                  bool? result = await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Xác nhận lấy dữ liệu về'),
                                        content: const Text(
                                          'Nếu bạn chưa tải dữ liệu lên, dữ liệu offline sẽ bị xóa và ghi đè? Hãy kiểm tra lại trước khi làm!',
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.of(context, rootNavigator: true).pop(false),
                                            child: const Text('No'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context, rootNavigator: true).pop(true),
                                            child: const Text('Yes'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (result == true) {
                                    setState(() {
                                      // Cập nhật giao diện nếu cần
                                      getDuLieu(client, username, widget.isLoggedInOffline, context);
                                    });
                                  }
                                },

                                child: const Row(

                                  children: <Widget>[
                                    Icon(Icons.cloud_download, size: 30,),
                                    Text("Lấy dữ liệu từ server",
                                      style: TextStyle(
                                        fontSize: 16
                                      ),
                                    ),
                                    Icon(Icons.cloud_download, size: 30),
                                  ],
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                )),

                            height: 62,
                            width: 260,
                            // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          ),
                          const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Hãy chọn sổ ghi chỉ số!",
                                  style: TextStyle(),
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton<int>(
                                isExpanded: true,
                                hint: const Text("Select item"),
                                value: selectedKyThu,
                                onChanged: _onSelectChanged,
                                items: kythus),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 90,
                                height: 50,
                                child: ElevatedButton(
                                    onPressed: () {
                                      showLoadingIndicator(
                                          "Đang tải dữ liệu ...", context);
                                      if (selectedKyThu == 0 ||
                                          selectedKyThu == null) {
                                        hideOpenDialog(context);
                                        _showCupertinoDialog("Lỗi",
                                            "Bạn chưa chọn sổ ghi chỉ số",
                                            context);
                                      } else {
                                        hideOpenDialog(context);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ListGhiChiSo(
                                                      title: "Danh sách các hộ",
                                                      isLoggedIn: isLoggedIn,
                                                      token: token,
                                                      username: username,
                                                      userid: userid,
                                                      selectedKyThu: selectedKyThu,
                                                      selectedKyThuName: selectedKyThuName,
                                                      isLoggedInOffline: widget.isLoggedInOffline,
                                                    )));
                                      }
                                    },
                                    child: const Text("Chọn", style: TextStyle(
                                      fontSize: 16
                                    ),)),
                              ),
                              const Text("   "),
                              Row(
                                children: [
                                  SizedBox(
                                   height: 50,
                                    // padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            updateKyThu(client, username,
                                                widget.isLoggedInOffline, context);
                                          });
                                        },
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Icon(Icons.autorenew, size: 20,),
                                            Text("Tải dữ liệu lên server", style: TextStyle(
                                              fontSize: 14
                                            ),),
                                            Icon(Icons.autorenew, size: 20,),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Row(
                          //   children: [
                          //     ElevatedButton(
                          //         onPressed: () async {
                          //           Directory dir = await getTemporaryDirectory();
                          //           dir.deleteSync(recursive: true);
                          //         },
                          //         child: const Row(
                          //           children: <Widget>[
                          //             Icon(Icons.delete),
                          //             Text("Xóa toàn bộ ảnh đã chụp")
                          //           ],
                          //         )),
                          //   ],
                          // )
                        ],
                      )),
                    )
                  ],
                )),
          ),
        )

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }// if (docFile != "N/A") {
//   demdongbo++;
//   var t = docFile;
//
//   String sendJson = jsonEncode(<String, dynamic>{
//     'userid': loginRequestResult.result!.userid.toString(),
//     'token': loginRequestResult.result!.token,
//     "data": t
//   }).replaceAll("\\", "").replaceAll('"{', '{').replaceAll(
//       '}"', '}');
//
//   final responseghi = await client.post(
//     Uri.https($GetServer,
//         "api/services/app/MobileAppServices/UpdateSoGhi"),
//     // headers: <String, String>{
//     //   'Content-Type': 'application/json; charset=UTF-8',
//     //   "accept": "application/json",
//     // },
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: sendJson,
//   );
//
//   if (responseghi.statusCode == 200) {
//     demdongbothanhcong++;
//     //dongbo anh
//     // showLoadingIndicator(
//     //     "Đồng bộ ảnh sổ ghi " + dataKyThu.displayText +
//     //         " lên server ...", context);
//     // Future<GetGhiChiSoDataResultDto> _dataGhiChiSo;
//     // _dataGhiChiSo =
//     //     getData(widget.userid, dataKyThu.id, context);
//     // _dataGhiChiSo.then((value) async {
//     //   var tongtailen = 0;
//     //   var tongtailenthanhcong = 0;
//     //   for (GetGhiChiSoDataDto data in value.data) {
//     //     if (data.ghiChiSo.image != "null") {
//     //       var file = File(data.ghiChiSo.image);
//     //       if (file == null) {
//     //         if (data.ghiChiSo.image != 'null') {
//     //           tongtailen++;
//     //         }
//     //         showNotice("Không tải được ảnh của " +
//     //             data.hopdongDonghoKhoDongHoDto.tenKhachHang,
//     //             context);
//     //       }
//     //       else {
//     //         tongtailen++;
//     //         try {
//     //           Uint8List tss = await File(data.ghiChiSo.image)
//     //               .readAsBytes();
//     //
//     //           String sendJson = jsonEncode(<dynamic, dynamic>{
//     //             'userid': loginRequestResult.result!.userid
//     //                 .toString(),
//     //             'token': loginRequestResult.result!.token,
//     //             "data": tss,
//     //             "GhiChiSoId": data.ghiChiSo.id
//     //           });
//     //
//     //           final responseghianh = await client.post(
//     //             Uri.https($GetServer,
//     //                 "api/services/app/MobileAppServices/UpdateSoGhiAnh"),
//     //             headers: <String, String>{
//     //               'Content-Type': 'application/json; charset=UTF-8',
//     //               "accept": "application/json",
//     //             },
//     //             body: sendJson,
//     //           );
//     //           if (responseghianh.statusCode != 200) {
//     //             showNotice("Tải lên lỗi: ảnh của " +
//     //                 data.hopdongDonghoKhoDongHoDto.tenKhachHang,
//     //                 context);
//     //           } else {
//     //             tongtailenthanhcong++;
//     //           }
//     //         } catch (e) {
//     //           showNotice("Tải lên lỗi: ảnh của " +
//     //               data.hopdongDonghoKhoDongHoDto.tenKhachHang +
//     //               " không tìm thấy!",
//     //               context);
//     //         }
//     //       }
//     //     }
//     //   }
//     //   showNotice(
//     //       "Tải thành công " + tongtailenthanhcong.toString() +
//     //           "/" + tongtailen.toString() + " ảnh", context);
//     //   hideOpenDialog(context);
//     // });
//     // print('Send code json: ${sendJson}');
//   }else{
//     print('Không thể đồng bộ: ${responseghi.statusCode}' );
//     print('Nội dung lỗi: ${responseghi.body}');
//     print('Send code json: ${sendJson}');
//   }
// }
}
