import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tintin_money/features/transaction/presentation/pages/daily_transaction_history.dart';
import 'package:google_fonts/google_fonts.dart';

import 'create_transaction_page.dart';

class CashCountingPage extends StatefulWidget {
  final String shipperId;
  final String shipperName;
  final String shipperPhone;
  final String shipperImageUrl;

  const CashCountingPage({
    super.key,
    required this.shipperId,
    required this.shipperName,
    required this.shipperPhone,
    required this.shipperImageUrl,
  });

  @override
  State<CashCountingPage> createState() => _CashCountingPageState();
}

class _CashCountingPageState extends State<CashCountingPage> {
  // shipper profile dto

  @override
  Widget build(BuildContext context) {
    final Color scaffoldBgColor = const Color(0xFFFCF8FA);

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'SCM Manager',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        // No settings or avatar icon as per request
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shipper Context Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF82F5C1),
                                  width: 2,
                                ),
                              ),
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: widget.shipperImageUrl,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    width: 56,
                                    height: 56,
                                    color: Colors.grey.shade200,
                                    child: const Center(
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        width: 56,
                                        height: 56,
                                        color: Colors.grey.shade200,
                                        child: const Icon(
                                          Icons.person,
                                          color: Colors.grey,
                                        ),
                                      ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -4,
                              right: -4,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF006C4A),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_circle,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ĐANG GIAO DỊCH VỚI',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  color: const Color(0xFF45464D),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.shipperName,
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.local_shipping,
                                    size: 14,
                                    color: Color(0xFF00714E),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Shipper ${widget.shipperPhone}', // Dùng số đt làm mã shipper tạm
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF00714E),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- Lịch sử Giao dịch Shipper ---

                  // Header Section
                  Text(
                    'Lịch sử Giao dịch Shipper',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      color: const Color(0xFF131B2E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Theo dõi chi tiết các khoản nộp tiền và phí chuyển khoản của shipper.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF45464D),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Summary section
                  DailyTransactionHistory(shipperId: widget.shipperId),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Fixed Bottom Action
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  scaffoldBgColor,
                  scaffoldBgColor.withValues(alpha: 0.0),
                ],
              ),
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateTransactionPage(
                      shipperId: widget.shipperId,
                      dateCreate: DateTime.now(),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'TẠO GIAO DỊCH MỚI',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.qr_code_2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
