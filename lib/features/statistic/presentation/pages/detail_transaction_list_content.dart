import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tintin_money/core/theme/app_colors.dart';
import 'package:tintin_money/core/utils/currency_formatter.dart';
import 'package:tintin_money/service_locator.dart';
import 'package:tintin_money/features/transaction/services/daily_transaction_service.dart';
import 'package:tintin_money/features/transaction/data/DTO/daily_transaction_dto.dart';
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

class _DetailTransactionListContentState
    extends State<DetailTransactionListContent> {
  final DailyTransactionService _transactionService =
      serviceLocator<DailyTransactionService>();

  static const int _pageSize = 10;

  List<DailyTransactionDto> _masterTransactions = [];
  List<DailyTransactionDto> _filteredTransactions = [];
  int _currentPage = 0;

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

      final transactions = await _transactionService.getByTimeRange(
        from: from,
        to: to,
      );

      // Sort by date descending (newest first)
      transactions.sort((a, b) => b.date.compareTo(a.date));

      _masterTransactions = transactions;
      _currentPage = 0;
      _applyLocalFilter();
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
      _currentPage = 0;
      if (widget.searchQuery.isEmpty) {
        _filteredTransactions = List.from(_masterTransactions);
      } else {
        final query = _toUnsignedString(widget.searchQuery);
        _filteredTransactions = _masterTransactions.where((tx) {
          final name = _toUnsignedString(tx.shipperName);
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

  int get _totalPages => (_filteredTransactions.length / _pageSize).ceil();

  List<DailyTransactionDto> get _currentPageItems {
    final start = _currentPage * _pageSize;
    final end = (start + _pageSize).clamp(0, _filteredTransactions.length);
    return _filteredTransactions.sublist(start, end);
  }

  String _resolveTransactionType(DailyTransactionDto tx) {
    if (tx.isFee) return 'Tiền phí';
    if (tx.isDeposit) return 'Tiền gửi';
    if (tx.isReceived) return 'Tiền nhận';
    return 'Không xác định';
  }

  Color _resolveTypeColor(DailyTransactionDto tx) {
    if (tx.isFee) return AppColors.success;
    if (tx.isDeposit) return const Color(0xFFE67E22);
    if (tx.isReceived) return const Color(0xFF3B82F6);
    return AppColors.textSecondary;
  }

  IconData _resolveTypeIcon(DailyTransactionDto tx) {
    if (tx.isFee) return Icons.receipt_long;
    if (tx.isDeposit) return Icons.arrow_upward;
    if (tx.isReceived) return Icons.arrow_downward;
    return Icons.help_outline;
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

    if (_filteredTransactions.isEmpty) {
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

    final pageItems = _currentPageItems;
    final startIndex = _currentPage * _pageSize;

    return Column(
      children: [
        // Transaction count header
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tổng: ${_filteredTransactions.length} giao dịch',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (_totalPages > 1)
                Text(
                  'Trang ${_currentPage + 1}/$_totalPages',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),

        // Transaction list
        ...pageItems.asMap().entries.map((entry) {
          final index = startIndex + entry.key;
          final tx = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _buildTransactionItem(tx, index + 1),
          );
        }),

        // Pagination controls
        if (_totalPages > 1)
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: _buildPaginationControls(),
          ),
      ],
    );
  }

  Widget _buildTransactionItem(DailyTransactionDto tx, int orderNumber) {
    final typeLabel = _resolveTransactionType(tx);
    final typeColor = _resolveTypeColor(tx);
    final typeIcon = _resolveTypeIcon(tx);
    final dateTime = tx.date.toDate();
    final timeStr = DateFormat('HH:mm - dd/MM/yyyy').format(dateTime);

    return ScmCard(
      useLargeRadius: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Type icon
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(typeIcon, color: typeColor, size: 22),
          ),
          const SizedBox(width: 12),

          // Name + type + time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.shipperName,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: typeColor.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        typeLabel,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: typeColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        timeStr,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Amount
          Text(
            CurrencyFormatter.format(tx.amount),
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous button
        _buildPageButton(
          icon: Icons.chevron_left,
          enabled: _currentPage > 0,
          onTap: () {
            setState(() {
              _currentPage--;
            });
          },
        ),
        const SizedBox(width: 8),

        // Page number buttons
        ..._buildPageNumbers(),

        const SizedBox(width: 8),

        // Next button
        _buildPageButton(
          icon: Icons.chevron_right,
          enabled: _currentPage < _totalPages - 1,
          onTap: () {
            setState(() {
              _currentPage++;
            });
          },
        ),
      ],
    );
  }

  List<Widget> _buildPageNumbers() {
    final List<Widget> buttons = [];
    final total = _totalPages;

    // Show max 5 page buttons with ellipsis
    List<int> pageNumbers = [];
    if (total <= 5) {
      pageNumbers = List.generate(total, (i) => i);
    } else {
      pageNumbers.add(0);
      if (_currentPage > 2) {
        pageNumbers.add(-1); // ellipsis
      }
      for (int i = _currentPage - 1; i <= _currentPage + 1; i++) {
        if (i > 0 && i < total - 1) {
          pageNumbers.add(i);
        }
      }
      if (_currentPage < total - 3) {
        pageNumbers.add(-1); // ellipsis
      }
      pageNumbers.add(total - 1);
    }

    for (final page in pageNumbers) {
      if (page == -1) {
        buttons.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              '…',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        );
      } else {
        final isActive = page == _currentPage;
        buttons.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                setState(() {
                  _currentPage = page;
                });
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: isActive
                      ? null
                      : Border.all(color: AppColors.outline),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${page + 1}',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }

    return buttons;
  }

  Widget _buildPageButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: enabled ? onTap : null,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: enabled ? AppColors.surface : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: enabled ? AppColors.outline : const Color(0xFFE2E8F0),
          ),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 20,
          color: enabled ? AppColors.textPrimary : const Color(0xFFCBD5E1),
        ),
      ),
    );
  }
}
