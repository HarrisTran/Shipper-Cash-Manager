import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tintin_money/features/transaction/data/DTO/daily_transaction_dto.dart';
import 'package:tintin_money/features/transaction/services/daily_transaction_service.dart';
import 'package:tintin_money/service_locator.dart';

class EditTransactionPage extends StatefulWidget {
  final DailyTransactionDto transaction;

  const EditTransactionPage({super.key, required this.transaction});

  @override
  State<EditTransactionPage> createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  late bool _isFeeSent;
  late TextEditingController _noteController;
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _isFeeSent = widget.transaction.feeConfirmed;
    _noteController = TextEditingController(text: widget.transaction.note);
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    _amountController = TextEditingController(
      text: formatter.format(widget.transaction.totalAmount),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldBgColor = const Color(0xFFFCF8FA);
    final secondaryColor = const Color(0xFF006C4A);
    final outlineVariant = const Color(0xFFC6C6CD);
    final onSurfaceVariant = const Color(0xFF45464D);
    final surfaceContainerLowest = const Color(0xFFFFFFFF);
    final formatter = NumberFormat('#,###', 'vi_VN');

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
          'Chỉnh sửa giao dịch',
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
                TextField(
                  controller: _amountController,
                  enabled: false,
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: outlineVariant),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: outlineVariant),
                    ),
                  ),
                ),
              ],
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
                            '(${formatter.format(widget.transaction.totalFree)}đ)',
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
            const SizedBox(height: 32),

            // Confirm Button
            ElevatedButton(
              onPressed: () async {
                if (widget.transaction.id == null) return;

                final updateData = {
                  'feeConfirmed': _isFeeSent,
                  'note': _noteController.text.trim(),
                };

                await serviceLocator<DailyTransactionService>().update(
                  widget.transaction.id!,
                  updateData,
                );

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.edit, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'THAY ĐỔI',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Delete Button
            ElevatedButton(
              onPressed: () async {
                if (widget.transaction.id == null) return;

                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'Xác nhận xoá',
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    ),
                    content: Text(
                      'Bạn có chắc chắn muốn xoá giao dịch này?',
                      style: GoogleFonts.inter(),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(
                          'Hủy',
                          style: GoogleFonts.inter(color: Colors.grey),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(
                          'Xoá',
                          style: GoogleFonts.inter(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await serviceLocator<DailyTransactionService>().delete(
                    widget.transaction.id!,
                  );

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.delete_outline, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'XOÁ GIAO DỊCH',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
