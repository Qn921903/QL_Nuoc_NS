import 'package:flutter/material.dart';

class DetailHopDong extends StatelessWidget {
  const DetailHopDong({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin chi tiết'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Center(
            child:  Column(
              children: [
                const SizedBox(
                  width: 350,
                  child: Card(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Hợp đồng 1',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text('Mã hợp đồng: 1223212321',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                   ),
                ),
                Container(
                  width: 350,
                  height: 400,
                  child: const Card(
                    child: Column(
                      children: [
                        Text('Họ Ten'),
                        Text('Số CCCD'),
                        Text('Ngày tháng năm sinh'),
                        Text('Số Điện Thoại'),
                        Text('Địa Chỉ'),
                        Text('Ngày ký hợp đồng'),
                        Text('Ngày lắp đặt'),

                      ],
                    ),
                  ),
                ),

                const Text('Thay đổi thông tin',
                  style: TextStyle(
                    fontSize: 20
                  ),
                ),
                Container(
                  width: 380,
                  height: 150,
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),

                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Điền thông tin cần thay đổi',
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,

                  ),
                ),

                Container(
                  width: 220,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: TextButton(onPressed: (){}, child: const Text('Gửi yêu cầu',
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}

