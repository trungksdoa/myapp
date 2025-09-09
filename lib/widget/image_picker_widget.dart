import 'package:flutter/material.dart';
import 'dart:io';

/// A customizable widget for selecting and displaying images.
/// Provides predefined factory constructors for common use cases
/// like avatars, cover photos, and gallery selections.
///
/// The widget displays a circular/square container that shows either
/// the selected image or a placeholder with an icon and text.
class ImagePickerWidget extends StatelessWidget {
  /// The currently selected image file.
  /// If null, placeholder content will be displayed instead.
  final File? selectedImage;

  /// Callback function executed when the user taps the widget.
  /// Typically this should open an image picker dialog.
  final VoidCallback onImagePick;

  /// The size (width and height) of the image picker container.
  final double size;

  /// Placeholder text displayed when no image is selected.
  /// If null, defaults to 'Thêm ảnh'.
  final String? placeholder;

  /// Icon displayed in the placeholder when no image is selected.
  /// If null, defaults to Icons.add_a_photo_outlined.
  final IconData? icon;

  /// Creates a customizable image picker widget.
  ///
  /// [selectedImage] is the currently selected image file (can be null).
  /// [onImagePick] is called when the user taps to pick an image.
  ///
  /// Example:
  /// ```dart
  /// ImagePickerWidget(
  ///   selectedImage: _selectedImage,
  ///   onImagePick: () => _pickImage(),
  ///   size: 150.0,
  ///   placeholder: 'Select Image',
  ///   icon: Icons.image,
  /// )
  /// ```
  const ImagePickerWidget({
    super.key,
    required this.selectedImage,
    required this.onImagePick,
    this.size = 120,
    this.placeholder,
    this.icon,
  });

  /// Creates an ImagePickerWidget optimized for avatar selection.
  ///
  /// Pre-configured with appropriate size and placeholder text for profile pictures.
  ///
  /// [selectedImage] is the currently selected avatar image.
  /// [onImagePick] is called when the user wants to pick a new avatar.
  factory ImagePickerWidget.avatar({
    required File? selectedImage,
    required VoidCallback onImagePick,
    double size = 120,
  }) {
    return ImagePickerWidget(
      selectedImage: selectedImage,
      onImagePick: onImagePick,
      size: size,
      placeholder: 'Thêm ảnh',
      icon: Icons.add_a_photo_outlined,
    );
  }

  /// Creates an ImagePickerWidget optimized for cover photo selection.
  ///
  /// Pre-configured with larger size and appropriate placeholder text for cover photos.
  ///
  /// [selectedImage] is the currently selected cover photo.
  /// [onImagePick] is called when the user wants to pick a new cover photo.
  factory ImagePickerWidget.cover({
    required File? selectedImage,
    required VoidCallback onImagePick,
    double size = 200,
  }) {
    return ImagePickerWidget(
      selectedImage: selectedImage,
      onImagePick: onImagePick,
      size: size,
      placeholder: 'Chọn ảnh bìa',
      icon: Icons.photo_camera_outlined,
    );
  }

  /// Creates an ImagePickerWidget optimized for gallery image selection.
  ///
  /// Pre-configured with compact size for grid layouts and gallery browsing.
  ///
  /// [selectedImage] is the currently selected gallery image.
  /// [onImagePick] is called when the user wants to pick an image from gallery.
  factory ImagePickerWidget.gallery({
    required File? selectedImage,
    required VoidCallback onImagePick,
    double size = 100,
  }) {
    return ImagePickerWidget(
      selectedImage: selectedImage,
      onImagePick: onImagePick,
      size: size,
      placeholder: 'Thêm ảnh',
      icon: Icons.add_photo_alternate_outlined,
    );
  }

  /// Builds the ImagePickerWidget.
  ///
  /// Returns a GestureDetector containing a circular/square container
  /// with either the selected image or placeholder content.
  @override
  Widget build(BuildContext context) {
    final double radius = size / 2;
    final double innerRadius = radius - 2;

    return Center(
      child: GestureDetector(
        onTap: onImagePick,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Colors.grey.shade300, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: selectedImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(innerRadius),
                  child: Image.file(selectedImage!, fit: BoxFit.cover),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon ?? Icons.add_a_photo_outlined,
                      size: size * 0.25,
                      color: Colors.grey.shade600,
                    ),
                    SizedBox(height: size * 0.08),
                    Text(
                      placeholder ?? 'Thêm ảnh',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: size * 0.1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
