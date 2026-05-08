import 'package:cloud_firestore/cloud_firestore.dart';
import '../DTO/shipper_profile_dto.dart';

/// Repository (Data Access Layer) cho collection `shippers_profile`.
/// Đây là nơi DUY NHẤT chứa truy vấn FirebaseFirestore.
/// Mọi thao tác CRUD với Firestore đều phải đi qua class này.
class ShipperProfileRepository {
  static const String _collection = 'shippers_profile';

  final FirebaseFirestore _firestore;

  ShipperProfileRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Lấy reference tới collection.
  CollectionReference get _collectionRef =>
      _firestore.collection(_collection);

  /// Stream real-time danh sách tất cả shipper profiles.
  Stream<List<ShipperProfileDto>> watchAll() {
    return _collectionRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ShipperProfileDto.fromFirestore(doc))
          .toList();
    });
  }

  /// Lấy một shipper profile theo document ID.
  Future<ShipperProfileDto?> getById(String id) async {
    final doc = await _collectionRef.doc(id).get();
    if (!doc.exists) return null;
    return ShipperProfileDto.fromFirestore(doc);
  }

  /// Thêm mới một shipper profile.
  /// Trả về document ID được Firestore tự tạo.
  Future<String> add(ShipperProfileDto dto) async {
    final docRef = await _collectionRef.add(dto.toMap());
    return docRef.id;
  }

  /// Cập nhật shipper profile theo document ID.
  /// Chỉ cập nhật các field có trong map, không ghi đè toàn bộ document.
  Future<void> update(String id, Map<String, dynamic> data) async {
    await _collectionRef.doc(id).update(data);
  }

  /// Xoá shipper profile theo document ID.
  Future<void> delete(String id) async {
    await _collectionRef.doc(id).delete();
  }
}
