import 'dart:io';
import 'dart:typed_data';

// import 'package:esys_flutter_share/esys_flutter_share.dart';
import '../System/Lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PreviewScreen extends StatefulWidget {
  final String imgPath;
  final String fileName;
  PreviewScreen({required this.imgPath, required this.fileName});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Image.file(File(widget.imgPath),fit: BoxFit.cover,),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 60,
                color: Colors.black,
                child:Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton.icon(
                        icon: Icon(Icons.check,color: Colors.white),
                        // color: Colors.lightBlueAccent,
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent,
                        ),
                        label: Text("Chọn"),
                        onPressed: (){
                          getBytes().then((bytes) {
                            Navigator.pop(
                                context,
                                new ReturnBackUint8List(
                                    status: true, dulieu: null, path: ''
                                ));
                            //Share.file('Share via', widget.fileName, bytes.buffer.asUint8List(), 'image/path');
                          });
                        },
                      ),
                      Text(" "),
                      TextButton.icon(
                        icon: Icon(Icons.cancel,color: Colors.white),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                        ),
                        label: Text("Hủy"),
                        onPressed: (){

                            Navigator.pop(
                                context,
                                new ReturnBackUint8List(
                                    status: false, dulieu: null, path: ''
                                ));
                            //Share.file('Share via', widget.fileName, bytes.buffer.asUint8List(), 'image/path');

                        },
                      ),
                    ],
                  ),
                )

              ),
            )
          ],
        ),
      )
    );
  }

  Future getBytes () async {
    Uint8List bytes = File(widget.imgPath).readAsBytesSync() as Uint8List;
//    print(ByteData.view(buffer))
    return ByteData.view(bytes.buffer);
  }
}
