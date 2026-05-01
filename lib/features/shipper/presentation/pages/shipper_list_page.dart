import 'package:flutter/material.dart';
import '../../../../features/transaction/presentation/pages/cash_counting_page.dart';

class ShipperListContent extends StatelessWidget {
  const ShipperListContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> shippers = [
      {
        'name': 'Nguyễn Văn An',
        'phone': '090 123 4567',
        'done': true,
        'img': 'assets/images/avatar/Avatar Users2_1.png',
      },
      {
        'name': 'Lê Thị Bìnhh',
        'phone': '091 987 6543',
        'done': false,
        'img': 'assets/images/avatar/Avatar Users2_5.png',
      },
      {
        'name': 'Trần Văn Cường',
        'phone': '098 555 1234',
        'done': false,
        'img': 'assets/images/avatar/Avatar Users2_8.png',
      },
      {
        'name': 'Phạm Minh Hoàng',
        'phone': '097 444 8888',
        'done': true,
        'img': 'assets/images/avatar/Avatar Users2_12.png',
      },
      {
        'name': 'Đặng Thu Thảo',
        'phone': '096 111 2222',
        'done': false,
        'img': 'assets/images/avatar/Avatar Users2_15.png',
      },
      {
        'name': 'Vũ Minh Đức',
        'phone': '093 333 4444',
        'done': true,
        'img': 'assets/images/avatar/Avatar Users2_20.png',
      },
      {
        'name': 'Hoàng Nam Anh',
        'phone': '094 555 6666',
        'done': false,
        'img': 'assets/images/avatar/Avatar Users2_25.png',
      },
      {
        'name': 'Phan Thanh Hải',
        'phone': '092 777 8888',
        'done': true,
        'img': 'assets/images/avatar/Avatar Users2_30.png',
      },
      {
        'name': 'Bùi Thị Tuyết',
        'phone': '095 999 0000',
        'done': false,
        'img': 'assets/images/avatar/Avatar Users2_35.png',
      },
      {
        'name': 'Ngô Gia Huy',
        'phone': '089 123 7890',
        'done': true,
        'img': 'assets/images/avatar/Avatar Users2_40.png',
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: shippers.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final s = shippers[index];
        return ShipperStateCard(
          name: s['name'],
          phone: s['phone'],
          isDone: s['done'],
          imageUrl: s['img'],
        );
      },
    );
  }
}

class ShipperStateCard extends StatelessWidget {
  final String name;
  final String phone;
  final bool isDone;
  final String imageUrl;
  const ShipperStateCard({
    super.key,
    required this.name,
    required this.phone,
    required this.isDone,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CashCountingPage(
              shipperName: name,
              shipperPhone: phone,
              shipperImageUrl: imageUrl,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 2, // tăng độ dày viền
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imageUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone_outlined,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        phone,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            StatusChip(isDone: isDone),
          ],
        ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final bool isDone;

  const StatusChip({super.key, required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDone ? const Color(0xFF006C4A) : const Color(0xFFFFDADA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.access_time_filled,
            size: 16,
            color: isDone ? Colors.white : const Color(0xFF40000C),
          ),
          const SizedBox(width: 6),
          Text(
            (isDone ? 'Đã xong' : 'Chưa chuyển').toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isDone ? Colors.white : const Color(0xFF40000C),
            ),
          ),
        ],
      ),
    );
  }
}
