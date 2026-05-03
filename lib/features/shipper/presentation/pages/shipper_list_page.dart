import 'package:flutter/material.dart';
import '../../../../features/transaction/presentation/pages/cash_counting_page.dart';

enum ShipperStatus { done, pending, feePending }

class ShipperListContent extends StatelessWidget {
  const ShipperListContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> shippers = [
      {
        'name': 'Nguyễn Văn An',
        'phone': '090 123 4567',
        'status': ShipperStatus.done,
        'img': 'assets/images/avatar/Avatar Users2_1.png',
      },
      {
        'name': 'Lê Thị Bìnhh',
        'phone': '091 987 6543',
        'status': ShipperStatus.pending,
        'img': 'assets/images/avatar/Avatar Users2_5.png',
      },
      {
        'name': 'Trần Văn Cường',
        'phone': '098 555 1234',
        'status': ShipperStatus.feePending,
        'img': 'assets/images/avatar/Avatar Users2_8.png',
      },
      {
        'name': 'Phạm Minh Hoàng',
        'phone': '097 444 8888',
        'status': ShipperStatus.done,
        'img': 'assets/images/avatar/Avatar Users2_12.png',
      },
      {
        'name': 'Đặng Thu Thảo',
        'phone': '096 111 2222',
        'status': ShipperStatus.pending,
        'img': 'assets/images/avatar/Avatar Users2_15.png',
      },
      {
        'name': 'Vũ Minh Đức',
        'phone': '093 333 4444',
        'status': ShipperStatus.done,
        'img': 'assets/images/avatar/Avatar Users2_20.png',
      },
      {
        'name': 'Hoàng Nam Anh',
        'phone': '094 555 6666',
        'status': ShipperStatus.feePending,
        'img': 'assets/images/avatar/Avatar Users2_25.png',
      },
      {
        'name': 'Phan Thanh Hải',
        'phone': '092 777 8888',
        'status': ShipperStatus.done,
        'img': 'assets/images/avatar/Avatar Users2_30.png',
      },
      {
        'name': 'Bùi Thị Tuyết',
        'phone': '095 999 0000',
        'status': ShipperStatus.pending,
        'img': 'assets/images/avatar/Avatar Users2_35.png',
      },
      {
        'name': 'Ngô Gia Huy',
        'phone': '089 123 7890',
        'status': ShipperStatus.done,
        'img': 'assets/images/avatar/Avatar Users2_40.png',
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: shippers.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final s = shippers[index];
        return ShipperStateCard(
          name: s['name'],
          phone: s['phone'],
          status: s['status'],
          imageUrl: s['img'],
        );
      },
    );
  }
}

class ShipperStateCard extends StatelessWidget {
  final String name;
  final String phone;
  final ShipperStatus status;
  final String imageUrl;
  const ShipperStateCard({
    super.key,
    required this.name,
    required this.phone,
    required this.status,
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
          border: Border.all(color: Colors.grey.shade300, width: 2),
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
            StatusChip(status: status),
          ],
        ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final ShipperStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color fgColor;
    IconData icon;
    String text;

    switch (status) {
      case ShipperStatus.done:
        bgColor = const Color(0xFF006C4A);
        fgColor = Colors.white;
        icon = Icons.check_circle;
        text = 'Đã xong';
        break;
      case ShipperStatus.feePending:
        bgColor = const Color(0xFFFEF0C7);
        fgColor = const Color(0xFFDC6803);
        icon = Icons.warning_amber_rounded;
        text = 'Chưa đưa phí';
        break;
      case ShipperStatus.pending:
        bgColor = const Color(0xFFFFDADA);
        fgColor = const Color(0xFF40000C);
        icon = Icons.access_time_filled;
        text = 'Chưa chuyển';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fgColor),
          const SizedBox(width: 6),
          Text(
            text.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: fgColor,
            ),
          ),
        ],
      ),
    );
  }
}
