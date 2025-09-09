import 'package:flutter/material.dart';

/// Custom text field widget with comprehensive styling and predefined input types.
/// Provides factory constructors for common form fields like password, email, search, etc.
/// Includes validation support, icons, and customizable appearance.
///
/// Designed for consistent form input across the app with flexible styling options.
class CustomTextField extends StatelessWidget {
  /// Controller for managing the text input content.
  final TextEditingController controller;

  /// Text label displayed above the input field.
  final String? labelText;

  /// Placeholder text shown when the field is empty.
  final String? hintText;

  /// Icon displayed at the beginning of the input field.
  final Icon? prefixIcon;

  /// Widget displayed at the end of the input field (often an IconButton).
  final Widget? suffixIcon;

  /// Whether to obscure the text (for passwords).
  final bool obscureText;

  /// Type of keyboard to show for this input field.
  final TextInputType? keyboardType;

  /// Maximum number of lines for multi-line input.
  final int maxLines;

  /// Whether this field is required (adds asterisk to label).
  final bool required;

  /// Function for custom validation of the input.
  final String? Function(String?)? validator;

  /// Callback fired when the text content changes.
  final void Function(String)? onChanged;

  /// Callback fired when the text field is tapped.
  final void Function()? onTap;

  /// Whether this field should be read-only.
  final bool readOnly;

  /// Background fill color of the input field.
  final Color? fillColor;

  /// Color of the input border.
  final Color? borderColor;

  /// Border radius of the input field corners.
  final double borderRadius;

  /// Custom padding around the input content.
  final EdgeInsetsGeometry? contentPadding;

  /// Creates a customizable text input field.
  ///
  /// [controller] must not be null and manages the text input.
  /// All styling parameters are optional with sensible defaults.
  const CustomTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    this.required = false,
    this.validator,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.fillColor,
    this.borderColor,
    this.borderRadius = 12.0,
    this.contentPadding,
  });

  /// Creates a password input field with visibility toggle.
  ///
  /// Pre-configured with:
  /// - Icon: Icons.lock_outline as prefix
  /// - InputType: TextInputType.visiblePassword
  /// - Suffix: IconButton for visibility toggle
  /// - Obscure text when not visible
  ///
  /// [controller] must not be null.
  /// [labelText] must not be null. Software development
  /// [isPasswordVisible] controls text visibility.
  /// [onToggleVisibility] called when visibility button is pressed.
  factory CustomTextField.password({
    required TextEditingController controller,
    required String labelText,
    required bool isPasswordVisible,
    required VoidCallback onToggleVisibility,
    String? hintText,
    bool required = false,
  }) {
    return CustomTextField(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      obscureText: !isPasswordVisible,
      keyboardType: TextInputType.visiblePassword,
      required: required,
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        icon: Icon(
          isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey.shade600,
        ),
        onPressed: onToggleVisibility,
      ),
    );
  }

  /// Creates an email input field with email icon and appropriate keyboard.
  ///
  /// Pre-configured with:
  /// - Label: 'Email' (default)
  /// - Hint: 'Nhập email của bạn' (default)
  /// - Icon: Icons.email_outlined as prefix
  /// - InputType: TextInputType.emailAddress for email keyboard
  ///
  /// [controller] must not be null.
  factory CustomTextField.email({
    required TextEditingController controller,
    String? labelText,
    String? hintText,
    bool required = false,
  }) {
    return CustomTextField(
      controller: controller,
      labelText: labelText ?? 'Email',
      hintText: hintText ?? 'Nhập email của bạn',
      keyboardType: TextInputType.emailAddress,
      required: required,
      prefixIcon: const Icon(Icons.email_outlined),
    );
  }

  /// Creates a username input field with person icon.
  ///
  /// Pre-configured with:
  /// - Label: 'Tên đăng nhập' (default)
  /// - Hint: 'Nhập tên đăng nhập' (default)
  /// - Icon: Icons.person_outline as prefix
  /// - InputType: TextInputType.text
  ///
  /// [controller] must not be null.
  factory CustomTextField.username({
    required TextEditingController controller,
    String? labelText,
    String? hintText,
    bool required = false,
  }) {
    return CustomTextField(
      controller: controller,
      labelText: labelText ?? 'Tên đăng nhập',
      hintText: hintText ?? 'Nhập tên đăng nhập',
      keyboardType: TextInputType.text,
      required: required,
      prefixIcon: const Icon(Icons.person_outline),
    );
  }

  /// Creates a multi-line text input field for longer content.
  ///
  /// Pre-configured with:
  /// - maxLines: 3 (default)
  /// - InputType: TextInputType.multiline
  /// - Border radius: 12.0 (default)
  /// - Aligns label with hint for multi-line input
  ///
  /// [controller] must not be null.
  /// [labelText] must not be null.
  factory CustomTextField.multiline({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    int maxLines = 3,
    bool required = false,
  }) {
    return CustomTextField(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      maxLines: maxLines,
      required: required,
      keyboardType: TextInputType.multiline,
    );
  }

  /// Creates a search input field with search icon and rounded design.
  ///
  /// Pre-configured with:
  /// - Hint: 'Tìm kiếm...' (default)
  /// - Icon: Icons.search as prefix
  /// - Border radius: 25.0 for rounded appearance
  /// - Background: Colors.grey[100] fill color
  ///
  /// [controller] must not be null.
  factory CustomTextField.search({
    required TextEditingController controller,
    String? hintText,
    void Function(String)? onChanged,
  }) {
    return CustomTextField(
      controller: controller,
      hintText: hintText ?? 'Tìm kiếm...',
      prefixIcon: const Icon(Icons.search),
      onChanged: onChanged,
      borderRadius: 25.0,
      fillColor: Colors.grey.shade100,
    );
  }

  /// Creates a comment input field optimized for inline comments.
  ///
  /// Pre-configured with:
  /// - Hint: 'Viết bình luận...' (default)
  /// - Border radius: 20.0 for pill-like appearance
  /// - Background: Colors.grey[50] fill color
  /// - Border: Colors.grey[300] border color
  /// - Padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)
  ///
  /// [controller] must not be null.
  factory CustomTextField.comment({
    required TextEditingController controller,
    String? hintText,
    void Function()? onTap,
  }) {
    return CustomTextField(
      controller: controller,
      hintText: hintText ?? 'Viết bình luận...',
      borderRadius: 20.0,
      fillColor: Colors.grey.shade50,
      borderColor: Colors.grey.shade300,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      onTap: onTap,
    );
  }

  /// Builds the CustomTextField widget.
  ///
  /// Returns a TextFormField with comprehensive input decoration and validation.
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: required && labelText != null ? '$labelText *' : labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelStyle: TextStyle(color: Colors.grey.shade600),
        hintStyle: TextStyle(color: Colors.grey.shade500),
        filled: true,
        fillColor: fillColor ?? Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor ?? Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor ?? Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        alignLabelWithHint: maxLines > 1,
      ),
    );
  }
}
