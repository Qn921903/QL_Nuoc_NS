import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'drawer/tabbar_view.dart';
import 'view/khachhang/view_model/tra_cuu_viewmodel.dart';
import 'view/khachhang/view_model/chitiet_tracuu_viewmodel.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // @override
  // void initState() {
  //   super.initState();
  //   initialization();
  // }
  //
  // void initialization() async {
  //
  //   await Future.delayed(const Duration(milliseconds: 100));
  //
  //   FlutterNativeSplash.remove();
  // }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HoaDonViewModel()),
        ChangeNotifierProvider(create: (_) => ChiTietViewModel()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TabBarScr(),
      ),
    );
  }
}
