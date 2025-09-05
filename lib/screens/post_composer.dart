import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/model/models.dart';

class PostComposer extends StatefulWidget {
  const PostComposer({super.key});

  @override
  State<PostComposer> createState() => _PostComposerState();
}

class _PostComposerState extends State<PostComposer> {
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  String petSelect = "";
  int petSelectId = 0;
  final TextEditingController _contentController = TextEditingController();

  bool _isPetSelectorVisible = false;

  // Mock pets data (có thể thay bằng data thật sau)
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
    //More pet
    Pet(
      petId: 3,
      accountId: 'user1',
      petName: 'Max',
      dateOfBirth: DateTime(2018, 3, 10),
      petImage: 'assets/images/Home3.png',
      petType: 'Dog',
      size: 'Large',
      gender: 'Male',
    ),
    Pet(
      petId: 4,
      accountId: 'user1',
      petName: 'Bella',
      dateOfBirth: DateTime(2021, 11, 5),
      petImage: 'assets/images/Home4.png',
      petType: 'Cat',
      size: 'Small',
      gender: 'Female',
    ),
    Pet(
      petId: 5,
      accountId: 'user1',
      petName: 'Charlie',
      dateOfBirth: DateTime(2017, 6, 25),
      petImage: 'assets/images/Home1.png',
      petType: 'Dog',
      size: 'Medium',
      gender: 'Male',
    ),
  ];

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );

      if (images.isNotEmpty) {
        setState(() {
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

  void _selectPet(Pet pet) {
    setState(() {
      petSelect = pet.petName;
      petSelectId = pet.petId;
      _isPetSelectorVisible = false; // Ẩn selector sau khi chọn
    });
  }

  Widget _buildSelectedImagesPreview() {
    if (_selectedImages.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 80,
      margin: const EdgeInsets.only(top: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedImages.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.teal.shade200),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(_selectedImages[index], fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: 4,
                right: 12,
                child: GestureDetector(
                  onTap: () => _removeImage(index),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Chọn thú cưng',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal.shade700,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () {
                  setState(() {
                    _isPetSelectorVisible = false;
                  });
                },
              ),
            ],
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: realPets.length,
              itemBuilder: (context, index) {
                final pet = realPets[index];
                return GestureDetector(
                  onTap: () => _selectPet(pet),
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: petSelect == pet.petName
                            ? Colors.teal
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(pet.petImage),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          pet.petName,
                          style: TextStyle(
                            fontSize: 12,
                            color: petSelect == pet.petName
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

  @override
  void dispose() {
    _contentController.dispose();
    _selectedImages.clear();
    petSelectId = 0;
    petSelect = "";
    _isPetSelectorVisible = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsivePadding = MediaQuery.of(context).size.width * 0.04;
    final fontSize = MediaQuery.of(context).size.width * 0.045;
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
            padding: EdgeInsets.all(responsivePadding),
            child: Column(
              children: [
                // Header
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(
                        'assets/images/user_avatar.jpg',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12, // Giảm từ 16 xuống 12
                          vertical: 12, // Giảm từ 12 xuống 8
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(
                            16,
                          ), // Giảm từ 20 xuống 16
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: TextField(
                          controller: _contentController,
                          maxLines: null, // Cho phép unlimited lines thay vì 1
                          minLines:
                              1, // Đặt minLines để có kích thước tối thiểu
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          style: TextStyle(
                            fontSize: fontSize * 0.8, // Giảm font size
                            height: 1.2, // Giảm line height
                          ),
                          decoration: InputDecoration(
                            hintText: 'Hôm nay thú cưng bạn thế nào...?',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: fontSize * 0.7, // Giảm hint font size
                            ),
                            border: InputBorder.none, // Bỏ border của TextField
                            enabledBorder:
                                InputBorder.none, // Bỏ border khi enabled
                            focusedBorder:
                                InputBorder.none, // Bỏ border khi focus
                            filled: false, // Bỏ fill color
                            contentPadding:
                                EdgeInsets.zero, // Bỏ content padding
                            isDense: true, // Làm compact hơn
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Selected Images Preview
                _buildSelectedImagesPreview(),

                // Pet Selector
                _buildPetSelector(),
              ],
            ),
          ),

          // Divider
          Divider(height: 1, color: Colors.grey.shade200),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // Chọn ảnh button
                Expanded(
                  child: TextButton.icon(
                    onPressed: _pickImages,
                    icon: Icon(
                      Icons.photo_library,
                      color: Colors.teal.shade600,
                    ),
                    label: Text(
                      'Thêm ảnh',
                      style: TextStyle(color: Colors.teal.shade600),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                // Chọn pet button
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _isPetSelectorVisible = !_isPetSelectorVisible;
                      });
                    },
                    icon: Icon(
                      Icons.pets,
                      color: petSelect.isNotEmpty
                          ? Colors.teal
                          : Colors.grey.shade600,
                    ),
                    label: Text(
                      petSelect.isNotEmpty ? petSelect : 'Chọn pet',
                      style: TextStyle(
                        color: petSelect.isNotEmpty
                            ? Colors.teal
                            : Colors.grey.shade600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                // Nút Đăng bài
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: ElevatedButton.icon(
                    onPressed: _postBlog,
                    icon: const Icon(Icons.send, size: 18),
                    label: const Text('Đăng'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      elevation: 2,
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

  // Thêm method _postBlog
  void _postBlog() {
    // Validation
    if (_selectedImages.isEmpty && petSelect.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn ảnh hoặc thú cưng để đăng bài'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // TODO: Implement actual post logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đang đăng bài viết...'),
        backgroundColor: Colors.blue,
      ),
    );

    // Reset form after posting
    setState(() {
      _selectedImages.clear();
      petSelect = "";
      _isPetSelectorVisible = false;
    });
  }
}
