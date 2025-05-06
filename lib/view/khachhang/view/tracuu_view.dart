import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../view_model/tra_cuu_viewmodel.dart';
import '../../../drawer/bottom_drawer.dart';

class HoaDonScreen extends StatefulWidget {
  const HoaDonScreen({super.key});

  @override
  State<HoaDonScreen> createState() => _HoaDonScreenState();
}

class _HoaDonScreenState extends State<HoaDonScreen> {
  DateTime selectedDateTime = DateTime.now();
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;

  final TextEditingController tenKHController = TextEditingController();
  final TextEditingController maHDController = TextEditingController();
  final TextEditingController mstController = TextEditingController();

  String formatCurrency(int amount) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HoaDonViewModel>(context);
    List<int> years = List.generate(15, (index) => DateTime.now().year - index);
    List<int> months = List.generate(12, (index) => index + 1);

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      //     child: Column(
      //       children: [
      //         Column(
      //           children: [
      //             _buildDropdowns(months, years),
      //             const SizedBox(height: 10),
      //             _buildSearchFields(),
      //             const SizedBox(height: 12),
      //             _buildSearchButton(viewModel),
      //             const SizedBox(height: 20),
      //           ],
      //         ),
      //
      //
      //         Expanded(
      //           child: viewModel.isLoading
      //               ? const Center(child: CircularProgressIndicator())
      //               : viewModel.response != null
      //                   ? (viewModel.response!.listData.isNotEmpty
      //                       ? _buildResultTable(viewModel)
      //                       : const Center(
      //                           child: Text("Không có thông tin đang tìm.", style: TextStyle(
      //                             fontSize: 22,
      //                             fontWeight: FontWeight.bold
      //                           ),)))
      //                   // : const Center(child: Text("Không có dữ liệu.")),
      //                   : SingleChildScrollView(
      //                       child: Center(
      //                         child: Column(
      //                           children: [
      //                             Image.asset(
      //                               './assets/image/logo_app_nuoc-removebg-preview.png',
      //                               width: 240,
      //                               height: 240,
      //                             ),
      //                             const Text(
      //                               'Nước Sạch Nam Sơn',
      //                               style: TextStyle(
      //                                   fontSize: 26, color: Colors.blueAccent),
      //                             )
      //                           ],
      //                         ),
      //                       ),
      //                     ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          _buildDropdowns(months, years),
                          const SizedBox(height: 10),
                          _buildSearchFields(),
                          const SizedBox(height: 12),
                          _buildSearchButton(viewModel),
                          const SizedBox(height: 20),
                        ],
                      ),
                              Expanded(
                                child: viewModel.isLoading
                                    ? const Center(child: CircularProgressIndicator())
                                    : viewModel.response != null
                                        ? (viewModel.response!.listData.isNotEmpty
                                            ? _buildResultTable(viewModel)
                                            : const Center(
                                                child: Text("Không có thông tin đang tìm.", style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold
                                                ),)))
                                        // : const Center(child: Text("Không có dữ liệu.")),
                                        : SingleChildScrollView(
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  Image.asset(
                                                    './assets/image/logo_app_nuoc-removebg-preview.png',
                                                    width: 240,
                                                    height: 240,
                                                  ),
                                                  const Text(
                                                    'Nước Sạch Nam Sơn',
                                                    style: TextStyle(
                                                        fontSize: 26, color: Colors.blueAccent),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),)
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDropdowns(List<int> months, List<int> years) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<int>(
            value: selectedMonth,
            onChanged: (int? newValue) {
              setState(() {
                selectedMonth = newValue!;
              });
            },
            items: months.map((int month) {
              return DropdownMenuItem<int>(
                value: month,
                child:
                    Text('Tháng $month', style: const TextStyle(fontSize: 16)),
              );
            }).toList(),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Chọn tháng',
            ),
            isExpanded: true,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField<int>(
            value: selectedYear,
            onChanged: (int? newValue) {
              setState(() {
                selectedYear = newValue!;
              });
            },
            items: years.map((int year) {
              return DropdownMenuItem<int>(
                value: year,
                child: Text('Năm $year', style: const TextStyle(fontSize: 16)),
              );
            }).toList(),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Chọn năm',
            ),
            isExpanded: true,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchFields() {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            controller: tenKHController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Tên khách hàng',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: maHDController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Mã hợp đồng',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: mstController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Mã số thuế',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchButton(HoaDonViewModel viewModel) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () {
          viewModel.getHoaDon(
            thang: selectedMonth,
            nam: selectedYear,
            maHopDong: maHDController.text,
            tenKhachHang: tenKHController.text,
            mst: mstController.text,
          );
        },
        icon: const Icon(Icons.search),
        label: const Text(
          'Tìm kiếm',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildResultTable(HoaDonViewModel viewModel) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Table(
        border: TableBorder.all(),
        columnWidths: const {
          0: FixedColumnWidth(80),
          1: FlexColumnWidth(),
          2: FlexColumnWidth(),
          3: FlexColumnWidth(),
        },
        children: [
          _buildTableHeader(),
          ...viewModel.response!.listData
              .map((item) => _buildTableRow(item))
              .toList(),
        ],
      ),
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: BoxDecoration(color: Colors.blue[100]),
      children: const [
        _TableCell(text: 'Hành động'),
        _TableCell(text: 'Mã HĐ'),
        _TableCell(text: 'Khách hàng'),
        _TableCell(text: 'Số tiền'),
      ],
    );
  }

  TableRow _buildTableRow(item) {
    return TableRow(
      children: [
        Center(
          child: IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LearnNavigation(item: item),
                ),
              );
            },
          ),
        ),
        _TableCell(text: item.hopDong.maHopDong),
        _TableCell(text: item.hopDong.tenKhachHang ?? ''),
        _TableCell(
            text:
                '${formatCurrency(item.chiTietThanhToan.tongThanhTienSauVat)} đ'),
      ],
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;

  const _TableCell({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
