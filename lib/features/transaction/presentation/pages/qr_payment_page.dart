import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class QrPaymentPage extends StatefulWidget {
  final String shipperName;
  final int totalAmount;

  const QrPaymentPage({
    super.key,
    required this.shipperName,
    required this.totalAmount,
  });

  @override
  State<QrPaymentPage> createState() => _QrPaymentPageState();
}

class _QrPaymentPageState extends State<QrPaymentPage> {
  bool _isFeeSent = false;
  final TextEditingController _noteController = TextEditingController();
  final _currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldBgColor = const Color(0xFFFCF8FA);
    final secondaryColor = const Color(0xFF006C4A);
    final outlineVariant = const Color(0xFFC6C6CD);
    final onSurfaceVariant = const Color(0xFF45464D);
    final surfaceContainerLowest = const Color(0xFFFFFFFF);
    final onPrimaryContainer = const Color(0xFF7C839B);

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Chuyển khoản cho ${widget.shipperName}',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade100, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            // Transaction Detail Section
            Column(
              children: [
                Text(
                  'TỔNG THANH TOÁN',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.05 * 14,
                    color: onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _currencyFormat.format(widget.totalAmount),
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.02 * 32,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // QR Code Container
            Container(
              padding: const EdgeInsets.all(32),
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
              child: Center(
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDwWo4cNkdId0Rn8q5OQJxKpysUuH_7VmI0gT6A7cL2zbv4jHFM-es5JP3gpRgLJBCCrEJ76IZB3c9gKcxWtJ1NVJZrFnq4r_oRiYH7jnOElNaivLQlwU5wUNq1iLL_Cagg35vPvlbdIQHTiE_r7T7yPCKd-I_xM6T5Oz1FxLXfxQfuH8MVAIjrKs5gc3w2XlsfyHz4QDSPJvBj4xB3bUceXEm-_Q3u7GFVRNeCYkSEETrEj9zxQ1iMXJt12XWanvn_w-VQmZ-vv0ZA',
                  width: 256,
                  height: 256,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Bank Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: outlineVariant),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ngân hàng',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: onSurfaceVariant,
                        ),
                      ),
                      Text(
                        'Vietcombank',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, color: Color(0xFFF1F5F9)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Số tài khoản',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: onSurfaceVariant,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '1023948576',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                const ClipboardData(text: '1023948576'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Đã sao chép số tài khoản'),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.content_copy,
                              color: onPrimaryContainer,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, color: Color(0xFFF1F5F9)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Người thụ hưởng',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: onSurfaceVariant,
                        ),
                      ),
                      Text(
                        'NGUYEN VAN A',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action section
            Column(
              children: [
                Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F3F5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: outlineVariant),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Đã gửi phí',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(5,000đ)',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: _isFeeSent,
                        onChanged: (val) {
                          setState(() {
                            _isFeeSent = val;
                          });
                        },
                        activeThumbColor: Colors.white,
                        activeTrackColor: secondaryColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    hintText: 'Nhập ghi chú (nếu có)',
                    hintStyle: GoogleFonts.inter(color: onSurfaceVariant),
                    filled: true,
                    fillColor: surfaceContainerLowest,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: outlineVariant),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: outlineVariant),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: secondaryColor, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Confirm Button
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                ); // Optional behavior, back to previous or dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 72),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    'XÁC NHẬN ĐÃ CHUYỂN',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Notice text
            Text(
              'Vui lòng chỉ xác nhận sau khi bạn đã\nthực hiện chuyển khoản thành công\ntrong ứng dụng ngân hàng.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 16, color: onSurfaceVariant),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
