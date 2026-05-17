import '../data/DTO/shipper_profile_dto.dart';
import '../data/Repositories/shipper_profile_repository.dart';

/// Service (Business Logic Layer) cho Shipper Profile.
/// UI không được tự tính toán hay truy vấn Firestore.
/// Mọi logic nghiệp vụ phải đi qua Service này.
class ShipperProfileService {
  static const String _defaultAvatarUrl =
      'https://firebasestorage.googleapis.com/v0/b/tintin-money.firebasestorage.app/o/avatar%2FUsers2_6.png?alt=media&token=d3547afe-c26f-4371-a3c1-8813f86199cf';

  late ShipperProfileRepository _repository;
  List<ShipperProfileDto> _shippers = [];

  ShipperProfileService({ShipperProfileRepository? repository}) {
    _repository = repository ?? ShipperProfileRepository();
    _repository.watchAll().listen((shippers) {
      _shippers = shippers;
    });
  }

  // ---------------------------------------------------------------------------
  // READ
  // ---------------------------------------------------------------------------

  /// Stream real-time danh sách tất cả shipper.
  Stream<List<ShipperProfileDto>> watchAllShippers() {
    return _repository.watchAll();
  }

  /// Stream real-time length of shipper list
  ///
  Stream<int> watchShipperCount() {
    return _repository.watchAll().map((shippers) => shippers.length);
  }

  /// Lấy một shipper theo ID.
  Future<ShipperProfileDto?> getShipperById(String id) {
    return _repository.getById(id);
  }

  // ---------------------------------------------------------------------------
  // CREATE
  // ---------------------------------------------------------------------------

  /// Thêm mới shipper.
  /// Trả về document ID vừa tạo.
  /// Throws [ArgumentError] nếu validation thất bại.
  Future<String> addShipper({
    required String name,
    required String phone,
    required String bankName,
    required String qrString,
    String? avatar,
  }) {
    // Validation
    final errors = validate(name: name, qrString: qrString);
    if (errors.isNotEmpty) {
      throw ArgumentError(errors.values.first);
    }

    final dto = ShipperProfileDto(
      id: '', // sẽ được Firestore gán
      name: name.trim(),
      phone: phone.trim(),
      bankName: bankName.trim(),
      qrString: qrString.trim(),
      avatar: avatar ?? _defaultAvatarUrl,
    );

    return _repository.add(dto);
  }

  // ---------------------------------------------------------------------------
  // UPDATE
  // ---------------------------------------------------------------------------

  /// Cập nhật thông tin shipper.
  /// Throws [ArgumentError] nếu validation thất bại.
  Future<void> updateShipper({
    required String id,
    required String name,
    required String phone,
    required String bankName,
    required String qrString,
  }) {
    // Validation
    final errors = validate(name: name);
    if (errors.isNotEmpty) {
      throw ArgumentError(errors.values.first);
    }

    return _repository.update(id, {
      'name': name.trim(),
      'phone': phone.trim(),
      'bank_name': bankName.trim(),
      'qr_string': qrString.trim(),
    });
  }

  // ---------------------------------------------------------------------------
  // DELETE
  // ---------------------------------------------------------------------------

  /// Xoá shipper theo ID.
  Future<void> deleteShipper(String id) {
    return _repository.delete(id);
  }

  // ---------------------------------------------------------------------------
  // VALIDATION & BUSINESS LOGIC
  // ---------------------------------------------------------------------------

  /// Validate dữ liệu shipper.
  /// Trả về Map<fieldName, errorMessage>. Rỗng nếu hợp lệ.
  Map<String, String> validate({String? name, String? qrString}) {
    final errors = <String, String>{};

    if (name != null && name.trim().isEmpty) {
      errors['name'] = 'Họ và tên không được để trống';
    }

    if (qrString != null && qrString.trim().isEmpty) {
      errors['qrString'] = 'Mã QR không được để trống';
    }

    return errors;
  }

  List<ShipperProfileDto> searchByName(String query) {
    final lowerCase = query.toLowerCase().trim();
    return _shippers
        .where((shipper) => shipper.name.toLowerCase().contains(lowerCase))
        .toList();
  }
}
