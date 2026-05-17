import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tintin_money/features/qr_scan/presentation/pages/qr_scanner_page.dart';

class EditShipperDialog extends StatefulWidget {
  final String id;
  final String name;
  final String phone;
  final String bankName;
  final String qrCode;
  final String avatarIcon;

  const EditShipperDialog({
    super.key,
    required this.id,
    required this.name,
    required this.phone,
    required this.bankName,
    required this.qrCode,
    required this.avatarIcon,
  });

  @override
  State<EditShipperDialog> createState() => _EditShipperDialogState();
}

class _EditShipperDialogState extends State<EditShipperDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _bankNameController;
  late final TextEditingController _qrController;

  bool _isSaving = false;
  bool _isCompressing = false;
  String? _nameError;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndCompressImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return;

    setState(() {
      _isCompressing = true;
    });

    try {
      final dir = await getTemporaryDirectory();
      final targetPath =
          '${dir.path}/${DateTime.now().millisecondsSinceEpoch}_compressed.jpg';

      final XFile? compressedFile =
          await FlutterImageCompress.compressAndGetFile(
            pickedFile.path,
            targetPath,
            quality: 70,
            minWidth: 500,
            minHeight: 500,
          );

      if (compressedFile != null) {
        setState(() {
          _selectedImage = File(compressedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi khi nén ảnh: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCompressing = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _phoneController = TextEditingController(text: widget.phone);
    _bankNameController = TextEditingController(text: widget.bankName);
    _qrController = TextEditingController(text: widget.qrCode);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bankNameController.dispose();
    _qrController.dispose();
    super.dispose();
  }

  Future<void> _updateShipper() async {
    final name = _nameController.text.trim();
    final qrString = _qrController.text.trim();

    setState(() {
      _nameError = name.isEmpty ? 'Họ và tên không được để trống' : null;
    });

    if (name.isEmpty) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      String? uploadedAvatarUrl;
      if (_selectedImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('shippers_avatar')
            .child('${widget.id}_${DateTime.now().millisecondsSinceEpoch}.jpg');
        final uploadTask = await storageRef.putFile(_selectedImage!);
        uploadedAvatarUrl = await uploadTask.ref.getDownloadURL();
      }

      final updateData = {
        'name': name,
        'phone': _phoneController.text.trim(),
        'bank_name': _bankNameController.text.trim(),
        'qr_string': qrString,
      };

      if (uploadedAvatarUrl != null) {
        updateData['avatar'] = uploadedAvatarUrl;
      }

      await FirebaseFirestore.instance
          .collection('shippers_profile')
          .doc(widget.id)
          .update(updateData);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi khi cập nhật: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1B1B1D),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    String? errorText,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: GoogleFonts.inter(fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: Colors.grey.shade500),
        errorText: errorText,
        errorStyle: GoogleFonts.inter(color: Colors.red, fontSize: 12),
        filled: true,
        fillColor: const Color(0xFFF6F3F5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Text(
                    'Chỉnh Sửa Thông Tin',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            // Body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar Section
                    Center(
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: _pickAndCompressImage,
                            child: _isCompressing
                                ? const CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Color(0xFFF6F3F5),
                                    child: CircularProgressIndicator(),
                                  )
                                : _selectedImage != null
                                ? CircleAvatar(
                                    radius: 50,
                                    backgroundImage: FileImage(_selectedImage!),
                                  )
                                : CachedNetworkImage(
                                    imageUrl: widget.avatarIcon,
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                          radius: 50,
                                          backgroundImage: imageProvider,
                                        ),
                                    placeholder: (context, url) =>
                                        const CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Color(0xFFF6F3F5),
                                          child: CircularProgressIndicator(),
                                        ),
                                    errorWidget: (context, url, error) =>
                                        const CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Color(0xFFF6F3F5),
                                          child: Icon(
                                            Icons.person,
                                            size: 40,
                                            color: Colors.grey,
                                          ),
                                        ),
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickAndCompressImage,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF006C4A),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildInputLabel('HỌ VÀ TÊN'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _nameController,
                      hint: 'Nhập họ và tên',
                      errorText: _nameError,
                    ),
                    const SizedBox(height: 20),
                    _buildInputLabel('SỐ ĐIỆN THOẠI'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _phoneController,
                      hint: 'Nhập số điện thoại',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),
                    _buildInputLabel('TÊN NGÂN HÀNG'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _bankNameController,
                      hint: 'Ví dụ: Vietcombank...',
                    ),
                    const SizedBox(height: 24),
                    // QR Section
                    _buildInputLabel('MÃ QR NGÂN HÀNG'),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          if (_qrController.text.isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Đã lưu mã QR',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            )
                          else
                            Text(
                              'Chưa có mã QR',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.red,
                              ),
                            ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final String? scannedQr = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const QRScannerPage(),
                                  ),
                                );
                                if (scannedQr != null) {
                                  setState(() {
                                    _qrController.text = scannedQr;
                                  });
                                }
                              },
                              icon: const Icon(Icons.qr_code_scanner),
                              label: Text(
                                'Quét lại mã QR',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF006C4A),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.black, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Hủy',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _updateShipper,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Cập nhật',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
