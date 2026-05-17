import 'package:tintin_money/features/transaction/data/DTO/daily_transaction_dto.dart';
import 'package:tintin_money/features/transaction/data/enums/transaction_status.dart';

class ShipperDataDto {
  final String id;
  final String name;
  final String phone;
  final String avatar;
  final TransactionStatus transactionStatus;
  final List<DailyTransactionDto> todayTransactions;

  const ShipperDataDto({
    required this.id,
    required this.name,
    required this.phone,
    required this.avatar,
    required this.transactionStatus,
    required this.todayTransactions,
  });
}
