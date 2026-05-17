import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tintin_money/features/transaction/data/DTO/daily_transaction_dto.dart';

class DailyTransactionRepository {
  static const String _collection = 'daily_transactions';

  final FirebaseFirestore _firestore;

  DailyTransactionRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _collectionRef => _firestore.collection(_collection);

  Stream<List<DailyTransactionDto>> watchAll() {
    return _collectionRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => DailyTransactionDto.fromFirestore(doc))
          .toList();
    });
  }

  // Watch by date
  Stream<List<DailyTransactionDto>> watchByDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    final start = Timestamp.fromDate(startOfDay);
    final end = Timestamp.fromDate(endOfDay);
    return _collectionRef
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: end)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => DailyTransactionDto.fromFirestore(doc))
              .toList();
        });
  }

  Future<DailyTransactionDto?> getById(String id) async {
    final snapshot = await _collectionRef.doc(id).get();
    if (!snapshot.exists) return null;
    return DailyTransactionDto.fromFirestore(snapshot);
  }

  Future<String> add(DailyTransactionDto dto) async {
    final docRef = await _collectionRef.add(dto.toMap());
    return docRef.id;
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    await _collectionRef.doc(id).update(data);
  }

  Future<void> delete(String id) async {
    await _collectionRef.doc(id).delete();
  }

  Future<QuerySnapshot<Object?>> getByShipperId(String shipperId) async {
    return _collectionRef.where('shipperId', isEqualTo: shipperId).get();
  }

  // Get list of shipper from timestamp A to timestamp B
  Future<QuerySnapshot<Object?>> getByShipperIdAndTimeRange(
    String shipperId,
    Timestamp start,
    Timestamp end,
  ) async {
    // Avoid missing composite index (shipperId, date) error
    return _collectionRef.where('shipperId', isEqualTo: shipperId).get();
  }

  // Watch list of transactions by shipperId, filtered by time range
  Stream<List<DailyTransactionDto>> watchByShipperIdAndTimeRange(
    String shipperId,
    Timestamp start,
    Timestamp end,
  ) {
    return _collectionRef
        .where('shipperId', isEqualTo: shipperId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => DailyTransactionDto.fromFirestore(doc))
              .where(
                (t) =>
                    t.date.compareTo(start) >= 0 && t.date.compareTo(end) <= 0,
              )
              .toList();
        });
  }

  Future<List<DailyTransactionDto>> getByTimeRange({
    required DateTime from,
    required DateTime to,
  }) async {
    final startOfDay = DateTime(from.year, from.month, from.day);
    final endOfDay = DateTime(to.year, to.month, to.day, 23, 59, 59);
    final start = Timestamp.fromDate(startOfDay);
    final end = Timestamp.fromDate(endOfDay);
    return _collectionRef
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: end)
        .get()
        .then((snapshot) {
          return snapshot.docs
              .map((doc) => DailyTransactionDto.fromFirestore(doc))
              .toList();
        });
  }
}
