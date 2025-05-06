import 'dart:convert';
import 'dart:io';
import 'package:qly_chi_so_nuoc/drawer/tabbar_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../model/login_data_model.dart';
import '../../System/Constant.dart';
import '../../System/Lib.dart';
import 'thutien.dart';
import 'tonghopthu.dart';
import 'ghichiso.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

//class Defination

class MyHttpOverrides extends HttpOverrides {
  // @override
  // HttpClient createHttpClient(SecurityContext context) {
  //   return super.createHttpClient(context)
  //     ..badCertificateCallback =
  //         (X509Certificate cert, String host, int port) => true;
  // }
}

Future<LoginRequestResult> login(http.Client client, String account,
    int tenantid, String password, bool saveInfo, context) async {
  try {
    showLoadingIndicator("Đăng nhập ...", context);
    final response = await client.post(
      Uri.https($GetServer, "api/services/app/MobileAppServices/MobileLogin"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'accountName': account,
        'passWord': password,
        'tenantId': tenantid.toString(),
      }),
    );
    hideOpenDialog(context);
    // Use the compute function to run parsePhotos in a separate isolate.
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      String jsonString = jsonEncode(jsonDecode(response.body));
      await prefs.setString('user_data', jsonString);

      if (saveInfo) {
        await prefs.setString('username', account);
        await prefs.setString('password', password);
        await prefs.setBool('saveInfo', true);
      } else {
        await prefs.remove('username');
        await prefs.remove('password');
        await prefs.setBool('saveInfo', false);
      }

      return LoginRequestResult.fromJson(jsonDecode(response.body));
    } else {
      _showCupertinoDialog('Lỗi',
          'Sai tài khoản hoặc mật khẩu/Hoặc tài khoản bị khóa!', context);
      throw Exception('Đăng nhập thất bại');
    }
  } catch (e) {
    // print('Lỗi đăng nhập---------: ${e.toString()}');
    showNotice('Lỗi $e!', context);
    throw Exception('Đăng nhập thất bại: ' + e.toString());
    hideOpenDialog(context);
  }
}

Future<LoginRequestResult> loginOffline(http.Client client, String account,
    String password, int tenantid, context) async {
  try {
    writeFile(
        "auths.data",
        json.encode(LoginOfflineData(
          username: account,
          password: password,
          tenantid: 2,
          userid: 1,
        ).toJson()));
    showLoadingIndicator("Đăng nhập ...", context);

    final response = await readFile(account + "auth.data");
    hideOpenDialog(context);
    // Use the compute function to run parsePhotos in a separate isolate.
    if (response != "N/A") {
      final LoginOfflineData data =
          LoginOfflineData.fromJson(json.decode(response));
      if (data.username.toLowerCase() == account.toLowerCase() &&
          data.password.toLowerCase() == password.toLowerCase()) {
        return LoginRequestResult(
            result: LoginResult(
                username: account,
                userid: data.userid,
                token: "Offline",
                status: true));
      } else {
        _showCupertinoDialog(
            'Lỗi',
            'Sai tài khoản hoặc mật khẩu hoặc tài khoản chưa đăng nhập online!',
            context);
        return LoginRequestResult(
            error: LoginError(
                code: "",
                details: 'Sai tài khoản hoặc mật khẩu!',
                message: 'Sai tài khoản hoặc mật khẩu!',
                validationErrors: 'Sai tài khoản hoặc mật khẩu!'));
      }
    } else {
      _showCupertinoDialog(
          'Lỗi',
          'Không tải được file dữ liệu. Vui lòng đăng nhập online trước!',
          context);
      return LoginRequestResult(
          error: LoginError(
        code: "",
        details:
            'Không tải được file dữ liệu. Vui lòng đăng nhập online trước!',
        message:
            'Không tải được file dữ liệu. Vui lòng đăng nhập online trước!',
        validationErrors:
            'Không tải được file dữ liệu. Vui lòng đăng nhập online trước!',
      ));
    }
  } catch (e) {
    _showCupertinoDialog('Lỗi', e.toString() + '!', context);
    return LoginRequestResult(
        error: LoginError(
      code: "",
      details: e.toString(),
      message: e.toString(),
      validationErrors: e.toString(),
    ));
  }
}

//end class Defination
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Karion Business Solution',
      theme: ThemeData(
        // This is the theme of your application.

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Karion Business Solution'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

_showMaterialDialog(String title, String content, BuildContext context) {
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
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

class _MyHomePageState extends State<MyHomePage> {
  var client = http.Client();

  final _account = TextEditingController();
  final _password = TextEditingController();
  final _tenantId = TextEditingController(text: '2');
  bool rememberMe = false;
  bool _validate = false;
  bool isBusy = false;
  bool isLoggedIn = false;
  bool isLoggedInOffline = false;
  String token = "";
  String username = "";
  late int userid;
  late String errorMessage;
  late String name;
  late String picture;
  late Future<LoginRequestResult> _futureLogin;
  late String account1;
  late String password1;
  bool _obscureText = true;
  bool saveInfo = false;
// Hàm load tài khoản đã lưu
  void _loadSavedAccount() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');
    String? savedPassword = prefs.getString('password');
    bool? savedSaveInfo = prefs.getBool('saveInfo');

    if (savedUsername != null &&
        savedPassword != null &&
        savedSaveInfo == true) {
      _account.text = savedUsername;
      _password.text = savedPassword;
      saveInfo = true;
    } else {
      saveInfo = false;
    }

    setState(() {}); // Cập nhật giao diện
  }

  @override
  void initState() {
    _loadSavedAccount();
    final responses = readFile("auths.data");
    // Use the compute function to run parsePhotos in a separate isolate.
    responses.then((response) {
      if (response != "N/A") {
        final LoginOfflineData data =
            LoginOfflineData.fromJson(json.decode(response));
        setState(() {
          _account.text = data.username;
          _password.text = data.password;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    void _onRememberMeChanged(bool newValue) => setState(() {
          rememberMe = newValue;

          if (rememberMe) {
            // TODO: Here goes your functionality that remembers the user.
          } else {
            // TODO: Forget the user
          }
        });

    int tenantid = int.tryParse(_tenantId.text) ?? 2;

    return Scaffold(
        // appBar: AppBar(
        //   title: Text(widget.title),
        // ),

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
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Hệ thống quản lý kinh doanh nước",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),

                      const CircleAvatar(
                        radius: 80, // Kích thước ảnh
                        backgroundImage: AssetImage(
                            './assets/image/logo_app_nuoc-removebg-preview.png'),

                        backgroundColor: Color(0xFFEEEEEE),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          obscureText: false,
                          enabled: false,
                          controller: _tenantId,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Tenant ID',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          obscureText: false,
                          controller: _account,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Tài khoản',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _password,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Mật khẩu',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Checkbox(
                              value: saveInfo,
                              onChanged: (bool? value) {
                                setState(() {
                                  saveInfo = value ?? true;
                                });
                              },
                            ),
                            const Text('Nhớ tài khoản mật khẩu'),
                          ],
                        ),
                      ),
                      // OutlinedButton(onPressed: (){}, child: Icon(Icons.remove_red_eye_outlined)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 45,
                              child: OutlinedButton(
                                onPressed: () {
                                  // Respond to button press
                                  (_account.text.isEmpty ||
                                          _password.text.isEmpty)
                                      ? _validate = true
                                      : _validate = false;
                                  if (_validate == true) {
                                    _showCupertinoDialog(
                                        "Lỗi",
                                        "Bạn chưa nhập Tài khoản hoặc mật khẩu!",
                                        context);
                                  } else {
                                    setState(() {
                                      _futureLogin = login(
                                          client,
                                          _account.text,
                                          tenantid,
                                          _password.text,
                                          saveInfo,
                                          context);
                                      _futureLogin.then((value) {
                                        if (value != null) {
                                          bool status = value.result!.status;
                                          if (status) {
                                            isLoggedIn = true;
                                            isLoggedInOffline = false;
                                            token = value.result!.token;
                                            username = value.result!.username;
                                            userid = value.result!.userid;

                                            writeFile(
                                                _account.text + "auth.data",
                                                json.encode(LoginOfflineData(
                                                  username: _account.text,
                                                  password: _password.text,
                                                  tenantid: tenantid,
                                                  userid: userid,
                                                ).toJson()));
                                            showNotice(
                                                "Lấy thông tin đăng nhập thành công!",
                                                context);
                                            // print("Lấy thông tin đăng nhập thành công!");
                                            Navigator.of(context).pop();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TabBarScr()),
                                              // MaterialPageRoute(builder: (context) => MyApp()),
                                            );
                                          }
                                        } else {
                                          showNotice(
                                              "Sai tài khoản hoặc mật khẩu!",
                                              context);
                                        }
                                      });
                                    });
                                  }
                                },
                                child: const Text('Lấy dữ liệu đăng nhập'),
                              ),
                            ),
                            const Text("   "),
                            // Container(
                            //   width: 160,
                            //   height: 45,
                            //   child: OutlinedButton(
                            //     onPressed: () {
                            //       // Respond to button press
                            //       (_account.text.isEmpty ||
                            //               _password.text.isEmpty)
                            //           ? _validate = true
                            //           : _validate = false;
                            //       if (_validate == true) {
                            //         _showCupertinoDialog(
                            //             "Lỗi",
                            //             "Bạn chưa nhập Tài khoản hoặc mật khẩu!!",
                            //             context);
                            //       } else {
                            //         setState(() {
                            //           _futureLogin = loginOffline(
                            //               client,
                            //               _account.text,
                            //               _password.text,
                            //               tenantid,
                            //               context);
                            //
                            //           _futureLogin.then((value) {
                            //             if (value.result != null) {
                            //               bool status = value.result!.status;
                            //               if (status) {
                            //                 isLoggedIn = true;
                            //                 isLoggedInOffline = true;
                            //                 token = value.result!.token;
                            //                 username = value.result!.username;
                            //                 userid = value.result!.userid;
                            //                 Navigator.of(context).pop();
                            //                 Navigator.push(
                            //                   context,
                            //                   MaterialPageRoute(
                            //                       builder: (context) =>
                            //                           MyDashBoard(
                            //                             title: "Dashboard ",
                            //                             isLoggedIn: isLoggedIn,
                            //                             isLoggedInOffline:
                            //                                 isLoggedInOffline,
                            //                             token: token,
                            //                             username: username,
                            //                             userid: userid,
                            //                           )),
                            //                   // MaterialPageRoute(builder: (context) => MyApp()),
                            //                 );
                            //               }
                            //             }
                            //           });
                            //         });
                            //       }
                            //     },
                            //     child: const Text('Đăng nhập'),
                            //   ),
                            // )
                            Container(
                              width: 160,
                              height: 45,
                              child: OutlinedButton(
                                onPressed: () {
                                  // Respond to button press
                                  (_account.text.isEmpty ||
                                      _password.text.isEmpty)
                                      ? _validate = true
                                      : _validate = false;
                                  if (_validate == true) {
                                    _showCupertinoDialog(
                                        "Lỗi",
                                        "Bạn chưa nhập Tài khoản hoặc mật khẩu!!",
                                        context);
                                  } else {
                                    setState(() {
                                      _futureLogin = loginOffline(
                                          client,
                                          _account.text,
                                          _password.text,
                                          tenantid,
                                          context);

                                      _futureLogin.then((value) {
                                        if (value.result != null) {
                                          bool status = value.result!.status;
                                          if (status) {
                                            isLoggedIn = true;
                                            isLoggedInOffline = true;
                                            token = value.result!.token;
                                            username = value.result!.username;
                                            userid = value.result!.userid;
                                            Navigator.of(context).pop();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyDashBoard(
                                                        title: "Quản Lý",
                                                        isLoggedIn: isLoggedIn,
                                                        isLoggedInOffline:
                                                        isLoggedInOffline,
                                                        token: token,
                                                        username: username,
                                                        userid: userid,
                                                      )),
                                              // MaterialPageRoute(builder: (context) => MyApp()),
                                            );
                                          }
                                        }
                                      });
                                    });
                                  }
                                },
                                child: const Text('Đăng nhập'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ))

        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

class MyDashBoard extends StatefulWidget {
  MyDashBoard(
      {super.key,
      required this.title,
      required this.isLoggedIn,
      required this.isLoggedInOffline,
      required this.token,
      required this.username,
      required this.userid});

  final String title;
  final String token;
  final bool isLoggedIn;
  final bool isLoggedInOffline;
  final String username;
  final int userid;

  @override
  _MyDashBoardState createState() => _MyDashBoardState();
}

class _MyDashBoardState extends State<MyDashBoard> {
  var client = http.Client();

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = widget.isLoggedIn;
    bool isLoggedInOffline = widget.isLoggedInOffline;
    String token = widget.token;
    String username = widget.username;
    int userid = widget.userid;
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TabBarScr()),
                  );
                },
                child: RichText(
                    text: const TextSpan(
                  children: [
                    TextSpan(
                        text: "Thoát ", style: TextStyle(color: Colors.black)),
                    WidgetSpan(
                      child: Icon(Icons.logout, size: 14),
                    ),
                  ],
                ))),
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
                          // const Padding(
                          //   padding: EdgeInsets.all(8.0),
                          //   child: Text("Máy chủ:" + $GetServer),
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Xin chào " + username, style: TextStyle(
                              fontSize: 18,
                            ),),
                          ),
                          SelectAction(
                            name: "Ghi chỉ số",
                            action: "ghichiso",
                            icon: Icons.access_alarm,
                            token: token,
                            isLoggedIn: isLoggedIn,
                            isLoggedInOffline: isLoggedInOffline,
                            username: username,
                            userid: userid,
                            tenantid: 2,
                          ),
                          SelectAction(
                            name: "Thu tiền",
                            action: "thutien",
                            icon: Icons.monetization_on_outlined,
                            token: token,
                            isLoggedIn: isLoggedIn,
                            isLoggedInOffline: isLoggedInOffline,
                            username: username,
                            userid: userid,
                            tenantid: 2,

                          ),
                          SelectAction(
                            name: "Tổng hợp thu tiền",
                            action: "tonghopthutien",
                            icon: Icons.money_rounded,
                            token: token,
                            isLoggedIn: isLoggedIn,
                            isLoggedInOffline: isLoggedInOffline,
                            username: username,
                            userid: userid,
                            tenantid: 2,

                          )
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

class SelectAction extends StatelessWidget {
  SelectAction(
      {super.key,
      required this.name,
      required this.action,
      required this.icon,
      required this.token,
      required this.isLoggedIn,
      required this.isLoggedInOffline,
      required this.username,
      required this.userid,
      required this.tenantid,
      });

  final String name;
  final String action;
  final IconData icon;
  final String token;
  final bool isLoggedIn;
  final bool isLoggedInOffline;
  final String username;
  final int userid;
  final int tenantid;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(2),
        height: 120,
        child: GestureDetector(
          onTap: () {
            if (action == "ghichiso") {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GhiChiSo(
                          title: "Ghi chỉ số",
                          isLoggedIn: isLoggedIn,
                          isLoggedInOffline: isLoggedInOffline,
                          token: token,
                          username: username,
                          userid: userid,
                      tenantid: tenantid,
                        )),
                // MaterialPageRoute(builder: (context) => MyApp()),
              );
            } else if (action == "thutien") {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ThuTien(
                          title: "Thu tiền",
                          isLoggedIn: this.isLoggedIn,
                          isLoggedInOffline: this.isLoggedInOffline,
                          token: this.token,
                          username: this.username,
                          userid: this.userid,
                        )),
                // MaterialPageRoute(builder: (context) => MyApp()),
              );
            } else if (action == "tonghopthutien") {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TongHopThuTien(
                          title: "Tổng hợp thu tiền",
                          isLoggedIn: isLoggedIn,
                          isLoggedInOffline: isLoggedInOffline,
                          token: token,
                          username: username,
                          userid: userid,
                        )),
                // MaterialPageRoute(builder: (context) => MyApp()),
              );
            }
          },
          child: Card(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Icon(icon, size: 28),
                ),
                Expanded(
                    child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24)),
                          ],
                        )))
              ])),
        ));
  }
}
