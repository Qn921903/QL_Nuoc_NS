// import '../System/Lib.dart';
// import 'preview.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:path_provider/path_provider.dart';
//
// class CameraScreen extends StatefulWidget {
//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }
//
// class _CameraScreenState extends State<CameraScreen> {
//   late CameraController cameraController;
//   late List cameras;
//   late int selectedCameraIndex;
//   late String imgPath;
//   Future initCamera(CameraDescription cameraDescription) async {
//     if (cameraController != null) {
//       await cameraController.dispose();
//     }
//
//     cameraController =
//         CameraController(cameraDescription, ResolutionPreset.medium);
//
//     cameraController.addListener(() {
//       if (mounted) {
//         setState(() {});
//       }
//     });
//
//     if (cameraController.value.hasError) {
//       print('Camera Error ${cameraController.value.errorDescription}');
//     }
//     try {
//       await cameraController.initialize();
//     } catch (e) {
//       showCameraException(e);
//     }
//
//     if (mounted) {
//       setState(() {});
//     }
//   }
//   /// Display camera preview
//
//   Widget cameraPreview() {
//     if (cameraController == null || !cameraController.value.isInitialized) {
//       return Text(
//         'Loading',
//         style: TextStyle(
//             color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
//       );
//     }
//
//     return AspectRatio(
//       aspectRatio: cameraController.value.aspectRatio,
//       child: CameraPreview(cameraController),
//     );
//   }
//
//   Widget cameraControl(context) {
//     return Expanded(
//       child: Align(
//         alignment: Alignment.center,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           mainAxisSize: MainAxisSize.max,
//           children: <Widget>[
//             FloatingActionButton(
//               child: Icon(
//                 Icons.camera,
//                 color: Colors.black,
//               ),
//               backgroundColor: Colors.white,
//               onPressed: () {
//                 onCapture(context);
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget cameraToggle() {
//     if (cameras == null || cameras.isEmpty) {
//       return Spacer();
//     }
//
//     CameraDescription selectedCamera = cameras[selectedCameraIndex];
//     CameraLensDirection lensDirection = selectedCamera.lensDirection;
//
//     return Expanded(
//       child: Align(
//         alignment: Alignment.centerLeft,
//         child: TextButton.icon(
//             onPressed: () {
//               onSwitchCamera();
//             },
//             icon: Icon(
//               getCameraLensIcons(lensDirection),
//               color: Colors.white,
//               size: 24,
//             ),
//             label: Text(
//               '${lensDirection.toString().substring(lensDirection.toString().indexOf('.') + 1).toUpperCase()}',
//               style:
//                   TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
//             )),
//       ),
//     );
//   }
//
//   // onCapture(context) async {
//   //   try {
//   //     final p = await getTemporaryDirectory();
//   //     final name = DateTime.now().millisecondsSinceEpoch;
//   //     final path = "${p.path}/$name.png";
//   //
//   //     await cameraController.takePicture(path).then((value) async{
//   //       print('here');
//   //       print(path);
//   //
//   //       final result = await Navigator.push(context, MaterialPageRoute(builder: (context) =>PreviewScreen(imgPath: path,fileName: "$name.png",)));
//   //       if(result.status){
//   //         result.path=path;
//   //         Navigator.pop(
//   //             context,
//   //             result
//   //         );
//   //       }
//   //     });
//   //
//   //   } catch (e) {
//   //     showCameraException(e);
//   //   }
//   // }
//
//   onCapture(context) async {
//     try {
//       final p = await getTemporaryDirectory();
//       final name = DateTime.now().millisecondsSinceEpoch;
//       final path = "${p.path}/$name.png";
//
//       final XFile picture = await cameraController.takePicture();
//       await picture.saveTo(path);
//
//       print('here');
//       print(path);
//
//       final result = await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => PreviewScreen(
//             imgPath: path,
//             fileName: "$name.png",
//           ),
//         ),
//       );
//
//       if (result.status) {
//         result.path = path;
//         Navigator.pop(context, result);
//       }
//     } catch (e) {
//       showCameraException(e);
//     }
//   }
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     availableCameras().then((value) {
//       cameras = value;
//       if(cameras.length > 0){
//         setState(() {
//           selectedCameraIndex = 0;
//         });
//         initCamera(cameras[selectedCameraIndex]).then((value) {
//
//         });
//       } else {
//         print('No camera available');
//       }
//     }).catchError((e){
//       print('Error : ${e.code}');
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Container(
//         child: Stack(
//           children: <Widget>[
// //            Expanded(
// //              flex: 1,
// //              child: _cameraPreviewWidget(),
// //            ),
//             Align(
//               alignment: Alignment.center,
//               child: cameraPreview(),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 height: 120,
//                 width: double.infinity,
//                 padding: EdgeInsets.all(15),
//                 color: Colors.transparent,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: <Widget>[
//                     cameraToggle(),
//                     cameraControl(context),
//                     Spacer(),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   getCameraLensIcons(lensDirection) {
//     switch (lensDirection) {
//       case CameraLensDirection.back:
//         return CupertinoIcons.switch_camera;
//       case CameraLensDirection.front:
//         return CupertinoIcons.switch_camera_solid;
//       case CameraLensDirection.external:
//         return CupertinoIcons.photo_camera;
//       default:
//         return Icons.device_unknown;
//     }
//   }
//
//   onSwitchCamera() {
//     selectedCameraIndex =
//         selectedCameraIndex < cameras.length - 1 ? selectedCameraIndex + 1 : 0;
//     CameraDescription selectedCamera = cameras[selectedCameraIndex];
//     initCamera(selectedCamera);
//   }
//
//   showCameraException(e) {
//     String errorText = 'Error ${e.code} \nError message: ${e.description}';
//   }
// }
import '../System/Lib.dart';
import 'preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? cameraController;
  late CameraController controller;
  late List cameras= [];
  late List<CameraDescription> _cameras;
  late int selectedCameraIndex;
  late String imgPath;


  //
  // @override
  // void initState() {
  //   super.initState();
  //   controller = CameraController(_cameras[0], ResolutionPreset.max);
  //   controller.initialize().then((_) {
  //     if (!mounted) {
  //       return;
  //     }
  //     setState(() {});
  //   }).catchError((Object e) {
  //     if (e is CameraException) {
  //       switch (e.code) {
  //         case 'CameraAccessDenied':
  //         // Handle access errors here.
  //           break;
  //         default:
  //         // Handle other errors here.
  //           break;
  //       }
  //     }
  //   });
  // }




  Future initCamera(CameraDescription cameraDescription) async {
    if (cameraController != null) {
      await cameraController!.dispose();
    }

    cameraController =
        CameraController(cameraDescription, ResolutionPreset.medium);

    cameraController!.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    if (cameraController!.value.hasError) {
      print('Camera Error ${cameraController!.value.errorDescription}');
    }

    try {
      await cameraController!.initialize();
    } catch (e) {
      // showCameraException(e);
      print('Lỗi Camera rồi _______--------: $e');
    }

    if (mounted) {
      setState(() {});
    }
  }

  /// Display camera preview

  Widget cameraPreview() {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return Text(
        'Loading',
        style: TextStyle(
            color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
      );
    }

    return AspectRatio(
      aspectRatio: cameraController!.value.aspectRatio,
      child: CameraPreview(cameraController!),
    );
  }

  Widget cameraControl(context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FloatingActionButton(
              child: Icon(
                Icons.camera,
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
              onPressed: () {
                onCapture(context);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget cameraToggle() {
    if (cameras == null || cameras.isEmpty) {
      return Spacer();
    }

    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: ElevatedButton.icon(
            onPressed: () {
              onSwitchCamera();
            },
            icon: Icon(
              getCameraLensIcons(lensDirection),
              color: Colors.white,
              size: 24,
            ),
            label: Text(
              '${lensDirection.toString().substring(lensDirection.toString().indexOf('.') + 1).toUpperCase()}',
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            )),
      ),
    );
  }

  onCapture(context) async {
    try {
      final p = await getTemporaryDirectory();
      final name = DateTime.now().millisecondsSinceEpoch;
      // final path = "${p.path}/$name.png";
      final XFile file = await cameraController!.takePicture();
      final path = '${(await getTemporaryDirectory()).path}/${DateTime.now().millisecondsSinceEpoch}.png';

      await file.saveTo(path);




      // await cameraController.takePicture(path).then((value) async{
      //   print('here');
      //   print(path);

      final result = await Navigator.push(context, MaterialPageRoute(builder: (context) =>PreviewScreen(imgPath: path,fileName: "$name.png",)));
      if(result.status){
        result.path=path;
        Navigator.pop(
            context,
            result
        );
      }
      // });

    } catch (e) {
      showCameraException(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    availableCameras().then((value) {
      cameras = value;
      if(cameras.length > 0){
        setState(() {
          selectedCameraIndex = 0;
        });
        initCamera(cameras[selectedCameraIndex]).then((value) {

        });
      } else {
        print('No camera available');
      }
    }).catchError((e){
      print('Error : ${e.code}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Stack(
          children: <Widget>[
//            Expanded(
//              flex: 1,
//              child: _cameraPreviewWidget(),
//            ),
            Align(
              alignment: Alignment.center,
              child: cameraPreview(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 120,
                width: double.infinity,
                padding: EdgeInsets.all(15),
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    cameraToggle(),
                    cameraControl(context),
                    Spacer(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  getCameraLensIcons(lensDirection) {
    switch (lensDirection) {
      case CameraLensDirection.back:
        return CupertinoIcons.switch_camera;
      case CameraLensDirection.front:
        return CupertinoIcons.switch_camera_solid;
      case CameraLensDirection.external:
        return CupertinoIcons.photo_camera;
      default:
        return Icons.device_unknown;
    }
  }

  onSwitchCamera() {
    selectedCameraIndex =
    selectedCameraIndex < cameras.length - 1 ? selectedCameraIndex + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    initCamera(selectedCamera);
  }

  showCameraException(e) {
    // String errorText = 'Error ${e.code} \nError message: ${e.description}';
    print('Lỗi __________-----------: $e');
  }
}





//
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
//
// late List<CameraDescription> _cameras;
//
// // Future<void> main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //
// //   _cameras = await availableCameras();
// //   runApp(const CameraApp());
// // }
//
// /// CameraApp is the Main Application.
// class CameraApp extends StatefulWidget {
//   /// Default Constructor
//   const CameraApp({super.key});
//
//   @override
//   State<CameraApp> createState() => _CameraAppState();
// }
//
// class _CameraAppState extends State<CameraApp> {
//   late CameraController controller;
//
//   @override
//   void initState() {
//     super.initState();
//     controller = CameraController(_cameras[0], ResolutionPreset.max);
//     controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     }).catchError((Object e) {
//       if (e is CameraException) {
//         switch (e.code) {
//           case 'CameraAccessDenied':
//           // Handle access errors here.
//             break;
//           default:
//           // Handle other errors here.
//             break;
//         }
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!controller.value.isInitialized) {
//       return Container();
//     }
//     return MaterialApp(
//       home: CameraPreview(controller),
//     );
//   }
// }