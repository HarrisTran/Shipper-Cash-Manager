import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tintin_money/core/utils/currency_formatter.dart';
import 'package:tintin_money/core/utils/date_util.dart';
import 'package:tintin_money/features/shipper/services/shipper_data_service.dart';
import 'package:tintin_money/service_locator.dart';
import 'package:tintin_money/core/theme/app_colors.dart';
import 'package:tintin_money/features/transaction/services/daily_transaction_service.dart';
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
              'Tổng kết ngày ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
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
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    final service = serviceLocator<ShipperDataService>();

    final cashSummaryStream = Rx.combineLatest2(
      service.watchDailyTotal(date: today),
      service.watchDailyTotal(date: yesterday),
      (double today, double yesterday) {
        return {
          'today': today,
          'yesterday': yesterday,
          'diffPercent': yesterday != 0
              ? (today - yesterday) / yesterday * 100
              : 0,
        };
      },
    );

    return StreamBuilder(
      stream: cashSummaryStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        final data = snapshot.data!;
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
            children: <Widget>[
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
                CurrencyFormatter.format(data['today']!),
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
                  Icon(
                    data['diffPercent']! > 0
                        ? Icons.trending_up
                        : Icons.trending_down,
                    color: data['diffPercent']! > 0
                        ? AppColors.trendingUp
                        : AppColors.trendingDown,
                    size: 20,
                  ),
                  Text(
                    "${data['diffPercent']!.toStringAsFixed(2)}% so với hôm qua",
                    style: TextStyle(
                      color: data['diffPercent']! > 0
                          ? AppColors.trendingUp
                          : AppColors.trendingDown,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _shippingSummary() {
    final statsStream = serviceLocator<ShipperDataService>()
        .watchShipperStats();

    return StreamBuilder<({int doneCount, int totalCount})>(
      stream: statsStream,
      builder: (context, snapshot) {
        final completed = snapshot.data?.doneCount ?? 0;
        final total = snapshot.data?.totalCount ?? 0;
        final double progress = total > 0 ? completed / total : 0.0;

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
                  const Icon(
                    Icons.local_shipping,
                    color: Colors.black,
                    size: 20,
                  ),
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
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$completed',
                          style: GoogleFonts.inter(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '/$total',
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
                        '${(progress * 100).toStringAsFixed(0)}%',
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
      },
    );
  }

  Widget _shortHistory() {
    final service = serviceLocator<DailyTransactionService>();

    final oneDayAgo = DateTime.now().subtract(const Duration(days: 1));
    final twoDayAgo = DateTime.now().subtract(const Duration(days: 2));
    final threeDayAgo = DateTime.now().subtract(const Duration(days: 3));

    return FutureBuilder<List<int>>(
      future: Future.wait([
        service.getDailyTotal(date: oneDayAgo),
        service.getDailyTotal(date: twoDayAgo),
        service.getDailyTotal(date: threeDayAgo),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(24.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Đã xảy ra lỗi'));
        }

        final amounts = snapshot.data ?? [0, 0, 0];
        final histories = <Map<String, String>>[];

        void addIfHasData(DateTime date, int amount) {
          if (amount > 0) {
            histories.add({
              "date": DateUtil.format(date),
              "day": DateUtil.getWeekdayVietnamese(date),
              "amount": CurrencyFormatter.format(amount),
            });
          }
        }

        addIfHasData(oneDayAgo, amounts[0]);
        addIfHasData(twoDayAgo, amounts[1]);
        addIfHasData(threeDayAgo, amounts[2]);

        if (histories.isEmpty) {
          return const SizedBox.shrink();
        }

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
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFE7E7EC),
                    ),
                ],
              );
            }),
          ),
        );
      },
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
