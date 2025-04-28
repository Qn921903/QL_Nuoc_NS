
import 'package:flutter/material.dart';
import 'package:qly_chi_so_nuoc/view/khachhang/view/chitietchiso.dart';
import 'package:qly_chi_so_nuoc/view/khachhang/view/chitiethopdong.dart';

class LearnNavigation extends StatefulWidget {
  final dynamic item;

  const LearnNavigation({super.key, required this.item});

  @override
  State<LearnNavigation> createState() => _LearnNavigationState();
}

class _LearnNavigationState extends State<LearnNavigation> {
  int pageIndex = 0;

  // Danh sách các màn hình, truyền item vào ChiTietKhachHang
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      ChiTietKhachHang(item: widget.item), // Truyền item vào ChiTietKhachHang
     // ThanhToan(),
      DetailHopDong(item: widget.item,),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageIndex], // Hiển thị màn hình tương ứng với pageIndex
      bottomNavigationBar: NavigationBar(
        height: 80,
        selectedIndex: pageIndex,
        onDestinationSelected: (index) {
          setState(() {
            pageIndex = index;
          });
        },
        backgroundColor: Colors.white,
        elevation: 8, // Thêm độ nổi để giao diện đẹp hơn
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, size: 30),
            selectedIcon: Icon(Icons.home_filled, color: Colors.blue, size: 35),
            label: 'Trang chủ',
          ),

          NavigationDestination(
            icon: Icon(Icons.person_outline, size: 30),
            selectedIcon: Icon(Icons.person, color: Colors.blue, size: 35),
            label: 'Hồ sơ',
          ),
        ],
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        indicatorColor: Colors.blue.withOpacity(0.2),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow, // Luôn hiển thị nhãn
      ),
    );
  }
}