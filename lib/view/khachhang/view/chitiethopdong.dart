
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../view_model/chitiet_tracuu_viewmodel.dart';
import '../../../drawer/tabbar_view.dart';
import 'tracuu_view.dart';
class DetailHopDong extends StatefulWidget {
  final dynamic item;

  const DetailHopDong({super.key, required this.item});

  @override
  State<DetailHopDong> createState() => _DetailHopDongState();
}

class _DetailHopDongState extends State<DetailHopDong> {
  final String phoneNumber = "0901234567";
  final String email = "example@email.com";
  // Hàm format ngày tháng
  String formatDateString(String inputDate) {
    try {
      final dateTime = DateTime.parse(inputDate);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } catch (e) {
      return 'Lỗi định dạng ngày';
    }
  }
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    // Hiển thị thông báo đã sao chép thành công
    // print('Đã sao chép: $text');
  }
  void handleOut(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>TabBarScr()));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chiTietViewModel = Provider.of<ChiTietViewModel>(context, listen: false);
      chiTietViewModel.fetchChiTiet(widget.item.chiTietThanhToan.id);

    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChiTietViewModel>(
      builder: (context, chiTietViewModel, child) {
        if (chiTietViewModel.isLoading) {
          return Scaffold(
            appBar: AppBar(title: const Text('Chi tiết hóa đơn')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final itemData = chiTietViewModel.chiTietData;
        if (itemData == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Chi tiết hóa đơn')),
            body: const Center(child: Text('Không có dữ liệu')),
          );
        }

        final chiTiet = itemData.chiTietThanhToan;
        final hopDong = itemData.hopDong;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Thông tin chi tiết'),
            backgroundColor: Colors.blue,
            elevation: 2,
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Card Hợp đồng
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            'Hợp đồng',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Mã hợp đồng: ${hopDong.maHopDong}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                    // Card Thông tin khách hàng
                     Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hopDong.tenKhachHang,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          Text(
                            hopDong.sdt.isEmpty ? 'Số điện thoại: Chưa có' : 'Số điện thoại: ${hopDong.sdt}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const Divider(),
                          Text(
                            'Địa chỉ: ${hopDong.diaChi}',
                            style: const TextStyle(fontSize: 18),
                            maxLines: 3, // Cho phép xuống dòng nếu địa chỉ dài
                            overflow: TextOverflow.ellipsis, // Thêm dấu ... nếu quá dài
                          ),
                          const Divider(),
                          Text(
                            'Ngày ký hợp đồng: ${formatDateString(hopDong.ngayKyHopDong)}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const Divider(),
                          Text(
                            'Ngày lắp đặt: ${formatDateString(hopDong.ngayLapDat)}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                   const SizedBox(height: 20),
                  // Tiêu đề Thay đổi thông tin
                  // const Text(
                  //   'Thay đổi thông tin',
                  //   style: TextStyle(
                  //     fontSize: 20,
                  //     fontWeight: FontWeight.w600,
                  //     color: Colors.blue,
                  //   ),
                  // ),
                  //  const SizedBox(height: 10),
                  // TextField để thay đổi thông tin
              // Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child: Container(
              //     width: double.infinity,
              //     height: 150,
              //     decoration: BoxDecoration(
              //       border: Border.all(color: Colors.blue, width: 2),
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     padding: const EdgeInsets.all(5),
              //     child: Column(
              //       children: [
              //         Text('Liên hệ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400), textAlign: TextAlign.center,),
              //
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(
              //               'Số điện thoại: $phoneNumber',
              //               style: TextStyle(fontSize: 16),
              //             ),
              //             IconButton(
              //               icon: Icon(Icons.copy),
              //               onPressed: () => _copyToClipboard(phoneNumber),
              //             ),
              //           ],
              //         ),
              //         SizedBox(height: 8),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(
              //               'Email: $email',
              //               style: TextStyle(fontSize: 16),
              //             ),
              //             IconButton(
              //               icon: Icon(Icons.copy),
              //               onPressed: () => _copyToClipboard(email),
              //             ),
              //           ],
              //         ),
              //       ],
              //     ),
              //   )),
                  Container(
                    width: 130,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent, width: 1),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.redAccent
                    ),
                    child: TextButton(
                      onPressed: handleOut,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout_outlined,
                            // size: 28,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10,),
                          Text('Thoát', style: TextStyle(
                            fontSize: 21,
                            color: Colors.white
                          ),),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ],
              ),
            ),
          ),
        );
      },
    );
  }
}