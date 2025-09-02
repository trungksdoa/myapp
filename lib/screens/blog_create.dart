import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/core/utils/device_size.dart';
import 'package:myapp/model/pet.dart';
import 'package:myapp/widget/boxContainer.dart';

import 'package:myapp/widget/group/group_app_bar.dart';

class BlogCreate extends StatefulWidget {
  const BlogCreate({super.key});

  @override
  State<BlogCreate> createState() => _BlogCreateState();
}

class _BlogCreateState extends State<BlogCreate> {
  String petSelect = "";
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _petSelectController = TextEditingController();
  final List<File> _selectedImages = []; // ✅ Thay đổi từ File? thành List<File>
  final ImagePicker _picker = ImagePicker();
  String groupId = "";

  final mockPets = [
    {'name': 'Tini', 'image': 'assets/images/Home1.png'},
    {'name': 'Lulu', 'image': 'assets/images/Home2.png'},
    {'name': 'Milo', 'image': 'assets/images/Home3.png'},
    {'name': 'Coco', 'image': 'assets/images/Home4.png'},
    {'name': 'Kiki', 'image': 'assets/images/Home5.png'},
    {'name': 'Luna', 'image': 'assets/images/Home6.png'},
  ];

  final realPets = [
    Pet(
      petId: '1',
      accountId:
          'user1', // Assuming a default account ID; replace with actual value if available
      petName: 'Kiki',
      dateOfBirth: DateTime(2020, 5, 15), // Example date; adjust as needed
      petImage: 'assets/images/Home5.png',
      petType: 'Cat', // Assuming based on name; adjust as needed
      size: 'Small', // Assuming; adjust as needed
      gender: 'Female', // Assuming; adjust as needed
    ),
    Pet(
      petId: '2',
      accountId: 'user1',
      petName: 'Lulu',
      dateOfBirth: DateTime(2019, 8, 20),
      petImage: 'assets/images/Home2.png',
      petType: 'Dog',
      size: 'Medium',
      gender: 'Female',
    ),
    Pet(
      petId: '3',
      accountId: 'user1',
      petName: 'Milo',
      dateOfBirth: DateTime(2018, 3, 12),
      petImage: 'assets/images/Home3.png',
      petType: 'Dog',
      size: 'Medium',
      gender: 'Female',
    ),

    Pet(
      petId: '4',
      accountId: 'user1',
      petName: 'Luffy',
      dateOfBirth: DateTime(2018, 3, 12),
      petImage: 'assets/images/Home4.png',
      petType: 'Dog',
      size: 'Medium',
      gender: 'Female',
    ),

    Pet(
      petId: '5',
      accountId: 'user1',
      petName: 'Doremon',
      dateOfBirth: DateTime(2018, 3, 12),
      petImage: 'assets/images/Home5.png',
      petType: 'Dog',
      size: 'Medium',
      gender: 'Female',
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  _resetAll() {
    setState(() {
      _contentController.clear();
      _petSelectController.clear();
      petSelect = "";
      _selectedImages.clear(); // ✅ Clear list instead of single file
    });
  }

  // Hàm để chọn pet
  _selectPet(String petId) {
    setState(() {
      petSelect = realPets.firstWhere((pet) => pet.petId == petId).petName;
      _petSelectController.text = petSelect;
    });
  }

  // Build Pet Grid Widget
  Widget _buildPetGrid(double fontSize) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: realPets.length,
        itemBuilder: (context, index) {
          final pet = realPets[index];
          final isSelected = petSelect == pet.petName;

          return GestureDetector(
            onTap: () => _selectPet(pet.petId),
            child: Container(
              width: 120,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.teal.withValues(alpha: 0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Colors.teal
                        : Colors.grey.withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? Colors.teal.withValues(alpha: 0.2)
                          : Colors.grey.withValues(alpha: 0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.2),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22.5),
                        child: Image.asset(
                          pet.petImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(22.5),
                              ),
                              child: const Icon(
                                Icons.pets,
                                size: 20,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      pet.petName,
                      style: TextStyle(
                        fontSize: fontSize * 0.75,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isSelected ? Colors.teal[700] : Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _onReset() {
    _resetAll();
  }

  _onSave() {
    if (_verifyOnSave()) {
      return;
    }
    _showInfoSnackBar('Đăng bài viết thành công!');
    // Save logic here
  }

  bool _verifyOnSave() {
    bool error = false;
    if (_contentController.text.isEmpty) {
      _showErrorSnackBar('Nội dung không được để trống');
      error = true;
    }

    if (petSelect.isEmpty) {
      _showErrorSnackBar('Bạn có chọn thú cưng muốn đăng nhớ ');
      error = true;
    }

    return error;
  }

  // ✅ Pick multiple images from gallery
  Future<void> _pickMultipleImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );

      if (images.isNotEmpty) {
        setState(() {
          // Add new images to existing list
          _selectedImages.addAll(images.map((xFile) => File(xFile.path)));
        });
        _showInfoSnackBar('Đã thêm ${images.length} hình ảnh!');
      }
    } catch (e) {
      _showErrorSnackBar('Lỗi khi chọn ảnh: $e');
    }
  }

  // ✅ Pick single image from camera
  Future<void> _pickFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImages.add(File(image.path));
        });
        _showInfoSnackBar('Đã thêm ảnh từ camera!');
      }
    } catch (e) {
      _showErrorSnackBar('Lỗi khi chụp ảnh: $e');
    }
  }

  // ✅ Remove image from list
  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
    _showInfoSnackBar('Đã xóa hình ảnh!');
  }

  Widget _buildImageGrid(double fontSize) {
    if (_selectedImages.isEmpty) {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_outlined, size: 40, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text(
                'Chưa có hình ảnh nào',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: fontSize * 0.9,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedImages.length,
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: 12),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.2),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _selectedImages[index],
                      width: 100,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Remove button
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => _removeImage(index),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.orange),
    );
  }

  void _showInfoSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.blue),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = DeviceSize.getResponsiveFontSize(screenWidth);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: 'Tạo bài viết',
        isUseTextButton: true,
        saveButtonText: 'Đăng',
        onSave: () {
          _onSave();
        },
        onReset: () {
          _onReset();
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🐾 Pet Selection Card - ✅ Thay bằng BoxContainerShadow
              BoxContainerShadow(
                padding: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.pets, color: Colors.teal, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Chọn thú cưng',
                          style: TextStyle(
                            fontSize: fontSize * 1.1,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Selected Pet Display
                    if (petSelect.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.teal.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.teal.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          '🐾 $petSelect được chọn',
                          style: TextStyle(
                            color: Colors.teal[700],
                            fontWeight: FontWeight.w500,
                            fontSize: fontSize * 0.9,
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Pet Grid
                    _buildPetGrid(fontSize),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 📝 Content Input Card - ✅ Thay bằng BoxContainerShadow
              BoxContainerShadow(
                padding: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.edit_note,
                          color: Colors.teal,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Nội dung bài viết',
                          style: TextStyle(
                            fontSize: fontSize * 1.1,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _contentController,
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: 'Hôm nay thú cưng bạn thế nào...?',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: fontSize * 0.9,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.teal,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 📷 Multi-Image Section Card - ✅ Thay bằng BoxContainerShadow
              BoxContainerShadow(
                padding: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.photo_camera,
                          color: Colors.teal,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Hình ảnh (${_selectedImages.length})',
                          style: TextStyle(
                            fontSize: fontSize * 1.1,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Image grid display
                    _buildImageGrid(fontSize),

                    const SizedBox(height: 16),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _pickMultipleImages,
                            icon: const Icon(Icons.photo_library, size: 18),
                            label: Text(
                              'Thư viện',
                              style: TextStyle(fontSize: fontSize * 0.9),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _pickFromCamera,
                            icon: const Icon(Icons.camera_alt, size: 18),
                            label: Text(
                              'Camera',
                              style: TextStyle(fontSize: fontSize * 0.9),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[600],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _contentController.dispose();
    _petSelectController.dispose();
    super.dispose();
  }
}
