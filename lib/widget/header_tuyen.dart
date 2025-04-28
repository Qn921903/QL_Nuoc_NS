import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Tìm kiếm')),
        body: const SearchWidget(),
      ),
    );
  }
}

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  String? selectedValue;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              DropdownButton<String>(
                hint: const Text('Chọn giá trị'),
                value: selectedValue,
                items: const [
                  DropdownMenuItem(value: 'Chưa thanh toán', child: Text('Chưa thanh toán')),
                  DropdownMenuItem(value: 'Đã thanh toán', child: Text('Đã thanh toán')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                  });
                },
              ),

              const SizedBox(width: 10),

              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Tìm kiếm...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              IconButton(
                onPressed: () {
                  print('Tìm kiếm: ${_searchController.text}, Trạng thái: $selectedValue');
                },
                icon: const Icon(Icons.search, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Expanded(
            child: ListView(
              children: const [
                DataCard(
                  name: 'Bác Lâm-KH005893',
                  address: 'Phan Đăng Lưu',
                  trashAmount: '1',
                  totalAmount: '39,273',
                  status: 'Chưa thu',
                ),
                DataCard(
                  name: 'Nguyễn Thị Lan-KH005894',
                  address: '5 Bùi Mộng Hoa',
                  trashAmount: '1',
                  totalAmount: '29,455',
                  status: 'Chưa thu',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DataCard extends StatelessWidget {
  final String name;
  final String address;
  final String trashAmount;
  final String totalAmount;
  final String status;

  const DataCard({
    super.key,
    required this.name,
    required this.address,
    required this.trashAmount,
    required this.totalAmount,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.bookmark, color: Colors.blue),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📍 $address'),
            Text('🗑️ Khối lượng rác: $trashAmount'),
            Text('💰 Tổng tiền: $totalAmount'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}