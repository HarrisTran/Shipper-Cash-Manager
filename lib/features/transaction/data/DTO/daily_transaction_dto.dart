import 'package:cloud_firestore/cloud_firestore.dart';

class DailyTransactionDto {
  final String? id;
  final String shipperId;
  final Timestamp date;
  final int totalAmount;
  final int totalFree;
  final bool feeConfirmed;
  final bool bankConfirmed;
  final String note;

  DailyTransactionDto({
    this.id,
    required this.shipperId,
    required this.date,
    required this.totalAmount,
    required this.totalFree,
    required this.feeConfirmed,
    required this.bankConfirmed,
    required this.note,
  });

  factory DailyTransactionDto.fromMap(Map<String, dynamic> map, {String? id}) {
    return DailyTransactionDto(
      id: id,
      shipperId: map['shipperId'] as String,
      date: map['date'] as Timestamp,
      totalAmount: map['totalAmount'] as int,
      totalFree: map['totalFree'] as int,
      feeConfirmed: map['feeConfirmed'] as bool,
      bankConfirmed: map['bankConfirmed'] as bool,
      note: map['note'] as String,
    );
  }

  factory DailyTransactionDto.fromFirestore(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return DailyTransactionDto(
      id: snapshot.id,
      shipperId: data['shipperId'] as String,
      date: data['date'] as Timestamp,
      totalAmount: data['totalAmount'] as int,
      totalFree: data['totalFree'] as int,
      feeConfirmed: data['feeConfirmed'] as bool,
      bankConfirmed: data['bankConfirmed'] as bool,
      note: data['note'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'shipperId': shipperId,
      'date': date,
      'totalAmount': totalAmount,
      'totalFree': totalFree,
      'feeConfirmed': feeConfirmed,
      'bankConfirmed': bankConfirmed,
      'note': note,
    };
  }

  DailyTransactionDto copyWith({
    String? id,
    String? shipperId,
    Timestamp? date,
    int? totalAmount,
    int? totalFree,
    bool? feeConfirmed,
    bool? bankConfirmed,
    String? note,
  }) {
    return DailyTransactionDto(
      id: id ?? this.id,
      shipperId: shipperId ?? this.shipperId,
      date: date ?? this.date,
      totalAmount: totalAmount ?? this.totalAmount,
      totalFree: totalFree ?? this.totalFree,
      feeConfirmed: feeConfirmed ?? this.feeConfirmed,
      bankConfirmed: bankConfirmed ?? this.bankConfirmed,
      note: note ?? this.note,
    );
  }

  @override
  String toString() {
    return 'DailyTransactionDto(id: $id, shipperId: $shipperId, date: $date, totalAmount: $totalAmount, totalFree: $totalFree, feeConfirmed: $feeConfirmed, bankConfirmed: $bankConfirmed, note: $note)';
  }
}
