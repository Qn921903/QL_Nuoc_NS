import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  LoadingIndicator({this.text = ''});

  final String text;

  @override
  Widget build(BuildContext context) {
    var displayedText = text;

    return Container(
        padding: EdgeInsets.all(16),
        color: Colors.black87,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _getLoadingIndicator(),
              _getHeading(context),
              _getText(displayedText)
            ]
        )
    );
  }

  Padding _getLoadingIndicator() {
    return Padding(
        child: Container(
            child: CircularProgressIndicator(
                strokeWidth: 3
            ),
            width: 32,
            height: 32
        ),
        padding: EdgeInsets.only(bottom: 16)
    );
  }

  Widget _getHeading(context) {
    return
      Padding(
          child: Text(
            'Please wait …',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16
            ),
            textAlign: TextAlign.center,
          ),
          padding: EdgeInsets.only(bottom: 4)
      );
  }

  Text _getText(String displayedText) {
    return Text(
      displayedText,
      style: TextStyle(
          color: Colors.white,
          fontSize: 14
      ),
      textAlign: TextAlign.center,
    );
  }

}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> _localFile(String $filename) async {
  final path = await _localPath;
  return File('$path/' + $filename);
}

Future<String> readFile(String $filename) async {
  try {
    final file = await _localFile($filename);

    // Read the file.
    String contents = await file.readAsString();

    return contents;
  } catch (e) {
    // If encountering an error, return 0.
    return "N/A";
  }
}

Future<File> writeFile(String $filename, String $data) async {
  final file = await _localFile($filename);

  // Write the file.
  return file.writeAsString($data);
}
Future delFile(String $key) async {
  String directory = (await getApplicationDocumentsDirectory()).path;
  List<FileSystemEntity> files = Directory(directory).listSync(recursive: false);


  for (var fileSystemEntity in files) {
   if(fileSystemEntity.path.contains($key)){
     File(fileSystemEntity.path).deleteSync();
   }
  }

}

void showLoadingIndicator(String text, BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return PopScope(
        canPop: false, // Điều khiển việc cho phép thoát hay không
        onPopInvoked: (didPop) {
          if (!didPop) {
            // Logic xử lý khi người dùng nhấn nút quay lại
          }
        },
        child: Scaffold(
          appBar: AppBar(title: Text("Trang chủ")),
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    },
  );
}

void hideOpenDialog(BuildContext context) {
  Navigator.of(context).pop();
}

Future<bool> checkInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

      return true;
    }
    throw Exception('Đã có lỗi xảy ra: ');
  } on SocketException catch (_) {
    // throw Exception('Đã có lỗi xảy ra: ' + e.toString());
    return false;

  }
}


void showNotice(String text, BuildContext context) {
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}

List<String> ChuSo = [
  " không",
  " một",
  " hai",
  " ba",
  " bốn",
  " năm",
  " sáu",
  " bẩy",
  " tám",
  " chín"
];
List<String> Tien = [ "", " nghìn", " triệu", " tỷ", " nghìn tỷ", " triệu tỷ"];

String DocSo3ChuSo(int baso) {
  int tram, chuc, donvi;
  String KetQua = "";
  tram = (baso ~/ 100);
  chuc = ((baso % 100) ~/ 10);
  donvi = baso % 10;
  if ((tram == 0) && (chuc == 0) && (donvi == 0)) return "";
  if (tram != 0) {
    KetQua += ChuSo[tram] + " trăm";
    if ((chuc == 0) && (donvi != 0)) KetQua += " linh";
  }
  if ((chuc != 0) && (chuc != 1)) {
    KetQua += ChuSo[chuc] + " mươi";
    if ((chuc == 0) && (donvi != 0)) KetQua = KetQua + " linh";
  }
  if (chuc == 1) KetQua += " mười";
  switch (donvi) {
    case 1:
      if ((chuc != 0) && (chuc != 1)) {
        KetQua += " mốt";
      }
      else {
        KetQua += ChuSo[donvi];
      }
      break;
    case 5:
      if (chuc == 0) {
        KetQua += ChuSo[donvi];
      }
      else {
        KetQua += " lăm";
      }
      break;
    default:
      if (donvi != 0) {
        KetQua += ChuSo[donvi];
      }
      break;
  }
  return KetQua;
}

String DocTienBangChu(int SoTien, String strTail) {
  int lan, i;
  int so;
  String KetQua = "",
      tmp = "";
  List<int> ViTri = [0, 0, 0, 0, 0, 0];
  if (SoTien < 0) return "Số tiền âm !";
  if (SoTien == 0) return "Không đồng !";
  if (SoTien > 0) {
    so = SoTien;
  }
  else {
    so = -SoTien;
  }
//Kiểm tra số quá lớn
  if (SoTien > 8999999999999999) {
    SoTien = 0;
    return "";
  }
  ViTri[5] = (so ~/ 1000000000000000);
  so = so - int.parse(ViTri[5].toString()) * 1000000000000000;
  ViTri[4] = (so ~/ 1000000000000);
  so = so - int.parse(ViTri[4].toString()) * 1000000000000;
  ViTri[3] = (so ~/ 1000000000);
  so = so - int.parse(ViTri[3].toString()) * 1000000000;
  ViTri[2] = (so ~/ 1000000);
  ViTri[1] = ((so % 1000000) ~/ 1000);
  ViTri[0] = (so % 1000);
  if (ViTri[5] > 0) {
    lan = 5;
  }
  else if (ViTri[4] > 0) {
    lan = 4;
  }
  else if (ViTri[3] > 0) {
    lan = 3;
  }
  else if (ViTri[2] > 0) {
    lan = 2;
  }
  else if (ViTri[1] > 0) {
    lan = 1;
  }
  else {
    lan = 0;
  }
  for (i = lan; i >= 0; i--) {
    tmp = DocSo3ChuSo(ViTri[i]);
    KetQua += tmp;
    if (ViTri[i] != 0) KetQua += Tien[i];
    if ((i > 0) && (tmp != "" && tmp != null))
      KetQua += ","; //&& (!string.IsNullOrEmpty(tmp))
  }
  if (KetQua.substring(KetQua.length - 1, KetQua.length) == ",")
    KetQua = KetQua.substring(0, KetQua.length - 1);
  KetQua = KetQua.trim() + strTail;
  return KetQua.substring(0, 1).toUpperCase() + KetQua.substring(1);
}

List<String> CharList() {
  return [
  "À",
  "Á",
  "Â",
  "Ã",
  "È",
  "É",
  "Ê",
  "Ì",
  "Í",
  "Ò",
  "Ó",
  "Ô",
  "Õ",
  "Ù",
  "Ú",
  "Ý",
  "à",
  "á",
  "â",
  "ã",
  "è",
  "é",
  "ê",
  "ì",
  "í",
  "ò",
  "ó",
  "ô",
  "õ",
  "ù",
  "ú",
  "ý",
  "Ă",
  "ă",
  "Đ",
  "đ",
  "Ĩ",
  "ĩ",
  "Ũ",
  "ũ",
  "Ơ",
  "ơ",
  "Ư",
  "ư",
  "Ạ",
  "ạ",
  "Ả",
  "ả",
  "Ấ",
  "ấ",
  "Ầ",
  "ầ",
  "Ẩ",
  "ẩ",
  "Ẫ",
  "ẫ",
  "Ậ",
  "ậ",
  "Ắ",
  "ắ",
  "Ằ",
  "ằ",
  "Ẳ",
  "ẳ",
  "Ẵ",
  "ẵ",
  "Ặ",
  "ặ",
  "Ẹ",
  "ẹ",
  "Ẻ",
  "ẻ",
  "Ẽ",
  "ẽ",
  "Ế",
  "ế",
  "Ề",
  "ề",
  "Ể",
  "ể",
  "Ễ",
  "ễ",
  "Ệ",
  "ệ",
  "Ỉ",
  "ỉ",
  "Ị",
  "ị",
  "Ọ",
  "ọ",
  "Ỏ",
  "ỏ",
  "Ố",
  "ố",
  "Ồ",
  "ồ",
  "Ổ",
  "ổ",
  "Ỗ",
  "ỗ",
  "Ộ",
  "ộ",
  "Ớ",
  "ớ",
  "Ờ",
  "ờ",
  "Ở",
  "ở",
  "Ỡ",
  "ỡ",
  "Ợ",
  "ợ",
  "Ụ",
  "ụ",
  "Ủ",
  "ủ",
  "Ứ",
  "ứ",
  "Ừ",
  "ừ",
  "Ử",
  "ử",
  "Ữ",
  "ữ",
  "Ự",
  "ự",
  "Ỳ",
  "ỳ",
  "Ỵ",
  "ỵ",
  "Ỷ",
  "ỷ",
  "Ỹ",
  "ỹ",
  " ",
  "!",
  '"',
  "#",
  "%",
  "&",
  "'",
  "(",
  ")",
  "*",
  "+",
  ",",
  "-",
  ".",
  "/",
  "0",
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  ":",
  ";",
  "<",
  "=",
  ">",
  "?",
  "@",
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z",
  "[",
  "\\",
  "]",
  "^",
  "_",
  "`",
  "a",
  "b",
  "c",
  "d",
  "e",
  "f",
  "g",
  "h",
  "i",
  "j",
  "k",
  "l",
  "m",
  "n",
  "o",
  "p",
  "q",
  "r",
  "s",
  "t",
  "u",
  "v",
  "w",
  "x",
  "y",
  "z",
  "{",
  "|",
  "}",
  "~"
  ];
}

List<String> CharHexCode(){
  return
    [
      "00C0",
      "00C1",
      "00C2",
      "00C3",
      "00C8",
      "00C9",
      "00CA",
      "00CC",
      "00CD",
      "00D2",
      "00D3",
      "00D4",
      "00D5",
      "00D9",
      "00DA",
      "00DD",
      "00E0",
      "00E1",
      "00E2",
      "00E3",
      "00E8",
      "00E9",
      "00EA",
      "00EC",
      "00ED",
      "00F2",
      "00F3",
      "00F4",
      "00F5",
      "00F9",
      "00FA",
      "00FD",
      "0102",
      "0103",
      "0110",
      "0111",
      "0128",
      "0129",
      "0168",
      "0169",
      "01A0",
      "01A1",
      "01AF",
      "01B0",
      "1EA0",
      "1EA1",
      "1EA2",
      "1EA3",
      "1EA4",
      "1EA5",
      "1EA6",
      "1EA7",
      "1EA8",
      "1EA9",
      "1EAA",
      "1EAB",
      "1EAC",
      "1EAD",
      "1EAE",
      "1EAF",
      "1EB0",
      "1EB1",
      "1EB2",
      "1EB3",
      "1EB4",
      "1EB5",
      "1EB6",
      "1EB7",
      "1EB8",
      "1EB9",
      "1EBA",
      "1EBB",
      "1EBC",
      "1EBD",
      "1EBE",
      "1EBF",
      "1EC0",
      "1EC1",
      "1EC2",
      "1EC3",
      "1EC4",
      "1EC5",
      "1EC6",
      "1EC7",
      "1EC8",
      "1EC9",
      "1ECA",
      "1ECB",
      "1ECC",
      "1ECD",
      "1ECE",
      "1ECF",
      "1ED0",
      "1ED1",
      "1ED2",
      "1ED3",
      "1ED4",
      "1ED5",
      "1ED6",
      "1ED7",
      "1ED8",
      "1ED9",
      "1EDA",
      "1EDB",
      "1EDC",
      "1EDD",
      "1EDE",
      "1EDF",
      "1EE0",
      "1EE1",
      "1EE2",
      "1EE3",
      "1EE4",
      "1EE5",
      "1EE6",
      "1EE7",
      "1EE8",
      "1EE9",
      "1EEA",
      "1EEB",
      "1EEC",
      "1EED",
      "1EEE",
      "1EEF",
      "1EF0",
      "1EF1",
      "1EF2",
      "1EF3",
      "1EF4",
      "1EF5",
      "1EF6",
      "1EF7",
      "1EF8",
      "1EF9",
      "0020",
      "0021",
      "0022",
      "0023",
      "0025",
      "0026",
      "0027",
      "0028",
      "0029",
      "002A",
      "002B",
      "002C",
      "002D",
      "002E",
      "002F",
      "0030",
      "0031",
      "0032",
      "0033",
      "0034",
      "0035",
      "0036",
      "0037",
      "0038",
      "0039",
      "003A",
      "003B",
      "003C",
      "003D",
      "003E",
      "003F",
      "0040",
      "0041",
      "0042",
      "0043",
      "0044",
      "0045",
      "0046",
      "0047",
      "0048",
      "0049",
      "004A",
      "004B",
      "004C",
      "004D",
      "004E",
      "004F",
      "0050",
      "0051",
      "0052",
      "0053",
      "0054",
      "0055",
      "0056",
      "0057",
      "0058",
      "0059",
      "005A",
      "005B",
      "005C",
      "005D",
      "005E",
      "005F",
      "0060",
      "0061",
      "0062",
      "0063",
      "0064",
      "0065",
      "0066",
      "0067",
      "0068",
      "0069",
      "006A",
      "006B",
      "006C",
      "006D",
      "006E",
      "006F",
      "0070",
      "0071",
      "0072",
      "0073",
      "0074",
      "0075",
      "0076",
      "0077",
      "0078",
      "0079",
      "007A",
      "007B",
      "007C",
      "007D",
      "007E"
    ];
}

String CharToHexCode(String char){
  return CharHexCode()[CharList().indexOf(char)];
}
class ReturnBackUint8List {
  bool status;
  Uint8List? dulieu;
  String path;
  ReturnBackUint8List({required this.status, required this.dulieu,required this.path});
}