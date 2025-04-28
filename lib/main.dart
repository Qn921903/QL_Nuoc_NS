import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'drawer/tabbar_view.dart';
import 'view/khachhang/view_model/tra_cuu_viewmodel.dart';
import 'view/khachhang/view_model/chitiet_tracuu_viewmodel.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


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
