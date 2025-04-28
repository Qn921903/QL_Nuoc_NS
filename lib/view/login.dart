//
// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import 'package:http/http.dart' as http;
// import '../../drawer/bottom_drawer.dart';
// import '../System/Constant.dart';
// import '../model/login_data_model.dart';
//
//
//
//
// class LoginScr extends StatefulWidget {
//   LoginScr({Key? key}) : super(key: key);
//
//   @override
//   _LoginScrState createState() => _LoginScrState();
// }
//
//
// class _LoginScrState extends State<LoginScr> {
//   final _account = TextEditingController();
//   final _password = TextEditingController();
//   handleLogin (){
//     Navigator.push(context, MaterialPageRoute(builder: (context)=> const LearnNavigation()));
//   }
//   late LoginRequestResult loginRequestResult ;
//
//   Future<LoginRequestResult> login( String account,
//       String password) async {
//
//     try {
//
//       // showLoadingIndicator("Đăng nhập ...", context);
//       final response = await http.post(
//         Uri.https($GetServer,
//             "/api/services/app/MobileAppServices/MobileLogin"),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(<String, String>{
//           'accountName': account,
//           'passWord': password,
//         }),
//       );
//       // hideOpenDialog(context);
//       // Use the compute function to run parsePhotos in a separate isolate.
//       if (response.statusCode == 200) {
//         print('Dữ Liệu____------: ${response.body}');
//         loginRequestResult =LoginRequestResult.fromJson(jsonDecode(response.body));
//         print('Dữ Liệu loginRequestResult: $loginRequestResult');
//         return loginRequestResult ;
//       } else {
//         print('Lỗi Sai tài khoản hoặc mật khẩu/Hoặc tài khoản bị khóa!');
//         throw Exception('Đăng nhập thất bại: Sai tài khoản hoặc mật khẩuq');
//         // _showCupertinoDialog('Lỗi', 'Sai tài khoản hoặc mật khẩu/Hoặc tài khoản bị khóa!', context);
//       }
//     } catch (e) {
//       print('Lỗi '+ e.toString() + '!');
//       throw Exception('Đăng nhập thất bại: ' + e.toString());
//       // hideOpenDialog(context);
//     }
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text(widget.title),
//       // ),
//       body: GestureDetector(
//         onTap: () {
//           FocusScope.of(context).unfocus();
//         },
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Image.asset("./assets/image/logo1.png", width: 120),
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Text(
//                     "Hệ thống quản lý kinh doanh nước",
//                     style: TextStyle(fontSize: 20.0),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextField(
//                     // obscureText: true,
//                     controller: _account,
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'Số CCCD',
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextField(
//                     // obscureText: true,
//                     controller: _password,
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'Mật khẩu',
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: 200,
//                   height: 60,
//                   child: OutlinedButton(
//                     // onPressed: ()=>login(_account.text,_password.text),
//                     onPressed: (){
//                       Navigator.push(context, MaterialPageRoute(builder: (context)=>LearnNavigation()));
//                     },
//                     child: const Text('Đăng nhập', style: TextStyle(
//                       fontSize: 20
//                     ),),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
