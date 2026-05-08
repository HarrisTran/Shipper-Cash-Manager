import 'package:cloud_firestore/cloud_firestore.dart';

/// DTO duy nhất đại diện cho document trong collection `shippers_profile`.
/// Mọi tầng (Repository, Service, UI) đều dùng class này để truyền dữ liệu.
class ShipperProfileDto {
  final String id;
  final String name;
  final String phone;
  final String bankName;
  final String qrString;
  final String avatar;

  const ShipperProfileDto({
    required this.id,
    required this.name,
    required this.phone,
    required this.bankName,
    required this.qrString,
    required this.avatar,
  });

  /// Factory constructor: parse từ Firestore DocumentSnapshot.
  factory ShipperProfileDto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ShipperProfileDto(
      id: doc.id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      bankName: data['bank_name'] ?? '',
      qrString: data['qr_string'] ?? '',
      avatar: data['avatar'] ?? '',
    );
  }

  /// Serialize thành Map để ghi vào Firestore.
  /// Không bao gồm `id` vì Firestore tự quản lý document ID.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'bank_name': bankName,
      'qr_string': qrString,
      'avatar': avatar,
    };
  }

  /// Tạo bản sao với các field được thay đổi.
  ShipperProfileDto copyWith({
    String? id,
    String? name,
    String? phone,
    String? bankName,
    String? qrString,
    String? avatar,
  }) {
    return ShipperProfileDto(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      bankName: bankName ?? this.bankName,
      qrString: qrString ?? this.qrString,
      avatar: avatar ?? this.avatar,
    );
  }
}
