import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/route/navigate_helper.dart';
import 'dart:io';

// Import các widget components
import 'package:myapp/shared/widgets/common/image_picker_widget.dart';
import 'package:myapp/shared/widgets/common/custom_text_field.dart';
import 'package:myapp/features/family/widgets/group_app_bar.dart';
import 'package:myapp/features/family/widgets/field_member_widget.dart';
import 'package:myapp/shared/widgets/common/info_guide_widget.dart';
import 'package:myapp/shared/widgets/common/info_tip_widget.dart';
import 'package:myapp/shared/widgets/dialogs/custom_diaglog.dart';

class GroupCreate extends StatefulWidget {
  const GroupCreate({super.key});

  @override
  State<GroupCreate> createState() => _GroupCreateState();
}

class _GroupCreateState extends State<GroupCreate> {
  // Core data
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<TextEditingController> _memberControllers = [];
  final List<String> _memberLabels = [];
  int _memberCount = 0;

  @override
  void initState() {
    super.initState();
    _resetAllFields();
  }

  // Reset tất cả fields
  void _resetAllFields() {
    _disposeMemberControllers();
    setState(() {
      _selectedImage = null;
      _nameController.clear();
      _descriptionController.clear();
      _memberControllers.clear();
      _memberLabels.clear();
      _memberCount = 0;
      _addMemberField();
    });
  }

  // Dispose member controllers để tránh memory leak
  void _disposeMemberControllers() {
    for (var controller in _memberControllers) {
      controller.dispose();
    }
  }

  // Thêm field thành viên mới
  void _addMemberField() {
    setState(() {
      _memberCount++;
      _memberControllers.add(TextEditingController());
      _memberLabels.add('Thành viên $_memberCount');
    });
  }

  // Xóa field thành viên
  void _removeMemberField(int index) {
    if (_memberControllers.length <= 1) return;

    setState(() {
      _memberControllers[index].dispose();
      _memberControllers.removeAt(index);
      _memberLabels.removeAt(index);
      _updateMemberLabels();
    });
  }

  // Cập nhật lại label cho các thành viên
  void _updateMemberLabels() {
    for (int i = 0; i < _memberLabels.length; i++) {
      _memberLabels[i] = 'Thành viên ${i + 1}';
    }
  }

  // Pick image từ gallery
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      _showErrorSnackBar('Lỗi khi chọn ảnh: $e');
    }
  }

  // Validate và tạo nhóm
  void _createGroup() {
    // Validate tên nhóm
    if (_nameController.text.trim().isEmpty) {
      _showErrorSnackBar('Vui lòng nhập tên nhóm!');
      return;
    }

    // Lấy danh sách thành viên (loại bỏ field trống)
    final members = _memberControllers
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    if (members.isEmpty) {
      _showErrorSnackBar('Vui lòng thêm ít nhất một thành viên!');
      return;
    }

    // Xử lý tạo nhóm thành công
    // _showSuccessSnackBar(
    //   'Đã tạo nhóm "${_nameController.text}" với ${members.length} thành viên!',
    // );

    showDialog(
      context: context,
      builder: (context) =>
          CustomDialog.success(content: "Tạo nhóm thành công"),
    ).then((_) {
      if (mounted) {
        NavigateHelper.goToFamily(context);
      }
    });

    _resetAllFields();
    // Navigator.pop(context);
  }

  // Helper methods cho SnackBar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.orange),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppBar(
        title: 'Tạo nhóm',
        onReset: _resetAllFields,
        onSave: _createGroup,
        isUseTextButton: true,
        saveButtonText: 'Tạo',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar picker
            ImagePickerWidget(
              selectedImage: _selectedImage,
              onImagePick: _pickImage,
            ),

            const SizedBox(height: 32),

            // Tên nhóm
            CustomTextField(
              controller: _nameController,
              labelText: 'Tên nhóm',
              required: true,
              prefixIcon: const Icon(Icons.group_outlined, color: Colors.teal),
            ),

            const SizedBox(height: 20),

            // Mô tả nhóm
            CustomTextField(
              controller: _descriptionController,
              labelText: 'Mô tả nhóm',
              maxLines: 4,
            ),

            const SizedBox(height: 32),

            // Header thành viên
            _buildMemberHeader(),

            const SizedBox(height: 16),

            // Danh sách thành viên
            ..._buildMemberFields(tooltipText: 'Xóa thành viên'),

            const SizedBox(height: 24),

            // Tips
            const InfoGuideWidget(message: 'Yêu cầu: Nhập mã người dùng'),

            const SizedBox(height: 16),

            const InfoGuideWidget(
              message:
                  "Hướng dẫn: Vào cài đặt tìm và chọn 'thông tin người dùng', "
                  "tìm và sao chép 'ID người dùng'",
            ),

            const SizedBox(height: 16),

            const InfoTipWidget(
              message:
                  'Mẹo: Nhấn nút + để thêm thành viên. Nhấn nút 🔄 để reset tất cả.',
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Build member header với counter và add button
  Widget _buildMemberHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Thành viên (${_memberControllers.length})',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 20),
            onPressed: _addMemberField,
            tooltip: 'Thêm thành viên',
          ),
        ),
      ],
    );
  }

  // Build danh sách member fields
  List<Widget> _buildMemberFields({required String tooltipText}) {
    return List.generate(_memberControllers.length, (index) {
      return MemberFieldWidget(
        controller: _memberControllers[index],
        label: _memberLabels[index],
        canRemove: _memberControllers.length > 1,
        tooltipText: tooltipText,
        onRemove: () => _removeMemberField(index),
      );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _disposeMemberControllers();
    super.dispose();
  }
}
