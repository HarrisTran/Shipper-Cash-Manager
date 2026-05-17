import 'package:rxdart/rxdart.dart';
import 'package:tintin_money/features/shipper/data/DTO/shipper_data_dto.dart';
import 'package:tintin_money/features/shipper/data/DTO/shipper_profile_dto.dart';
import 'package:tintin_money/features/shipper/data/Repositories/shipper_profile_repository.dart';
import 'package:tintin_money/features/transaction/data/DTO/daily_transaction_dto.dart';
import 'package:tintin_money/features/transaction/data/Repositories/daily_transaction_repository.dart';
import 'package:tintin_money/features/transaction/data/enums/transaction_status.dart';

class ShipperDataService {
  final ShipperProfileRepository _shipperProfileRepository;
  final DailyTransactionRepository _dailyTransactionRepository;

  ShipperDataService(
    this._shipperProfileRepository,
    this._dailyTransactionRepository,
  );

  Stream<List<ShipperDataDto>> watchShippersData({DateTime? date}) {
    final today = date ?? DateTime.now();
    return Rx.combineLatest2(
      _shipperProfileRepository.watchAll(),
      _dailyTransactionRepository.watchByDate(today),
      _mergeFunc,
    );
  }

  Stream<({int doneCount, int totalCount})> watchShipperStats({
    DateTime? date,
  }) {
    return watchShippersData(date: date).map((shippers) {
      int doneCount = 0;
      int totalCount = shippers.length;
      for (final shipper in shippers) {
        if (shipper.transactionStatus == TransactionStatus.done) {
          doneCount++;
        }
      }
      return (doneCount: doneCount, totalCount: totalCount);
    });
  }

  // get total sum of transactions by date
  Stream<double> watchDailyTotal({DateTime? date}) {
    final today = date ?? DateTime.now();
    return _dailyTransactionRepository
        .watchByDate(today)
        .map(
          (transactions) => transactions.fold(
            0,
            (sum, transaction) => sum + transaction.totalAmount,
          ),
        );
  }

  List<ShipperDataDto> _mergeFunc(
    List<ShipperProfileDto> profiles,
    List<DailyTransactionDto> transactions,
  ) {
    final transactionMap = <String, List<DailyTransactionDto>>{};
    for (final transaction in transactions) {
      transactionMap
          .putIfAbsent(transaction.shipperId, () => [])
          .add(transaction);
    }
    return profiles.map((profile) {
      final lstTransaction = transactionMap[profile.id] ?? [];
      return ShipperDataDto(
        id: profile.id,
        name: profile.name,
        phone: profile.phone,
        avatar: profile.avatar,
        todayTransactions: lstTransaction,
        transactionStatus: _resolveStatus(lstTransaction),
      );
    }).toList();
  }

  TransactionStatus _resolveStatus(List<DailyTransactionDto> transactions) {
    if (transactions.isEmpty) return TransactionStatus.wait;
    bool hasBankError = transactions.any((t) => t.bankConfirmed == false);
    bool hasFeeError = transactions.any((t) => t.feeConfirmed == false);
    if (hasBankError && hasFeeError) {
      return TransactionStatus.wait;
    }

    if (!hasBankError && !hasFeeError) {
      return TransactionStatus.done;
    }
    if (hasBankError) {
      return TransactionStatus.bankPending;
    }

    return TransactionStatus.freePending;
  }
}
