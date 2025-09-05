import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/model/models.dart';

class EditComposer extends StatefulWidget {
  final Blog blogToEdit; // Bài viết cần chỉnh sửa

  const EditComposer({super.key, required this.blogToEdit});

  @override
  State<EditComposer> createState() => _EditComposerState();
}

class _EditComposerState extends State<EditComposer> {
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  int? selectedPetId;
  final TextEditingController _contentController = TextEditingController();
  bool _isPetSelectorVisible = false;
  List<String> _existingImages = []; // Hình ảnh hiện có từ blog
  final List<int> _deletedFileIds = []; // FileId đã xóa
  Map<String, int> _imageFileIdMap = {}; // Mapping url -> fileId

  // Mock pets data
  final List<Pet> realPets = [
    Pet(
      petId: 1,
      accountId: 'user1',
      petName: 'Kiki',
      dateOfBirth: DateTime(2020, 5, 15),
      petImage: 'assets/images/Home5.png',
      petType: 'Cat',
      size: 'Small',
      gender: 'Female',
    ),
    Pet(
      petId: 2,
      accountId: 'user1',
      petName: 'Lulu',
      dateOfBirth: DateTime(2019, 8, 20),
      petImage: 'assets/images/Home2.png',
      petType: 'Dog',
      size: 'Medium',
      gender: 'Female',
    ),
    Pet(
      petId: 3,
      accountId: 'user1',
      petName: 'Milo',
      dateOfBirth: DateTime(2018, 3, 12),
      petImage: 'assets/images/Home3.png',
      petType: 'Dog',
      size: 'Medium',
      gender: 'Female',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Load dữ liệu bài viết hiện tại
    _loadBlogData();
  }

  void _loadBlogData() {
    _contentController.text = widget.blogToEdit.descriptionNullable ?? '';
    selectedPetId = widget.blogToEdit.petsNullable?.petId;

    if (widget.blogToEdit.imgUrlsNullable != null) {
      if (widget.blogToEdit.imgUrlsNullable is List<ImgUrl>) {
        final imageList = widget.blogToEdit.imgUrlsNullable as List<ImgUrl>;
        _existingImages = imageList.map((img) => img.url).toList();
        _imageFileIdMap = {for (var img in imageList) img.url: img.fileId};
      } else if (widget.blogToEdit.imgUrlsNullable is List) {
        final imageList = widget.blogToEdit.imgUrlsNullable as List;
        _existingImages = [];
        _imageFileIdMap = {};
        for (var item in imageList) {
          if (item is Map<String, dynamic>) {
            final url = item['url'] as String;
            final fileId = item['fileId'] as int;
            _existingImages.add(url);
            _imageFileIdMap[url] = fileId;
          }
        }
      } else if (widget.blogToEdit.imgUrlsNullable is String) {
        final imgUrls = widget.blogToEdit.imgUrlsNullable as String;
        if (imgUrls.isNotEmpty) {
          _existingImages = imgUrls
              .split(',')
              .where((url) => url.isNotEmpty)
              .toList();
        }
      }
    }
  }

  // Getter để truy cập danh sách fileId đã xóa
  List<int> get deletedFileIds => _deletedFileIds;

  // Getter để lấy petName từ petId
  String get selectedPetName {
    if (selectedPetId == null) return '';
    final pet = realPets.firstWhere(
      (pet) => pet.petId == selectedPetId,
      orElse: () => Pet(
        petId: 0,
        accountId: '',
        petName: '',
        dateOfBirth: DateTime.now(),
        petImage: '',
        petType: '',
        size: '',
        gender: '',
      ),
    );
    return pet.petName;
  }

  Future<void> _pickImages() async {
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
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi chọn ảnh: $e')));
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _removeExistingImage(int index) {
    setState(() {
      final removedImageUrl = _existingImages[index];
      _existingImages.removeAt(index);

      // Lưu fileId của ảnh đã xóa
      final fileId = _imageFileIdMap[removedImageUrl];
      if (fileId != null) {
        _deletedFileIds.add(fileId);
      }
    });
  }

  void _selectPet(Pet pet) {
    setState(() {
      selectedPetId = pet.petId;
      _isPetSelectorVisible = false;
    });
  }

  Widget _buildSelectedImagesPreview() {
    if (_selectedImages.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 60,
      margin: const EdgeInsets.only(top: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedImages.length,
        itemBuilder: (context, index) => Stack(
          children: [
            Container(
              width: 60,
              height: 60,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.file(_selectedImages[index], fit: BoxFit.cover),
              ),
            ),
            Positioned(
              top: 2,
              right: 8,
              child: GestureDetector(
                onTap: () => _removeImage(index),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 12, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExistingImagesPreview() {
    if (_existingImages.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 60,
      margin: const EdgeInsets.only(top: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _existingImages.length,
        itemBuilder: (context, index) => Stack(
          children: [
            Container(
              width: 60,
              height: 60,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(_existingImages[index], fit: BoxFit.cover),
              ),
            ),
            Positioned(
              top: 2,
              right: 8,
              child: GestureDetector(
                onTap: () => _removeExistingImage(index),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 12, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetSelector() {
    if (!_isPetSelectorVisible) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.teal.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Chọn pet',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal.shade700,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => setState(() => _isPetSelectorVisible = false),
              ),
            ],
          ),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: realPets.length,
              itemBuilder: (context, index) {
                final pet = realPets[index];
                final isSelected = selectedPetId == pet.petId;
                return GestureDetector(
                  onTap: () => _selectPet(pet),
                  child: Container(
                    width: 70,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? Colors.teal : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage(pet.petImage),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          pet.petName,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? Colors.teal
                                : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _updateBlog() {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập nội dung'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    String message =
        'Đã cập nhật với pet: ${selectedPetName.isEmpty ? 'Không chọn' : selectedPetName}';
    if (_deletedFileIds.isNotEmpty)
      message += '\nĐã xóa ${_deletedFileIds.length} ảnh';
    if (_selectedImages.isNotEmpty)
      message += '\nĐã thêm ${_selectedImages.length} ảnh mới';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final responsivePadding = MediaQuery.of(context).size.width * 0.04;
    final fontSize = MediaQuery.of(context).size.width * 0.04;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(responsivePadding * 0.8),
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 18,
                      backgroundImage: AssetImage(
                        'assets/images/user_avatar.jpg',
                      ),
                    ),
                    SizedBox(width: responsivePadding * 0.8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: TextField(
                          controller: _contentController,
                          maxLines: null,
                          minLines: 1,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          style: TextStyle(
                            fontSize: fontSize * 0.8,
                            height: 1.2,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Hôm nay thú cưng bạn thế nào...?',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: fontSize * 0.7,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                _buildExistingImagesPreview(),
                _buildSelectedImagesPreview(),
                _buildPetSelector(),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                IconButton(
                  onPressed: _pickImages,
                  icon: Icon(
                    Icons.photo_library,
                    color: Colors.teal.shade600,
                    size: 20,
                  ),
                  tooltip: 'Thêm ảnh',
                ),
                IconButton(
                  onPressed: () => setState(
                    () => _isPetSelectorVisible = !_isPetSelectorVisible,
                  ),
                  icon: Icon(
                    Icons.pets,
                    color: selectedPetId != null
                        ? Colors.teal
                        : Colors.grey.shade600,
                    size: 20,
                  ),
                  tooltip: selectedPetId != null ? selectedPetName : 'Chọn pet',
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _updateBlog,
                  icon: const Icon(Icons.update, size: 16),
                  label: const Text('Cập nhật'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }
}
