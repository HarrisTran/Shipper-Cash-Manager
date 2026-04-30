import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ShipperListPage extends StatelessWidget {
  const ShipperListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data cho danh sách Shipper
    final List<Map<String, String>> dummyShippers = [
      {'name': 'Nguyễn Văn An', 'phone': '090 123 4567'},
      {'name': 'Lê Thị Bình', 'phone': '091 987 6543'},
      {'name': 'Trần Văn Cường', 'phone': '098 555 1234'},
      {'name': 'Phạm Minh Hoàng', 'phone': '097 444 8888'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('SCM Manager'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // SearchAnchor (Material 3)
            SearchAnchor(
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  controller: controller,
                  padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  onTap: () {
                    controller.openView();
                  },
                  onChanged: (_) {
                    controller.openView();
                  },
                  leading: const Icon(Icons.search),
                  hintText: 'Tìm kiếm Shipper...',
                  elevation: const WidgetStatePropertyAll(0),
                  backgroundColor: WidgetStatePropertyAll(
                    AppColors.surfaceVariant.withValues(alpha: 0.5),
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: AppColors.outline),
                    ),
                  ),
                );
              },
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                    return List<ListTile>.generate(5, (int index) {
                      final String item = 'Shipper suggestion $index';
                      return ListTile(
                        title: Text(item),
                        onTap: () {
                          controller.closeView(item);
                        },
                      );
                    });
                  },
            ),
            const SizedBox(height: 24),
            // Danh sách Shipper
            Expanded(
              child: ListView.separated(
                itemCount: dummyShippers.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final shipper = dummyShippers[index];
                  return Card(
                    color: AppColors.surfaceVariant,
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(
                        shipper['name']!,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.call,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              shipper['phone']!,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // TODO: Xử lý khi nhấn vào Shipper
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const Center(child: Text('Cuộn lên để tìm thêm thành viên...')),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class ShipperListContent extends StatelessWidget {
  const ShipperListContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> shippers = [
      {
        'name': 'Nguyễn Văn An',
        'phone': '090 123 4567',
        'done': true,
        'img': 'assets/images/Avatar Users2_1.png',
      },
      {
        'name': 'Lê Thị Bình',
        'phone': '091 987 6543',
        'done': false,
        'img': 'assets/images/Avatar Users2_5.png',
      },
      {
        'name': 'Trần Văn Cường',
        'phone': '098 555 1234',
        'done': false,
        'img': 'assets/images/Avatar Users2_8.png',
      },
      {
        'name': 'Phạm Minh Hoàng',
        'phone': '097 444 8888',
        'done': true,
        'img': 'assets/images/Avatar Users2_12.png',
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
    return Container(
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
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          StatusChip(isDone: isDone),
        ],
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
