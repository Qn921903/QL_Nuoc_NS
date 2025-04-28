
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saver_gallery/saver_gallery.dart'; // Thêm thư viện này
import '../view_model/chitiet_tracuu_viewmodel.dart';
import 'qr_view.dart';
import 'package:flutter/rendering.dart';

class ChiTietKhachHang extends StatefulWidget {
  final dynamic item;

  const ChiTietKhachHang({super.key, required this.item});

  @override
  State<ChiTietKhachHang> createState() => _ChiTietKhachHangState();
}

class _ChiTietKhachHangState extends State<ChiTietKhachHang> {
  GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chiTietViewModel = Provider.of<ChiTietViewModel>(context, listen: false);
      chiTietViewModel.fetchChiTiet(widget.item.chiTietThanhToan.id);
    });
  }

  String formatCurrency(int amount) {
    return NumberFormat('#,###', 'vi_VN').format(amount) + ' đ';
  }


  Future<void> _saveQrToGallery() async {
    try {
      final context = globalKey.currentContext;

      // Kiểm tra nếu context là null
      if (context == null) {
        return; // Nếu context là null thì không thực hiện tiếp
      }

      RenderRepaintBoundary boundary = context.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      // Kiểm tra nếu byteData là null
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể chuyển đổi ảnh thành byteData')),
        );
        return;
      }

      Uint8List pngBytes = byteData.buffer.asUint8List();

      // Lưu ảnh vào thư viện ảnh
      final result = await SaverGallery.saveImage(pngBytes, skipIfExists: false, fileName: 'QRCode_${DateTime.now().millisecondsSinceEpoch}.png');

      if (result.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mã QR đã được lưu vào thư viện!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lưu thất bại')),
        );
      }
    } catch (e) {
      print("Error when saving QR: $e");

      // Kiểm tra nếu context là null trước khi sử dụng ScaffoldMessenger
      if (globalKey.currentContext != null) {
        ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Đã xảy ra lỗi khi lưu QR')),
        );
      }
    }
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
        final qrString = itemData.qrString;

        return Scaffold(
          appBar: AppBar(
            title: Text('Hóa đơn tháng ${DateFormat('MM/yyyy').format(DateTime.now())}'),
            backgroundColor: Colors.blue,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Họ và tên: ${hopDong.tenKhachHang}', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Địa chỉ: ${hopDong.diaChi}', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Chỉ số cũ: ${chiTiet.chiSoCu}'),
                    Text('Chỉ số mới: ${chiTiet.chiSoMoi}'),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Tổng tiêu thụ: ${chiTiet.tongSuDung} m3'),
                const SizedBox(height: 16),
                // Table
                buildTable(chiTiet),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.yellow[100],
                  width: double.infinity,
                  child: Text(
                    'Tổng tiền sau VAT: ${formatCurrency(chiTiet.tongThanhTienSauVat)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 150,
                        height: 45,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 1),
                            borderRadius: BorderRadius.circular(20)
                        ),
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: ElevatedButton(
                          onPressed: _saveQrToGallery, // Lưu QR khi nhấn
                          child: const Text('Lưu QR', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      Container(
                        width: 250,
                        height: 250,
                        child: QRCodeScreen(qrString: qrString),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildTable(chiTiet) {
    int tongSuDung = chiTiet.thanhTienChiTiet.fold(0, (sum, item) => sum + item.soLuong);
    int tongThanhTien = chiTiet.thanhTienChiTiet.fold(0, (sum, item) => sum + item.thanhTien);
    int status = chiTiet.status;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Table(
        border: const TableBorder.symmetric(inside: BorderSide(color: Colors.grey)),
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(2),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(color: Colors.grey[300]),
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Sản lượng', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Đơn giá', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Thành tiền', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          ...chiTiet.thanhTienChiTiet.map<TableRow>((item) => TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${item.soLuong} m3'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${formatCurrency(item.donGia)}'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${formatCurrency(item.thanhTien)}'),
              ),
            ],
          )),
          TableRow(
            decoration: BoxDecoration(color: Colors.yellow[100]),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Tổng: ${tongSuDung} m3', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(''),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  formatCurrency(tongThanhTien),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          TableRow(
            decoration: BoxDecoration(color: Colors.yellow[100]),
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Trạng Thái', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(''),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  status == 0 ? 'Chưa Thanh Toán' : 'Đã Thanh Toán',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: status == 0 ? Colors.red : Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
