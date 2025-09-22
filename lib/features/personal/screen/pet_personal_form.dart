import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:myapp/shared/model/pet.dart';

class PetFormScreen extends StatefulWidget {
  final Pet? pet;
  const PetFormScreen({super.key, this.pet});

  @override
  State<PetFormScreen> createState() => _PetFormScreenState();
}

class _PetFormScreenState extends State<PetFormScreen> {
  final formKey = GlobalKey<FormState>();
  late final name = TextEditingController(text: widget.pet?.petName);
  late final dob = TextEditingController(
    text: widget.pet?.dateOfBirth != null
        ? DateFormat('dd/MM/yyyy').format(widget.pet!.dateOfBirth)
        : null,
  );
  late final species = TextEditingController(text: widget.pet?.petType);
  late final size = TextEditingController(text: widget.pet?.size);
  late final gender = ValueNotifier<String>(widget.pet?.gender ?? 'Đực');

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.pet != null;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE8F5E8), // Light green
            Color(0xFFF3E5F5), // Light purple
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          title: Text(
            isEdit ? 'Cập nhật thú cưng' : 'Thêm thú cưng mới',
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Avatar section
              Center(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF81C784), Color(0xFF4CAF50)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.transparent,
                        child: Icon(Icons.pets, size: 40, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFA726),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                          iconSize: 20,
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Form fields
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _field('Tên thú cưng', controller: name, icon: Icons.pets),
                    const SizedBox(height: 16),
                    _field(
                      'Ngày sinh',
                      controller: dob,
                      icon: Icons.calendar_today,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                          initialDate: DateTime.now(),
                        );
                        if (picked != null) {
                          dob.text = DateFormat('dd/MM/yyyy').format(picked);
                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    _field(
                      'Loại thú',
                      controller: species,
                      icon: Icons.category,
                    ),
                    const SizedBox(height: 16),
                    _field(
                      'Kích thước',
                      controller: size,
                      icon: Icons.aspect_ratio,
                    ),
                    const SizedBox(height: 16),
                    ValueListenableBuilder(
                      valueListenable: gender,
                      builder: (_, g, __) => Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: g,
                          decoration: InputDecoration(
                            labelText: 'Giới tính',
                            prefixIcon: Icon(
                              g == 'Đực' ? Icons.male : Icons.female,
                              color: g == 'Đực' ? Colors.blue : Colors.pink,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          items: const ['Đực', 'Cái']
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Row(
                                    children: [
                                      Icon(
                                        e == 'Đực' ? Icons.male : Icons.female,
                                        color: e == 'Đực'
                                            ? Colors.blue
                                            : Colors.pink,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(e),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => gender.value = v!,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Submit button
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF81C784), Color(0xFF4CAF50)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    final pet = Pet(
                      petId: widget.pet?.petId,
                      petName: name.text,
                      dateOfBirth: dob.text.isNotEmpty
                          ? DateFormat('dd/MM/yyyy').tryParse(dob.text)
                          : null,
                      petType: species.text,
                      size: size.text,
                      gender: gender.value,
                    );
                    Navigator.of(context).pop(pet);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    isEdit ? 'Lưu thay đổi' : 'Tạo mới',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label, {
    TextEditingController? controller,
    int maxLines = 1,
    VoidCallback? onTap,
    IconData? icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        readOnly: onTap != null,
        onTap: onTap,
        validator: (v) =>
            (v == null || v.isEmpty) ? 'Vui lòng nhập $label' : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null
              ? Icon(icon, color: Colors.grey.shade600)
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
