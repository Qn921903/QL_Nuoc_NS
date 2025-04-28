import 'package:flutter/material.dart';
import '../view/login.dart';
import '../view/nhanvien/login.dart';
import '../view/khachhang/view/tracuu_view.dart';
/// Flutter code sample for [TabBar].



class TabBarScr extends StatelessWidget {
  const TabBarScr({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đăng Nhập', style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 28
          ),),
          centerTitle: true,
          bottom:  const TabBar(
            tabs: <Widget>[
              Tab(text: 'Khách hàng',

              ),
              Tab(text: 'Nhân viên',),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            // Center(child: LoginScr()),
            Center(child: HoaDonScreen()),
            Center(child: MyHomePage(title: '',)),
          ],
        ),
      ),
    );
  }
}