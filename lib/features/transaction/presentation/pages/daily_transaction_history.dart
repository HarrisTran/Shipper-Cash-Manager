import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tintin_money/features/transaction/presentation/pages/edit_transaction_page.dart';
import 'package:tintin_money/service_locator.dart';
import 'package:tintin_money/features/transaction/services/daily_transaction_service.dart';
import 'package:tintin_money/features/transaction/data/DTO/daily_transaction_dto.dart';
import 'package:tintin_money/features/transaction/presentation/pages/create_transaction_page.dart';

class DailyTransactionHistory extends StatefulWidget {
  final String shipperId;

  const DailyTransactionHistory({super.key, required this.shipperId});

  @override
  State<DailyTransactionHistory> createState() =>
      _DailyTransactionHistoryState();
}

class _DailyTransactionHistoryState extends State<DailyTransactionHistory> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final service = serviceLocator<DailyTransactionService>();
    final now = DateTime.now();
    final startTimestamp = Timestamp.fromDate(
      DateTime(now.year, now.month, now.day),
    );
    final endTimestamp = Timestamp.fromDate(
      DateTime(now.year, now.month, now.day, 23, 59, 59),
    );
    final stream = service.watchByShipperIdAndTimeRange(
      widget.shipperId,
      startTimestamp,
      endTimestamp,
    );
    return StreamBuilder<List<DailyTransactionDto>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Đã xảy ra lỗi.'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final transactions = snapshot.data ?? [];

        double totalCash = 0;
        double totalFee = 0;
        for (var t in transactions) {
          if (t.isReceived) totalCash += t.amount;
          if (t.isDeposit) totalCash -= t.amount;
          if (t.isFee) totalFee += t.amount;
        }

        final formatter = NumberFormat('#,###', 'vi_VN');

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateTransactionPage(
                            shipperId: widget.shipperId,
                            dateCreate: DateTime.now(),
                            isFeeTransaction: false,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF131B2E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TỔNG TIỀN MẶT',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              color: const Color(0xFF7C839B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${formatter.format(totalCash)}đ',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateTransactionPage(
                            shipperId: widget.shipperId,
                            dateCreate: DateTime.now(),
                            isFeeTransaction: true,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF82F5C1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PHÍ TÍCH LŨY',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              color: const Color(0xFF00714E),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${formatter.format(totalFee)}đ',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF00714E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (transactions.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text('Không có giao dịch hôm nay.'),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final t = transactions[index];
                  return _buildTransactionCard(t);
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildTransactionCard(DailyTransactionDto t) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    final dateStr = DateFormat('dd/MM/yyyy • HH:mm').format(t.date.toDate());
    final amountStr = '${formatter.format(t.amount)}đ';

    String typeLabel = '';
    Color typeColor = Colors.grey;
    if (t.isFee) {
      typeLabel = 'Tiền phí';
      typeColor = const Color(0xFF00714E);
    } else if (t.isDeposit) {
      typeLabel = 'Tiền gửi';
      typeColor = Colors.orange;
    } else if (t.isReceived) {
      typeLabel = 'Tiền nhận';
      typeColor = Colors.blue;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditTransactionPage(transaction: t),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFC6C6CD)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateStr,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF45464D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      amountStr,
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF131B2E),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: typeColor.withOpacity(0.5)),
                  ),
                  child: Text(
                    typeLabel,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: typeColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
