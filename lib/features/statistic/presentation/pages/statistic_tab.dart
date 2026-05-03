import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tintin_money/core/theme/app_colors.dart';
import 'package:tintin_money/features/statistic/presentation/pages/detail_transaction_page.dart';

class StatisticTab extends StatelessWidget {
  const StatisticTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tổng kết ngày 25/05/2024',
              style: GoogleFonts.inter(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            _cashSummary(),
            const SizedBox(height: 12),
            _shippingSummary(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lịch sử giao dịch',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DetailTransactionPage(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        'Xem tất cả',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF006C4A),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: Color(0xFF006C4A),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            _shortHistory(),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, color: Colors.black, size: 20),
                Text(
                  'Tự động làm mới vào 00:00 ngày hôm sau',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _cashSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.money, color: Colors.black, size: 20),
              const SizedBox(width: 6),
              Text(
                'Tổng tiền mặt'.toUpperCase(),
                style: GoogleFonts.inter(
                  color: const Color(0xFF45464D),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '10,000,000đ',
            style: GoogleFonts.inter(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.trending_up, color: AppColors.trendingUp, size: 20),
              Text(
                "+12% so với hôm qua",
                style: TextStyle(
                  color: AppColors.trendingUp,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _shippingSummary() {
    const int completed = 12;
    const int total = 15;
    final double progress = completed / total;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_shipping, color: Colors.black, size: 20),
              const SizedBox(width: 6),
              Text(
                'Shipper đã xong'.toUpperCase(),
                style: GoogleFonts.inter(
                  color: const Color(0xFF45464D),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "$completed",
                      style: GoogleFonts.inter(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: "/$total",
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 10,
                      color: AppColors.trendingUp,
                      backgroundColor: Colors.grey.shade300,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Text(
                    "${(progress * 100).toStringAsFixed(0)}%",
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.trendingUp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _shortHistory() {
    final histories = [
      {"date": "23/05/2024", "day": "Thứ Năm", "amount": "38,500,000đ"},
      {"date": "22/05/2024", "day": "Thứ Tư", "amount": "42,150,000đ"},
      {"date": "21/05/2024", "day": "Thứ Ba", "amount": "31,000,000đ"},
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFD9D9DF)),
      ),
      child: Column(
        children: List.generate(histories.length, (index) {
          final item = histories[index];

          return Column(
            children: [
              _dayTransactionItem(
                date: item["date"]!,
                day: item["day"]!,
                amount: item["amount"]!,
              ),
              if (index != histories.length - 1)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: const Color(0xFFE7E7EC),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _dayTransactionItem({
    required String date,
    required String day,
    required String amount,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.calendar_month,
                      color: Colors.black,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF0A0A0B),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      day,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF8E8F94),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.inter(
              color: const Color(0xFFFF4D4F),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
