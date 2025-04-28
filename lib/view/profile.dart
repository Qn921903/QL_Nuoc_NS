// import 'package:flutter/material.dart';
// import 'package:qly_chi_so_nuoc/drawer/tabbar_view.dart';
//
// import 'package:qly_chi_so_nuoc/widget/container_profile.dart';
// import 'package:qly_chi_so_nuoc/view/detail_profile/user_detail.dart';
// class Profile extends StatefulWidget {
//   const Profile({super.key});
//
//   @override
//   State<Profile> createState() => _ProfileState();
// }
//
// class _ProfileState extends State<Profile> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text('Thông tin cá nhân'),
//             ElevatedButton(
//               onPressed: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>TabBarScr()));
//               },
//               style: OutlinedButton.styleFrom(
//                   // backgroundColor: Colors.cyanAccent
//               ),
//               child: const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('Đăng xuất  ',
//                     style: TextStyle(
//                         fontSize: 20,
//                         color: Colors.red
//                     ),
//                   ),
//                   Icon(Icons.logout_sharp)
//                 ],
//               ),
//             ),
//           ],
//         ),
//         automaticallyImplyLeading: false,
//
//       ),
//       body:  Center(
//         child: Column(
//           children: [
//             Column(
//               children: [
//                 const CircleAvatar(
//                   radius: 80, // Kích thước ảnh
//                   backgroundImage: AssetImage('./assets/image/profile.png'),
//                   // backgroundColor: Colors.deepOrangeAccent,
//                 ),
//                 Container(
//                   margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       OutlinedButton(onPressed: (){
//                         print('object');
//                       }, child: const Row(
//                         children: [
//                           Icon(Icons.camera_alt_rounded),
//                           Text(' Sửa ảnh')
//                         ],
//                       )),
//                       // OutlinedButton(onPressed: (){
//                       //   Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailUser()));
//                       //
//                       // }, child: const Text('Thông tin cá nhân'))
//                     ],
//                   ),
//                 )
//               ],
//             ),
//             Container(
//
//               margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
//               child:  Column(
//                 children: [
//                   // Container(
//                   //   width: 400,
//                   //   height: 68,
//                   //   child: OutlinedButton(
//                   //     onPressed: (){},
//                   //     child: const Text('Những câu hỏi thường gặp ???',
//                   //       style: TextStyle(
//                   //         fontSize: 20
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ),
//                   const ContainerProfile(txt: 'Câu hỏi thường gặp', nextScreen: null),
//
//                   // Container(
//                   //   width: 400,
//                   //   height: 68,
//                   //   child: OutlinedButton(onPressed: (){},
//                   //     child: const Text('Giới thiệu',
//                   //       style: TextStyle(
//                   //           fontSize: 20
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ),
//                   const ContainerProfile(txt: 'Giới thiệu', nextScreen: null,),
//
//                   // Container(
//                   //   width: 400,
//                   //   height: 68,
//                   //   child: OutlinedButton(onPressed: (){},
//                   //     child: const Text('Liên hệ',
//                   //       style: TextStyle(
//                   //           fontSize: 20
//                   //       ),
//                   //     ),
//                   //   ),
//                   // )
//
//                   const ContainerProfile(txt: 'Liên hệ', nextScreen: null,),
//
//
//                 ],
//               ),
//             ),
//
//
//           ],
//         ),
//       ),
//     );
//   }
// }
