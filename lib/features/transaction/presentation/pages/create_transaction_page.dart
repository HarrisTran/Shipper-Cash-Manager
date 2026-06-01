import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tintin_money/core/utils/currency_formatter.dart';
import 'package:tintin_money/features/shipper/data/DTO/shipper_profile_dto.dart';
import 'package:tintin_money/features/shipper/services/shipper_profile_service.dart';
import 'package:tintin_money/features/transaction/data/DTO/daily_transaction_dto.dart';
import 'package:tintin_money/features/transaction/services/daily_transaction_service.dart';
import 'package:tintin_money/service_locator.dart';

class CreateTransactionPage extends StatefulWidget {
  final String shipperId;
  final DateTime dateCreate;
  final bool isFeeTransaction;

  const CreateTransactionPage({
    super.key,
    required this.shipperId,
    required this.dateCreate,
    required this.isFeeTransaction,
  });

  @override
  State<CreateTransactionPage> createState() => _CreateTransactionPageState();
}

class _CreateTransactionPageState extends State<CreateTransactionPage> {
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
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _createTransaction({
    required bool isFee,
    required bool isDeposit,
    required bool isReceived,
    required String shipperName,
  }) async {
    final amountStr = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (amountStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập số tiền')),
      );
      return;
    }

    final amount = int.parse(amountStr);

    final dto = DailyTransactionDto(
      shipperId: widget.shipperId,
      shipperName: shipperName,
      date: Timestamp.fromDate(widget.dateCreate),
      amount: amount,
      isFee: isFee,
      isDeposit: isDeposit,
      isReceived: isReceived,
    );

    await serviceLocator<DailyTransactionService>().add(dto);

    if (context.mounted) {
      Navigator.pop(context);
    }
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

                if (!widget.isFeeTransaction) ...[
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
                ],
                // Confirm Button(s)
                if (widget.isFeeTransaction)
                  ElevatedButton(
                    onPressed: () => _createTransaction(isFee: true, isDeposit: false, isReceived: false, shipperName: shipper.name),
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
                          'XÁC NHẬN TẠO TIỀN PHÍ',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _createTransaction(isFee: false, isDeposit: false, isReceived: true, shipperName: shipper.name),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 72),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 4,
                          ),
                          child: Text(
                            'TẠO TIỀN NHẬN',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _createTransaction(isFee: false, isDeposit: true, isReceived: false, shipperName: shipper.name),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 72),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 4,
                          ),
                          child: Text(
                            'TẠO TIỀN GỬI',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
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
