import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saver_gallery/saver_gallery.dart'; // Thêm thư viện này
import '../view_model/chitiet_tracuu_viewmodel.dart';
import 'qr_view.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';

class ChiTietKhachHang extends StatefulWidget {
  final dynamic item;

  const ChiTietKhachHang({super.key, required this.item});

  @override
  State<ChiTietKhachHang> createState() => _ChiTietKhachHangState();
}

class _ChiTietKhachHangState extends State<ChiTietKhachHang> {
  GlobalKey globalKey = GlobalKey();
  final GlobalKey qrKey = GlobalKey();

  // GlobalKey key = GlobalKey();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chiTietViewModel =
          Provider.of<ChiTietViewModel>(context, listen: false);
      chiTietViewModel.fetchChiTiet(widget.item.chiTietThanhToan.id);
    });
  }

  String formatCurrency(int amount) {
    return NumberFormat('#,###', 'vi_VN').format(amount) + ' đ';
  }

  Future<void> _saveQrToGallery() async {
    try {
      // print('Chức năng lưu QR');
      var status = await Permission.photos.request();
      // print('Trạng thái quyền: $status');

      if (!status.isGranted) {
        // print('Không có quyền lưu');
        await openAppSettings();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không có quyền lưu ảnh')),
        );
        return;
      }

      final renderObject = globalKey.currentContext?.findRenderObject();
      if (renderObject == null || renderObject is! RenderRepaintBoundary) {
        // print('Không tìm thấy RepaintBoundary');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể chụp ảnh QR')),
        );
        return;
      }

      await Future.delayed(const Duration(milliseconds: 500));
      ui.Image image = await renderObject.toImage(pixelRatio: 2.0);

      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Không thể chuyển đổi ảnh thành byteData')),
        );
        return;
      }

      Uint8List pngBytes = byteData.buffer.asUint8List();

      final result = await SaverGallery.saveImage(
        pngBytes,
        skipIfExists: false,
        fileName: 'QRCode_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      // print('Kết quả lưu: $result');

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
      // print('Lỗi khi lưu QR: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xảy ra lỗi khi lưu QR')),
      );
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
            title: Text(
                'Hóa đơn tháng ${DateFormat('MM/yyyy').format(DateTime.now())}'),
            backgroundColor: Colors.blue,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Họ và tên: ${hopDong.tenKhachHang}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Địa chỉ: ${hopDong.diaChi}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
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
                  child: chiTiet.status != 0
                      ? const Column(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                              size: 100,
                            ),
                            Text(
                              'Đã thanh toán',
                              style:
                                  TextStyle(color: Colors.green, fontSize: 20),
                            )
                          ],
                        )
                      : Column(
                          children: [
                            Container(
                              width: 150,
                              height: 40,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.blue, width: 1),
                                  borderRadius: BorderRadius.circular(20)),
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                              child: ElevatedButton(
                                onPressed: _saveQrToGallery, // Lưu QR khi nhấn
                                child: const Text('Lưu QR',
                                    style: TextStyle(fontSize: 18)),
                              ),
                            ),
                            RepaintBoundary(
                              key:
                                  globalKey, // Gắn globalKey vào RepaintBoundary
                              child: Container(
                                width: 200,
                                height: 200,
                                child: QRCodeScreen(
                                  qrString: qrString,
                                  repaintKey: qrKey,
                                ),
                              ),
                            )
                            // chiTiet.status == 0 ? RepaintBoundary(
                            //   key: globalKey, // Gắn globalKey vào RepaintBoundary
                            //   child: Container(
                            //     width: 200,
                            //     height: 200,
                            //     child: QRCodeScreen(
                            //       qrString: qrString,
                            //       repaintKey: qrKey,
                            //     ),
                            //   ),
                            // ) : Icon(Icons.check)

                            // chiTiet.status != 0? Column(
                            //   children: [
                            //     Icon(Icons.backspace),
                            //     Text('Chưa thanh toán')
                            //   ],
                            // ): Column(
                            //   children: [
                            //     Icon(Icons.check_circle_outline, color: Colors.green,size: 100,),
                            //     Text('Đã thanh toán', style: TextStyle(
                            //       color: Colors.green,
                            //       fontSize: 20
                            //     ),)
                            //   ],
                            // )
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
    int tongSuDung =
        chiTiet.thanhTienChiTiet.fold(0, (sum, item) => sum + item.soLuong);
    int tongThanhTien =
        chiTiet.thanhTienChiTiet.fold(0, (sum, item) => sum + item.thanhTien);
    int status = chiTiet.status;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Table(
        border:
            const TableBorder.symmetric(inside: BorderSide(color: Colors.grey)),
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
                child: Text('Sản lượng',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Đơn giá',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Thành tiền',
                    style: TextStyle(fontWeight: FontWeight.bold)),
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
                child: Text('Tổng: ${tongSuDung} m3',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
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
                child: Text('Trạng Thái',
                    style: TextStyle(fontWeight: FontWeight.bold)),
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
