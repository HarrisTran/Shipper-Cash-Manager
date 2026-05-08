import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'qr_payment_page.dart';

class CashCountingPage extends StatefulWidget {
  final String shipperName;
  final String shipperPhone;
  final String shipperImageUrl;

  const CashCountingPage({
    super.key,
    required this.shipperName,
    required this.shipperPhone,
    required this.shipperImageUrl,
  });

  @override
  State<CashCountingPage> createState() => _CashCountingPageState();
}

class _CashCountingPageState extends State<CashCountingPage> {
  final Map<int, int> _quantities = {
    500000: 0,
    200000: 0,
    100000: 0,
    50000: 0,
    20000: 0,
    10000: 0,
    5000: 0,
    2000: 0,
    1000: 0,
  };

  final Map<int, String> _imageAsset = {
    500000: 'assets/images/cash/cash_500k.png',
    200000: 'assets/images/cash/cash_200k.png',
    100000: 'assets/images/cash/cash_100k.png',
    50000: 'assets/images/cash/cash_50k.png',
    20000: 'assets/images/cash/cash_20k.png',
    10000: 'assets/images/cash/cash_10k.png',
    5000: 'assets/images/cash/cash_5k.png',
    2000: 'assets/images/cash/cash_2k.png',
    1000: 'assets/images/cash/cash_1k.png',
  };

  final _currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  int get _totalAmount {
    int total = 0;
    _quantities.forEach((denomination, quantity) {
      total += denomination * quantity;
    });
    return total;
  }

  void _resetAll() {
    setState(() {
      for (final key in _quantities.keys) {
        _quantities[key] = 0;
      }
    });
  }

  Future<void> _showQuantityDialog(int denomination) async {
    int currentQty = _quantities[denomination] ?? 0;
    final TextEditingController controller = TextEditingController(
      text: currentQty > 0 ? currentQty.toString() : '',
    );

    final result = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Nhập số lượng tờ',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Nhập số lượng',
              suffixText: 'tờ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                final val = int.tryParse(controller.text) ?? 0;
                Navigator.pop(context, val);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF131B2E),
                foregroundColor: Colors.white,
              ),
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        _quantities[denomination] = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF131B2E);
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
                                child: Image.asset(
                                  widget.shipperImageUrl,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        width: 56,
                                        height: 56,
                                        color: Colors.grey.shade200,
                                        child: const Icon(Icons.person),
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
                    'Theo dõi chi tiết các khoản nộp tiền và phí vận hành của shipper.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF45464D),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Summary Widget (Asymmetric Layout)
                  Row(
                    children: [
                      Expanded(
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
                                '12.500.000đ',
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
                      const SizedBox(width: 16),
                      Expanded(
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
                                '25.000đ',
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
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Transaction List
                  // Transaction Card 1 — cả hai đã xác nhận
                  _buildTransactionCard(
                    dateTime: '23/05/2024 • 14:30',
                    amount: '2.500.000đ',
                    fee: 'Phí: 5.000đ',
                    moneyConfirmed: true,
                    feeConfirmed: true,
                  ),
                  const SizedBox(height: 12),

                  // Transaction Card 2 — cả hai đang chờ
                  _buildTransactionCard(
                    dateTime: '23/05/2024 • 09:15',
                    amount: '1.800.000đ',
                    fee: 'Phí: 5.000đ',
                    moneyConfirmed: false,
                    feeConfirmed: false,
                  ),
                  const SizedBox(height: 12),

                  // Transaction Card 3 — tiền đã xác nhận, phí chờ
                  _buildTransactionCard(
                    dateTime: '22/05/2024 • 17:45',
                    amount: '4.200.000đ',
                    fee: 'Phí: 5.000đ',
                    moneyConfirmed: true,
                    feeConfirmed: false,
                  ),
                  const SizedBox(height: 12),

                  // Transaction Card 4 — cả hai đã xác nhận
                  _buildTransactionCard(
                    dateTime: '22/05/2024 • 11:20',
                    amount: '3.000.000đ',
                    fee: 'Phí: 5.000đ',
                    moneyConfirmed: true,
                    feeConfirmed: true,
                  ),
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
                    builder: (context) => QrPaymentPage(
                      shipperName: widget.shipperName,
                      totalAmount: _totalAmount,
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

  Widget _buildTransactionCard({
    required String dateTime,
    required String amount,
    required String fee,
    required bool moneyConfirmed,
    required bool feeConfirmed,
  }) {
    final Color confirmedBg = const Color(0xFF006C4A);
    final Color confirmedText = Colors.white;
    final Color pendingBg = Colors.white;
    final Color pendingBorder = const Color(0xFF006C4A);
    final Color pendingText = const Color(0xFF006C4A);

    Widget actionButton({required bool confirmed, required String label}) {
      return Expanded(
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: confirmed ? confirmedBg : pendingBg,
            borderRadius: BorderRadius.circular(10),
            border: confirmed
                ? null
                : Border.all(color: pendingBorder, width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                confirmed ? Icons.check_circle : Icons.pending,
                size: 18,
                color: confirmed ? confirmedText : pendingText,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: confirmed ? confirmedText : pendingText,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
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
                    dateTime,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF45464D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    amount,
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF131B2E),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAE7E9),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  fee,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF45464D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              actionButton(confirmed: moneyConfirmed, label: 'Đã chuyển tiền'),
              const SizedBox(width: 12),
              actionButton(confirmed: feeConfirmed, label: 'Đã gửi phí'),
            ],
          ),
        ],
      ),
    );
  }
}
