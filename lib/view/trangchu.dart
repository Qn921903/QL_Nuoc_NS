// import 'package:flutter/material.dart';
// import 'package:qly_chi_so_nuoc/view/chitietchiso.dart';
// import 'chitiethopdong.dart';
//
// class SoHopDong extends StatefulWidget {
//   const SoHopDong({super.key});
//
//   @override
//   State<SoHopDong> createState() => _SoHopDongState();
// }
//
// class _SoHopDongState extends State<SoHopDong> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       // backgroundColor: Color(0xffd3f3fa),
//       appBar: AppBar(
//         title: const Text('Hợp Đồng'),
//         automaticallyImplyLeading: false,
//       ),
//       body: Column(
//         children: [
//           const Text(
//             'Hợp đồng 1',
//             style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
//           ),
//           Card(
//             child: TextButton(
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) =>  const Chitiet()));
//               },
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(5, 10, 0, 3),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     // ListTile(
//                     //   title: Text('Số hợp đồng: '),
//                     // ),
//                     const Text(
//                       'Mã hợp đồng: 111114444',
//                       style: TextStyle(
//                           fontSize: 18, fontWeight: FontWeight.w400),
//                     ),
//                     const Text(
//                       'Ng V A',
//                       style: TextStyle(
//                           fontSize: 18, fontWeight: FontWeight.w400),
//                     ),
//                     const Text(
//                       'Số đt: 020210133021',
//                       style: TextStyle(
//                           fontSize: 18, fontWeight: FontWeight.w400),
//                     ),
//                     Container(
//                       height: 80,
//                       padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
//                       child: const Text(
//                         'Địa chỉ: Số 12, Phạm Ngũ Lão, Hải Dương',
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.w400),
//                       ),
//                     ),
//
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             width: 280,
//             margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
//             decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey, width: 1),
//                 borderRadius: BorderRadius.circular(22),
//               color: Colors.blue
//             ),
//             child: TextButton(
//               onPressed: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>const DetailHopDong()));
//               },
//               child: const Text('Xem thông tin hợp đồng',
//                 style: TextStyle(
//                     fontSize: 22,
//                   color: Colors.white
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           const Divider(
//             height: 1,
//             color: Colors.black,
//           )
//         ],
//       ),
//     );
//   }
// }
