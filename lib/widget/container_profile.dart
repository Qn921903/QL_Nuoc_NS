import 'package:flutter/material.dart';

class ContainerProfile extends StatefulWidget {

  final String txt;
  final Widget? nextScreen;
  const ContainerProfile({super.key, required this.txt, required this.nextScreen});

  @override
  State<ContainerProfile> createState() => _ContainerProfileState();
}

class _ContainerProfileState extends State<ContainerProfile> {
  handlePress (){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>widget.nextScreen!));
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      width: 400,
      height: 68,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: OutlinedButton(onPressed: handlePress,
        child: Text(widget.txt,
          style: const TextStyle(
              fontSize: 20
          ),
        ),
      ),
    );
  }
}
