// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class WaterUsageApp extends StatefulWidget {
//   const WaterUsageApp({super.key});
//
//   @override
//   _WaterUsageAppState createState() => _WaterUsageAppState();
// }
//
// DateTime dateSelect = DateTime.now();
// String currentMonth = "Tháng ${DateFormat('M').format(dateSelect)}";
// int selectedYear = DateTime.now().year;
// int year_ht = 2025;
//
// class _WaterUsageAppState extends State<WaterUsageApp> {
//   final List<Map<String, dynamic>> data = [
//     {'id': '1', "month": "Tháng 1", "usage": 30, "cost": 150000},
//     {'id': '2', "month": "Tháng 2", "usage": 28, "cost": 140000},
//     {'id': '3', "month": "Tháng 3", "usage": 32, "cost": 160000},
//     {'id': '4', "month": "Tháng 4", "usage": 35, "cost": 175000},
//     {'id': '5', "month": "Tháng 5", "usage": 33, "cost": 165000},
//     {'id': '6', "month": "Tháng 6", "usage": 31, "cost": 155000},
//     {'id': '7', "month": "Tháng 7", "usage": 36, "cost": 180000},
//     {'id': '8', "month": "Tháng 8", "usage": 34, "cost": 170000},
//     {'id': '9', "month": "Tháng 9", "usage": 29, "cost": 145000},
//     {'id': '10', "month": "Tháng 10", "usage": 30, "cost": 150000},
//     {'id': '11', "month": "Tháng 11", "usage": 27, "cost": 135000},
//     {'id': '12', "month": "Tháng 12", "usage": 32, "cost": 160000}
//     // setState(() {
//     // selectedMonth = data[index];
//     // });
//   ];
//
//   Map<String, dynamic>? selectedMonth;
//
//   @override
//   Widget build(BuildContext context) {
//     List<int> years = List.generate(15, (index) => DateTime.now().year - index);
//     return Scaffold(
//       appBar: AppBar(title: const Text('Chỉ số nước theo tháng')),
//       body: Column(
//         children: [
//           DropdownButtonFormField<int>(
//             value: selectedYear,
//             onChanged: (int? newValue) {
//               setState(() {
//                 selectedYear = newValue!;
//               });
//             },
//             items: years.map<DropdownMenuItem<int>>((int year) {
//               return DropdownMenuItem<int>(
//
//                 value: year,
//                 child: Text('$year',
//                   style: TextStyle(
//                     fontSize: 22
//                   ),
//                 ),
//               );
//             }).toList(),
//             decoration: InputDecoration(
//               border: OutlineInputBorder(),
//             ),
//             isExpanded: true,
//             menuMaxHeight: 200,
//           ),
//
//           Expanded(
//             child: ListView.builder(
//               itemCount: data.length,
//               itemBuilder: (context, index) {
//                 bool isCurrentMonth = data[index]['month'] == currentMonth &&
//                     year_ht == selectedYear;
//                 return ListTile(
//                   title: Container(
//                     height: 70,
//                     decoration: BoxDecoration(
//                         // borderRadius: BorderRadius.circular(10)
//                         ),
//                     child: TextButton(
//                       style: TextButton.styleFrom(
//                         backgroundColor: isCurrentMonth
//                             ? Colors.lightBlueAccent
//                             : Colors.white,
//                       ),
//                       child: Text(
//                         data[index]['month'],
//                         style:
//                             const TextStyle(fontSize: 20, color: Colors.black),
//                       ),
//                       onPressed: () {
//                         // handleClick();
//                         setState(() {
//                           selectedMonth = data[index];
//                         });
//                         showModalBottomSheet(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return ModalShow(
//                                 selectedMonth: selectedMonth,
//                               );
//                             });
//                       },
//                     ),
//                   ),
//
//                   // onTap: () {
//                   //   setState(() {
//                   //     selectedMonth = data[index];
//                   //   });
//                   //
//                   //   showModalBottomSheet(
//                   //       context: context,
//                   //       builder: (BuildContext context) {
//                   //         return ModalShow( selectedMonth: selectedMonth,);
//                   //       });
//                   //   // showModalBottomSheet(
//                   //   //   context: context,
//                   //   //   builder: (BuildContext context)=>{
//                   //   //   return ModalShow(selectedMonth: selectedMonth,);
//                   //   //   }
//                   //     // builder: (context) => SizedBox(
//                   //     //   height: 200,
//                   //     //   width: 200,
//                   //     //
//                   //     //   child: Column(
//                   //     //     // mainAxisSize: MainAxisSize.min,
//                   //     //     // mainAxisAlignment: MainAxisAlignment.start,
//                   //     //     children: [
//                   //     //       Text(selectedMonth!['month'],
//                   //     //           style: const TextStyle(
//                   //     //               fontSize: 22, fontWeight: FontWeight.bold)),
//                   //     //       const SizedBox(),
//                   //     //       Text('Chỉ số nước: ${selectedMonth!['usage']}'),
//                   //     //       Text(
//                   //     //           'Số tiền phải trả: ${selectedMonth!['cost']} VND'),
//                   //     //       const SizedBox(height: 20),
//                   //     //       ElevatedButton(
//                   //     //         onPressed: () => Navigator.pop(context),
//                   //     //         child: const Text('Đóng'),
//                   //     //       ),
//                   //     //     ],
//                   //     //   ),
//                   //     // ),
//                   //   // );
//                   // },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ModalShow extends StatefulWidget {
//   var selectedMonth;
//
//   ModalShow({super.key, required this.selectedMonth});
//
//   @override
//   State<ModalShow> createState() => _ModalShowState();
// }
//
// class _ModalShowState extends State<ModalShow> {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 320,
//       width: 400,
//       child: Column(
//         // mainAxisSize: MainAxisSize.min,
//         // mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Text(widget.selectedMonth!['month'],
//               style:
//                   const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
//           const SizedBox(
//             height: 10,
//           ),
//           Text(
//             'Chỉ số nước: ${widget.selectedMonth!['usage']} số',
//             style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
//           ),
//           Text(
//             'Số tiền phải trả: ${widget.selectedMonth!['cost']} VND',
//             style: const TextStyle(
//                 fontSize: 22, color: Colors.black, fontWeight: FontWeight.w400),
//           ),
//           const SizedBox(height: 20),
//           SizedBox(
//             width: 200,
//             height: 60,
//             child: ElevatedButton(
//               style:
//                   ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent),
//               onPressed: () => Navigator.pop(context),
//               child: const Text(
//                 'Đóng',
//                 style: TextStyle(
//                     fontSize: 22,
//                     color: Colors.black,
//                     fontWeight: FontWeight.w400),
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           SizedBox(
//             width: 200,
//             height: 60,
//             child: ElevatedButton(
//               style:
//                   ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
//               onPressed: () => Navigator.pop(context),
//               child: const Text(
//                 'Xem hóa đơn',
//                 style: TextStyle(
//                     fontSize: 20,
//                     color: Colors.white,
//                     fontWeight: FontWeight.w400),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class ViewCalendar extends StatefulWidget {
  ViewCalendar({super.key});

  @override
  State<ViewCalendar> createState() => _ViewCalendarState();
}

class _ViewCalendarState extends State<ViewCalendar> {
  DateTime dateSelect = DateTime.now();

// String currentMonth = "Tháng ${DateFormat('M').format(dateSelect)}";
  int selectedYear = DateTime.now().year;

  int year_ht = 2025;

  final List<Map<String, dynamic>> data = [
    {
      'id': '1',
      "month": "Tháng 1",
      "chiso": "100",
      "usage": 30,
      "cost": 150000,
      'status': 'đã thanh toán'
    },
    {
      'id': '2',
      "month": "Tháng 2",
      "chiso": "100",
      "usage": 28,
      "cost": 140000,
      'status': 'đã thanh toán'
    },
    {
      'id': '3',
      "month": "Tháng 3",
      "chiso": "100",
      "usage": 32,
      "cost": 160000,
      'status': 'đã thanh toán'
    },
    {
      'id': '4',
      "month": "Tháng 4",
      "chiso": "100",
      "usage": 35,
      "cost": 175000,
      'status': 'đã thanh toán'
    },
    {
      'id': '5',
      "month": "Tháng 5",
      "chiso": "100",
      "usage": 33,
      "cost": 165000,
      'status': 'đã thanh toán'
    },
    {
      'id': '6',
      "month": "Tháng 6",
      "chiso": "100",
      "usage": 31,
      "cost": 155000,
      'status': 'đã thanh toán'
    },
    {
      'id': '7',
      "month": "Tháng 7",
      "chiso": "100",
      "usage": 36,
      "cost": 180000,
      'status': 'đã thanh toán'
    },
    {
      'id': '8',
      "month": "Tháng 8",
      "chiso": "100",
      "usage": 34,
      "cost": 170000,
      'status': 'đã thanh toán'
    },
    {
      'id': '9',
      "month": "Tháng 9",
      "chiso": "100",
      "usage": 29,
      "cost": 145000,
      'status': 'đã thanh toán'
    },
    {
      'id': '10',
      "month": "Tháng 10",
      "chiso": "100",
      "usage": 30,
      "cost": 150000,
      'status': 'đã thanh toán'
    },
    {
      'id': '11',
      "month": "Tháng 11",
      "chiso": "100",
      "usage": 27,
      "cost": 135000,
      'status': 'đã thanh toán'
    },
    {
      'id': '12',
      "month": "Tháng 12",
      "chiso": "100",
      "usage": 32,
      "cost": 160000,
      'status': 'đã thanh toán'
    }
  ];

  @override
  Widget build(BuildContext context) {
    List<int> years = List.generate(15, (index) => DateTime.now().year - index);

    return Scaffold(
      appBar: AppBar(title: const Text('Bảng hóa đơn')),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: DropdownButtonFormField<int>(
              value: selectedYear,
              onChanged: (int? newValue) {
                setState(() {
                  selectedYear = newValue!;
                });
              },
              items: years.map<DropdownMenuItem<int>>((int year) {
                return DropdownMenuItem<int>(
                  value: year,
                  child: Text(
                    'Năm $year',
                    style: TextStyle(fontSize: 22),
                  ),
                );
              }).toList(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              isExpanded: true,
              menuMaxHeight: 200,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              // Cho phép cuộn nếu bảng quá rộng
              child: DataTable(
                border: TableBorder.all(),
                columnSpacing: 20, // Khoảng cách giữa các cột
                columns: [
                  DataColumn(
                      label: Container(
                          width: 80,
                          child: const Text('Tháng',
                              style: TextStyle(fontWeight: FontWeight.bold))
                      )),
                  DataColumn(
                      label: Container(
                        width: 60,
                        child: const Text('Chỉ số',
                            maxLines: 2,
                            softWrap: true,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )),
                  DataColumn(
                      label: Container(
                        width: 60,
                        child: const Text('Số điện tiêu thụ',
                            maxLines: 2,
                            softWrap: true,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )),
                  DataColumn(
                      label: Container(
                        width: 80,
                        child: const Text('Số tiền (VNĐ)',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            softWrap: true,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )),
                  DataColumn(
                      label: Container(
                        width: 100,
                        child: const Text('Trạng thái',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )),
                ],
                rows: data.map((item) {
                  return DataRow(cells: [
                    DataCell(Text(item["month"].toString(),
                        style: const TextStyle(fontSize: 16))),
                    DataCell(Text(item["chiso"].toString())),
                    DataCell(Text(item["usage"].toString())),
                    DataCell(Text(item["cost"].toString())),
                    DataCell(Text(item["status"].toString())),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
