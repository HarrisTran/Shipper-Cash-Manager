import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/Repositories/daily_transaction_repository.dart';
import '../data/DTO/daily_transaction_dto.dart';
import 'package:collection/collection.dart';

class DailyTransactionService {
  final DailyTransactionRepository _dailyTransactionRepository;

  DailyTransactionService({
    DailyTransactionRepository? dailyTransactionRepository,
  }) : _dailyTransactionRepository =
           dailyTransactionRepository ?? DailyTransactionRepository();

  Stream<List<DailyTransactionDto>> watchAll() {
    return _dailyTransactionRepository.watchAll();
  }

  Future<DailyTransactionDto?> getById(String id) async {
    return _dailyTransactionRepository.getById(id);
  }

  Future<String> add(DailyTransactionDto dto) async {
    return _dailyTransactionRepository.add(dto);
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    await _dailyTransactionRepository.update(id, data);
  }

  Future<void> delete(String id) async {
    await _dailyTransactionRepository.delete(id);
  }

  Future<QuerySnapshot<Object?>> getByShipperId(String shipperId) async {
    return _dailyTransactionRepository.getByShipperId(shipperId);
  }

  Stream<List<DailyTransactionDto>> watchByShipperIdAndTimeRange(
    String shipperId,
    Timestamp start,
    Timestamp end,
  ) {
    return _dailyTransactionRepository.watchByShipperIdAndTimeRange(
      shipperId,
      start,
      end,
    );
  }

  Future<List<DailyTransactionDto>> getByTimeRange({
    required DateTime from,
    required DateTime to,
  }) async {
    return _dailyTransactionRepository.getByTimeRange(from: from, to: to);
  }

  /// Get total amount of a specific day, reuse getByTimeRange
  Future<int> getDailyTotal({required DateTime date}) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
    final transactions = await getByTimeRange(from: startOfDay, to: endOfDay);
    return transactions.fold<int>(
      0,
      (previousValue, element) {
        if (element.isReceived) return previousValue + element.amount;
        if (element.isDeposit) return previousValue - element.amount;
        return previousValue;
      },
    );
  }

  Future<Map<String, List<DailyTransactionDto>>> getByTimeRangeGroupByShipper({
    required DateTime from,
    required DateTime to,
  }) async {
    final transactions = await getByTimeRange(from: from, to: to);
    final Map<String, List<DailyTransactionDto>> grouped = groupBy(
      transactions,
      (transaction) => transaction.shipperId,
    );

    return grouped;
  }
}
