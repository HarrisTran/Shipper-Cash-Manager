import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tintin_money/features/shipper/data/DTO/shipper_data_dto.dart';
import 'package:tintin_money/features/shipper/services/shipper_data_service.dart';
import 'package:tintin_money/features/transaction/data/enums/transaction_status.dart';
import 'package:tintin_money/service_locator.dart';
import '../../../../features/transaction/presentation/pages/cash_counting_page.dart';

class ShipperListContent extends StatefulWidget {
  const ShipperListContent({super.key, this.searchQuery = ''});

  final String searchQuery;

  @override
  State<ShipperListContent> createState() => _ShipperListContentState();
}

class _ShipperListContentState extends State<ShipperListContent> {
  late final Stream<List<ShipperDataDto>> _shipperStream;

  @override
  void initState() {
    super.initState();
    _shipperStream = serviceLocator<ShipperDataService>().watchShippersData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ShipperDataDto>>(
      stream: _shipperStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Đã xảy ra lỗi.'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final shippers = snapshot.data ?? [];
        final filteredShippers = shippers
            .where(
              (s) => s.name.toLowerCase().contains(
                widget.searchQuery.toLowerCase(),
              ),
            )
            .toList();
        if (filteredShippers.isEmpty) {
          return const Center(child: Text('Không có dữ liệu.'));
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredShippers.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final s = filteredShippers[index];
            return ShipperStateCard(
              id: s.id,
              name: s.name,
              phone: s.phone,
              status: s.transactionStatus,
              imageUrl: s.avatar,
            );
          },
        );
      },
    );
  }
}

class ShipperStateCard extends StatelessWidget {
  final String id;
  final String name;
  final String phone;
  final TransactionStatus status;
  final String imageUrl;
  const ShipperStateCard({
    super.key,
    required this.id,
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
              shipperId: id,
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
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 64,
                  height: 64,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 64,
                  height: 64,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.person, color: Colors.grey),
                ),
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
  final TransactionStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color fgColor;
    IconData icon;
    String text;

    switch (status) {
      case TransactionStatus.done:
        bgColor = const Color(0xFF006C4A);
        fgColor = Colors.white;
        icon = Icons.check_circle;
        text = 'Xong';
        break;
      case TransactionStatus.notdone:
        bgColor = const Color(0xFFFEF0C7);
        fgColor = const Color.fromARGB(255, 255, 0, 0);
        icon = Icons.warning_amber_rounded;
        text = 'Chưa xong';
        break;
      case TransactionStatus.wait:
        bgColor = const Color(0xFFFFDADA);
        fgColor = const Color(0xFF40000C);
        icon = Icons.access_time_filled;
        text = 'Chờ';
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
