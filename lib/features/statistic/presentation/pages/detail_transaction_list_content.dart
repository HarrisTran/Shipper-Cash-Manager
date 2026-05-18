import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tintin_money/core/theme/app_colors.dart';
import 'package:tintin_money/core/utils/currency_formatter.dart';
import 'package:tintin_money/service_locator.dart';
import 'package:tintin_money/features/transaction/services/daily_transaction_service.dart';
import '../../../../core/widgets/scm_card.dart';

class DetailTransactionListContent extends StatefulWidget {
  final String fromDate;
  final String toDate;
  final String searchQuery;
  const DetailTransactionListContent({
    super.key,
    required this.fromDate,
    required this.toDate,
    required this.searchQuery,
  });

  @override
  State<DetailTransactionListContent> createState() =>
      _DetailTransactionListContentState();
}

/// Represents a shipper's aggregated transaction data for display.
class _ShipperTransactionSummary {
  final String shipperName;
  final int totalAmount;

  _ShipperTransactionSummary({
    required this.shipperName,
    required this.totalAmount,
  });
}

class _DetailTransactionListContentState
    extends State<DetailTransactionListContent> {
  final DailyTransactionService _transactionService =
      serviceLocator<DailyTransactionService>();

  List<_ShipperTransactionSummary> _masterSummaries = [];

  List<_ShipperTransactionSummary> _filteredSummaries = [];

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadFromDatabase();
  }

  @override
  void didUpdateWidget(covariant DetailTransactionListContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fromDate != widget.fromDate ||
        oldWidget.toDate != widget.toDate) {
      _loadFromDatabase();
    } else if (oldWidget.searchQuery != widget.searchQuery) {
      _applyLocalFilter();
    }
  }

  Future<void> _loadFromDatabase() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final from = _parseDate(widget.fromDate);
      final to = DateTime(
        _parseDate(widget.toDate).year,
        _parseDate(widget.toDate).month,
        _parseDate(widget.toDate).day,
        23,
        59,
        59,
        999,
      );

      final grouped = await _transactionService.getByTimeRangeGroupByShipper(
        from: from,
        to: to,
      );
      final List<_ShipperTransactionSummary> summaries = [];

      for (final entry in grouped.entries) {
        final totalAmount = entry.value.fold<int>(
          0,
          (sum, tx) => sum + tx.totalAmount,
        );
        summaries.add(
          _ShipperTransactionSummary(
            shipperName: entry.value.first.shipperName,
            totalAmount: totalAmount,
          ),
        );
      }

      summaries.sort((a, b) => b.totalAmount.compareTo(a.totalAmount));

      _masterSummaries = summaries;
      _applyLocalFilter(); // Áp dụng filter chuỗi ngay sau khi có dữ liệu mới
    } catch (e) {
      setState(() {
        _errorMessage = 'Đã xảy ra lỗi khi tải dữ liệu';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyLocalFilter() {
    setState(() {
      if (widget.searchQuery.isEmpty) {
        _filteredSummaries = List.from(_masterSummaries);
      } else {
        final query = _toUnsignedString(widget.searchQuery);
        _filteredSummaries = _masterSummaries.where((summary) {
          final name = _toUnsignedString(summary.shipperName);
          return name.contains(query);
        }).toList();
      }
    });
  }

  // to unsigned string
  String _toUnsignedString(String value) {
    var withSign =
        "àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐ";
    var noSign =
        "aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyydAAAAAAAAAAAAAAAAAEEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOOOUUUUUUUUUUUYYYYYD";
    String output = value;
    for (int i = 0; i < withSign.length; i++) {
      output = output.replaceAll(withSign[i], noSign[i]);
    }
    return output.toLowerCase();
  }

  /// Parses a date string in `dd/MM/yyyy` format to [DateTime].
  DateTime _parseDate(String dateStr) {
    final format = DateFormat('dd/MM/yyyy');
    return format.parse(dateStr);
  }

  /// Fetches transactions grouped by shipper and resolves shipper names.
  Future<List<_ShipperTransactionSummary>> _fetchGroupedTransactions() async {
    final from = _parseDate(widget.fromDate);
    final to = DateTime(
      _parseDate(widget.toDate).year,
      _parseDate(widget.toDate).month,
      _parseDate(widget.toDate).day,
      23,
      59,
      59,
      999,
    );

    final grouped = await _transactionService.getByTimeRangeGroupByShipper(
      from: from,
      to: to,
    );

    final List<_ShipperTransactionSummary> summaries = [];

    for (final entry in grouped.entries) {
      final transactions = entry.value;

      final totalAmount = transactions.fold<int>(
        0,
        (sum, tx) => sum + tx.totalAmount,
      );
      String shipperName = entry.value.first.shipperName;

      summaries.add(
        _ShipperTransactionSummary(
          shipperName: shipperName,
          totalAmount: totalAmount,
        ),
      );
    }

    // Sort by totalAmount descending
    summaries.sort((a, b) => b.totalAmount.compareTo(a.totalAmount));

    // Filter by searchQuery
    final filteredSummaries = summaries.where((summary) {
      return summary.shipperName.toLowerCase().contains(
        widget.searchQuery.toLowerCase(),
      );
    }).toList();

    return filteredSummaries;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Text(
            _errorMessage!,
            style: GoogleFonts.inter(color: Colors.red, fontSize: 14),
          ),
        ),
      );
    }

    if (_filteredSummaries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Text(
            'Không có giao dịch phù hợp',
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return Column(
      children: _filteredSummaries
          .map(
            (summary) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildTransactionCard(
                name: summary.shipperName,
                amount: CurrencyFormatter.format(summary.totalAmount),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildTransactionCard({required String name, required String amount}) {
    return ScmCard(
      useLargeRadius: true,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFDAE2FD), // primary-fixed
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFF131B2E),
                ), // on-primary-fixed
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: Colors.grey.shade100),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Tổng tiền',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                amount,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
