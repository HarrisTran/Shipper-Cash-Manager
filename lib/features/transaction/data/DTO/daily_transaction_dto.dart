import 'package:cloud_firestore/cloud_firestore.dart';

class DailyTransactionDto {
  final String? id;
  final String shipperId;
  final String shipperName;
  final Timestamp date;
  final int amount;
  final bool isFee;
  final bool isDeposit;
  final bool isReceived;

  DailyTransactionDto({
    this.id,
    required this.shipperId,
    required this.shipperName,
    required this.date,
    required this.amount,
    required this.isFee,
    required this.isDeposit,
    required this.isReceived,
  });

  factory DailyTransactionDto.fromMap(Map<String, dynamic> map, {String? id}) {
    return DailyTransactionDto(
      id: id,
      shipperId: map['shipperId'] as String? ?? '',
      shipperName: map['shipperName'] as String? ?? '',
      date: map['date'] as Timestamp? ?? Timestamp.now(),
      amount: map['amount'] as int? ?? (map['totalAmount'] as int? ?? 0),
      isFee: map['isFee'] as bool? ?? false,
      isDeposit: map['isDeposit'] as bool? ?? false,
      isReceived: map['isReceived'] as bool? ?? false,
    );
  }

  factory DailyTransactionDto.fromFirestore(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>? ?? {};
    return DailyTransactionDto(
      id: snapshot.id,
      shipperId: data['shipperId'] as String? ?? '',
      shipperName: data['shipperName'] as String? ?? '',
      date: data['date'] as Timestamp? ?? Timestamp.now(),
      amount: data['amount'] as int? ?? (data['totalAmount'] as int? ?? 0),
      isFee: data['isFee'] as bool? ?? false,
      isDeposit: data['isDeposit'] as bool? ?? false,
      isReceived: data['isReceived'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'shipperId': shipperId,
      'shipperName': shipperName,
      'date': date,
      'amount': amount,
      'isFee': isFee,
      'isDeposit': isDeposit,
      'isReceived': isReceived,
    };
  }

  DailyTransactionDto copyWith({
    String? id,
    String? shipperId,
    String? shipperName,
    Timestamp? date,
    int? amount,
    bool? isFee,
    bool? isDeposit,
    bool? isReceived,
  }) {
    return DailyTransactionDto(
      id: id ?? this.id,
      shipperId: shipperId ?? this.shipperId,
      shipperName: shipperName ?? this.shipperName,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      isFee: isFee ?? this.isFee,
      isDeposit: isDeposit ?? this.isDeposit,
      isReceived: isReceived ?? this.isReceived,
    );
  }

  @override
  String toString() {
    return 'DailyTransactionDto(id: $id, shipperId: $shipperId, date: $date, amount: $amount, isFee: $isFee, isDeposit: $isDeposit, isReceived: $isReceived)';
  }
}
