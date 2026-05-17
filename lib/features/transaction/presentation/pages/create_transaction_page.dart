import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tintin_money/core/constants/app_constants.dart';
import 'package:tintin_money/core/utils/currency_formatter.dart';
import 'package:tintin_money/features/shipper/data/DTO/shipper_profile_dto.dart';
import 'package:tintin_money/features/shipper/services/shipper_profile_service.dart';
import 'package:tintin_money/features/transaction/data/DTO/daily_transaction_dto.dart';
import 'package:tintin_money/features/transaction/services/daily_transaction_service.dart';
import 'package:tintin_money/service_locator.dart';

class CreateTransactionPage extends StatefulWidget {
  final String shipperId;
  final DateTime dateCreate;

  const CreateTransactionPage({
    super.key,
    required this.shipperId,
    required this.dateCreate,
  });

  @override
  State<CreateTransactionPage> createState() => _CreateTransactionPageState();
}

class _CreateTransactionPageState extends State<CreateTransactionPage> {
  bool _isFeeSent = false;
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  late Future<ShipperProfileDto?> _shipperFuture;

  @override
  void initState() {
    super.initState();
    _shipperFuture = serviceLocator<ShipperProfileService>().getShipperById(
      widget.shipperId,
    );
    _amountController.addListener(() {
      setState(() {});
    });
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

    return FutureBuilder<ShipperProfileDto?>(
      future: _shipperFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final shipper = snapshot.data;
        if (shipper == null) {
          return const Scaffold(
            body: Center(child: Text('Không tìm thấy thông tin shipper')),
          );
        }

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
              'Chuyển khoản cho ${shipper.name}',
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
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyInputFormatter(),
                      ],
                      decoration: InputDecoration(
                        hintText: 'Nhập số tiền',
                        hintStyle: GoogleFonts.inter(color: onSurfaceVariant),
                        filled: true,
                        fillColor: Colors.white,
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
                          borderSide: BorderSide(
                            color: secondaryColor,
                            width: 2,
                          ),
                        ),
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
                    child: QrImageView(
                      data: shipper.qrString,
                      size: 256,
                      version: QrVersions.auto,
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
                          Expanded(
                            child: Text(
                              shipper.bankName,
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
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
                                '---',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
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
                          Expanded(
                            child: Text(
                              shipper.name.toUpperCase(),
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
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
                              Builder(
                                builder: (context) {
                                  final amountStr = _amountController.text
                                      .replaceAll(RegExp(r'[^0-9]'), '');
                                  final amount = int.tryParse(amountStr) ?? 0;
                                  final fee =
                                      (amount * AppConstants.feeExchangeRatio)
                                          .toInt();
                                  final feeFormatted = NumberFormat(
                                    '#,###',
                                    'vi_VN',
                                  ).format(fee);
                                  return Text(
                                    '(${feeFormatted}đ)',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      color: onSurfaceVariant,
                                    ),
                                  );
                                },
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
                          borderSide: BorderSide(
                            color: secondaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Confirm Button
                ElevatedButton(
                  onPressed: () async {
                    final amountStr = _amountController.text.replaceAll(
                      RegExp(r'[^0-9]'),
                      '',
                    );
                    if (amountStr.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vui lòng nhập số tiền')),
                      );
                      return;
                    }

                    final amount = int.parse(amountStr);
                    final fee =
                        int.parse(amountStr) * AppConstants.feeExchangeRatio;

                    final dto = DailyTransactionDto(
                      shipperId: widget.shipperId,
                      shipperName: shipper.name,
                      date: Timestamp.fromDate(widget.dateCreate),
                      totalAmount: amount,
                      totalFree: int.parse(fee.toStringAsFixed(0)),
                      bankConfirmed: true,
                      feeConfirmed: _isFeeSent,
                      note: _noteController.text.trim(),
                    );

                    await serviceLocator<DailyTransactionService>().add(dto);

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
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
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    double value = double.parse(
      newValue.text.replaceAll(RegExp(r'[^0-9]'), ''),
    );
    String newText = CurrencyFormatter.format(value);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
