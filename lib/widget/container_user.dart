import 'package:flutter/material.dart';

class ContainerUser extends StatelessWidget {
  final String title;
  var description;

   ContainerUser({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(

      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child:  Column(
        children: [
          Container(
            height: 80,
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(title),
                Text(description),
              ],
            ),
          ),
          const Divider(
            color: Colors.black, // Màu sắc của đường kẻ
            thickness: 1, // Độ dày của đường kẻ

          )
        ],
      ),
    );
  }
}
