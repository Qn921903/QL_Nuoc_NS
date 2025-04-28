// //
// // import 'package:flutter/material.dart';
// // import 'package:qly_chi_so_nuoc/view/calendar.dart';
// //
// // class HomeScr extends StatelessWidget {
// //   HomeScr({super.key});
// //
// //   DateTime selectedDate = DateTime.now();
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         centerTitle: true,
// //         title: const Text('Trang Home'),
// //       ),
// //       body: Container(
// //         width: 500,
// //         child: Center(
// //           child: Stack(
// //             children: [
// //               // Phần nền xanh với đường cong
// //               Positioned.fill(
// //                 child: ClipPath(
// //                   clipper: GreenBackgroundClipper(),
// //                   child: Container(
// //                     width: 400, // Màu xanh lá
// //                     color: const Color(0xFF18FFFF), // Màu xanh lá
// //                   ),
// //                 ),
// //               ),
// //               // Nội dung trên nền
// //               SafeArea(
// //                 child: Column(
// //                   children: [
// //                     const SizedBox(
// //                       height: 20,
// //                       width: 400,
// //                     ),
// //                     const Text(
// //                       // "Màn hình với nền xanh cong",
// //                       'Xin Chào',
// //                       style: TextStyle(
// //                           color: Colors.black,
// //                           fontSize: 30,
// //                           fontWeight: FontWeight.bold),
// //                     ),
// //                     SizedBox(
// //                       width: 200,
// //                       height: 150,
// //                       child: Image.asset(
// //                         './assets/image/output.png',
// //                       ),
// //                     ),
// //                     Text(
// //                       'Ngày: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
// //                       style: const TextStyle(
// //                         fontSize: 20,
// //                         color: Colors.deepOrangeAccent,
// //                         fontWeight: FontWeight.w600,
// //                       ),
// //                     ),
// //                     Container(
// //                       margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
// //                       width: 300,
// //                       height: 200,
// //                       // color: Colors.white,
// //                       decoration: BoxDecoration(
// //                           borderRadius: BorderRadius.circular(20),
// //                           color: Colors.white,
// //                           // color: Colors.red,
// //                           boxShadow: const [
// //                             BoxShadow(
// //                               color: Colors.grey,
// //                               spreadRadius: 5,
// //                               blurRadius: 7,
// //                               offset:
// //                                   Offset(0, 3), // changes position of shadow
// //                             ),
// //                           ]),
// //                       child: Center(
// //                           child: Container(
// //                             width: 280,
// //                             height: 160,
// //                             decoration: const BoxDecoration(
// //                               color: Color(0xFFFFAB91),
// //                               borderRadius: BorderRadius.only(
// //                                 topRight: Radius.circular(8),
// //                                 topLeft: Radius.circular(30),
// //                                 bottomLeft: Radius.circular(8),
// //                                 bottomRight: Radius.circular(30),
// //                               )
// //                             ),
// //                               child: Center(
// //                                   child: Column(
// //                                     children: [
// //                                       const Text('Nguy V A',
// //                                         style: TextStyle(
// //                                           fontSize: 24,
// //                                           fontWeight: FontWeight.w600,
// //                                           // color:
// //                                         ),
// //                                       ),
// //                                       const Text('Id: 100200312',
// //                                         style: TextStyle(
// //                                           fontSize: 18,
// //                                           fontWeight: FontWeight.w300,
// //                                           // color:
// //                                         ),
// //                                       ),
// //                                       const Text('Số nước: 100',
// //                                         style: TextStyle(
// //                                           fontSize: 18,
// //                                           fontWeight: FontWeight.w500,
// //                                           color: Colors.blue
// //                                           // color:
// //                                         ),
// //                                       ),
// //                                       SizedBox(
// //                                         width: 180,
// //                                         height: 60,
// //                                         child: ElevatedButton(
// //                                             child: const Text('Xem chi tiết -->',
// //                                               style: TextStyle(
// //                                                 fontSize: 18,
// //                                                 // fontWeight: FontWeight.w500,
// //                                                 color: Colors.redAccent
// //                                               ),
// //                                             ),
// //                                           onPressed: (){
// //                                               Navigator.push(context, MaterialPageRoute(builder: (context)=>WaterUsageApp()));
// //                                           },
// //                                         ),
// //                                       )
// //                                     ],
// //                                   )
// //                               )
// //                           )
// //                       ),
// //                     )
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // // Class tạo đường cong nửa màn hình
// // class GreenBackgroundClipper extends CustomClipper<Path> {
// //   @override
// //   Path getClip(Size size) {
// //     Path path = Path();
// //     double curveHeight = 80.0; // Độ cong của nền xanh
// //
// //     path.lineTo(0, size.height * 0.5); // Điểm bắt đầu từ góc trên
// //     path.quadraticBezierTo(
// //       size.width / 2, size.height * 0.5 + curveHeight, // Điểm giữa cong lên
// //       size.width, size.height * 0.5, // Điểm kết thúc đường cong
// //     );
// //     path.lineTo(size.width, 0); // Điểm về góc trên phải
// //     path.close();
// //
// //     return path;
// //   }
// //
// //   @override
// //   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// // }
// import 'package:flutter/material.dart';
// import 'calendar.dart';
//
// import 'chitietchiso.dart';
// class HomeScr extends StatelessWidget {
//   const HomeScr({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[350],
//       appBar: AppBar(
//         title: const Text('Trang chủ'),
//         automaticallyImplyLeading: true,
//       ),
//       body:  Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Card(
//
//               child: TextButton(
//                 onPressed: (){},
//                 child: const SizedBox(
//                   height: 120,
//                   child: Center(
//                     child: ListTile(
//                       title: Text('Thông tin tài khoản', style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.w600
//                       ),textAlign: TextAlign.center,),
//                     ),
//                   ),
//                 ),
//               ),
//
//             ),
//             Card(
//
//               child: TextButton(
//                 onPressed: (){
//                   Navigator.push(context, MaterialPageRoute(builder: (context)=>Chitiet()));
//                 },
//                 child: const SizedBox(
//                   height: 120,
//                   child: Center(
//                     child: ListTile(
//                       title: Text('Xem chỉ số', style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.w600
//                       ),textAlign: TextAlign.center,),
//                     ),
//                   ),
//                 ),
//               ),
//
//             ),
//             Card(
//               child: TextButton(
//                 onPressed: (){
//                   Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewCalendar()));
//                 },
//                 child: const SizedBox(
//                   height: 120,
//                   child: Center(
//                     child: ListTile(
//                       title: Text('Xem theo tháng', style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.w600
//                       ),textAlign: TextAlign.center,),
//                     ),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
