import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tintin_money/features/statistic/presentation/pages/statistic_tab.dart';
import 'package:tintin_money/features/shipper/services/shipper_data_service.dart';
import 'package:tintin_money/service_locator.dart';
import '../../../shipper/presentation/pages/shipper_list_page.dart';
import '../../../shipper/presentation/pages/shipper_management_tab.dart';
import '../../../shipper/presentation/widgets/add_shipper_dialog.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  bool _isBottomBarVisible = true;
  int doneCount = 0;
  int totalCount = 0;

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    serviceLocator<ShipperDataService>().watchShipperStats().listen((stats) {
      setState(() {
        doneCount = stats.doneCount;
        totalCount = stats.totalCount;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage(
                'assets/images/icon_app/ic_launcher.png',
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'SCM Manager',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.reverse) {
            if (_isBottomBarVisible) {
              setState(() => _isBottomBarVisible = false);
            }
          } else if (notification.direction == ScrollDirection.forward) {
            if (!_isBottomBarVisible) {
              setState(() => _isBottomBarVisible = true);
            }
          }
          return false;
        },
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchBarWidget(
                    onSearchBarChanged: (query) {
                      setState(() => _searchQuery = query);
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Danh sách Shipper',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'HÔM NAY',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ShipperListContent(searchQuery: _searchQuery),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const StatisticTab(),
            const ShipperManagementTab(),
          ],
        ),
      ),
      bottomNavigationBar: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        offset: _isBottomBarVisible ? Offset.zero : const Offset(0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: _buildNavItem(
                      index: 0,
                      icon: Icons.receipt_long_outlined,
                      selectedIcon: Icons.receipt_long,
                      label: 'GIAO DỊCH',
                    ),
                  ),
                  Expanded(
                    child: _buildNavItem(
                      index: 1,
                      icon: Icons.bar_chart_outlined,
                      selectedIcon: Icons.bar_chart,
                      label: 'THỐNG KÊ',
                    ),
                  ),
                  Expanded(
                    child: _buildNavItem(
                      index: 2,
                      icon: Icons.local_shipping_outlined,
                      selectedIcon: Icons.local_shipping,
                      label: 'SHIPPER',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _selectedIndex == 2
          ? AnimatedScale(
              scale: _isBottomBarVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: FloatingActionButton(
                backgroundColor: Colors.black,
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const AddShipperDialog(),
                  );
                },
                child: const Icon(Icons.add, color: Colors.white),
              ),
            )
          : null,
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
  }) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? Colors.white : const Color(0xFF64748B),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key, required this.onSearchBarChanged});

  final ValueChanged<String> onSearchBarChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Tìm tên shipper...',
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      onChanged: onSearchBarChanged,
    );
  }
}
