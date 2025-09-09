import 'package:flutter/material.dart';

/// A highly customizable text widget with predefined factory constructors
/// for consistent typography across the application. Provides easy-to-use
/// methods for common text styles like titles, subtitles, body text, etc.
///
/// This widget extends Text with additional styling options and ensures
/// consistent text appearance throughout the app.
class CustomText extends StatelessWidget {
  /// The text content to display.
  final String text;

  /// Optional font size. If null, uses the default size.
  final double? fontSize;

  /// Optional font weight. If null, uses the default weight.
  final FontWeight? fontWeight;

  /// Optional text color. If null, uses the default color.
  final Color? color;

  /// Optional text alignment. If null, uses default alignment.
  final TextAlign? textAlign;

  /// Optional maximum number of lines. If null, text can wrap to unlimited lines.
  final int? maxLines;

  /// Optional text overflow behavior. Automatically set to ellipsis if maxLines is specified.
  final TextOverflow? overflow;

  /// Optional font family. If null, uses the default font family.
  final String? fontFamily;

  /// Optional line height. If null, uses the default line height.
  final double? height;

  /// Creates a customizable text widget.
  ///
  /// [text] must not be null and represents the text content to display.
  ///
  /// Example:
  /// ```dart
  /// const CustomText(
  ///   text: 'Hello World',
  ///   fontSize: 16.0,
  ///   fontWeight: FontWeight.bold,
  ///   color: Colors.blue,
  ///   maxLines: 2,
  /// )
  /// ```
  const CustomText({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontFamily,
    this.height,
  });

  /// Creates a CustomText styled as a title.
  ///
  /// Pre-configured with large font size and bold weight for headings and titles.
  ///
  /// [text] must not be null and represents the title content.
  factory CustomText.title({
    required String text,
    Color? color,
    TextAlign? textAlign,
    double? fontSize,
  }) {
    return CustomText(
      text: text,
      fontSize: fontSize ?? 24,
      fontWeight: FontWeight.bold,
      color: color ?? Colors.black87,
      textAlign: textAlign,
    );
  }

  /// Creates a CustomText styled as a subtitle.
  ///
  /// Pre-configured with fontSize: 18, fontWeight: FontWeight.w600 for secondary headings.
  /// Automatically uses Colors.black87 if no color is specified.
  ///
  /// [text] must not be null and represents the subtitle content.
  factory CustomText.subtitle({
    required String text,
    Color? color,
    TextAlign? textAlign,
  }) {
    return CustomText(
      text: text,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: color ?? Colors.black87,
      textAlign: textAlign,
    );
  }

  /// Creates a CustomText styled for body content.
  ///
  /// Pre-configured with fontSize: 16, fontWeight: FontWeight.normal for general text.
  /// Automatically uses Colors.black87 if no color is specified.
  /// Supports ellipsis overflow when maxLines is specified.
  ///
  /// [text] must not be null and represents the body content.
  factory CustomText.body({
    required String text,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
  }) {
    return CustomText(
      text: text,
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: color ?? Colors.black87,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
    );
  }

  /// Creates a CustomText styled as a caption or hint.
  ///
  /// Pre-configured with fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey[600].
  /// Supports ellipsis overflow when maxLines is specified.
  ///
  /// [text] must not be null and represents the caption content.
  factory CustomText.caption({
    required String text,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
  }) {
    return CustomText(
      text: text,
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: color ?? Colors.grey.shade600,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
    );
  }

  /// Creates a CustomText styled with small font size.
  ///
  /// Pre-configured with fontSize: 12, fontWeight: FontWeight.normal, color: Colors.grey[600].
  /// Supports ellipsis overflow when maxLines is specified.
  ///
  /// [text] must not be null and represents the small text content.
  factory CustomText.small({
    required String text,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
  }) {
    return CustomText(
      text: text,
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: color ?? Colors.grey.shade600,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
    );
  }

  /// Creates a CustomText styled as a form label.
  ///
  /// Pre-configured with fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[700].
  /// Automatically appends asterisk (*) for required fields.
  ///
  /// [text] must not be null and represents the label content.
  factory CustomText.label({
    required String text,
    Color? color,
    bool required = false,
  }) {
    return CustomText(
      text: required ? '$text *' : text,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: color ?? Colors.grey.shade700,
    );
  }

  /// Creates a CustomText styled for button text.
  ///
  /// Pre-configured with fontSize: 16, fontWeight: FontWeight.bold for button labels.
  /// Automatically uses Colors.white if no color is specified.
  ///
  /// [text] must not be null and represents the button content.
  factory CustomText.button({required String text, Color? color}) {
    return CustomText(
      text: text,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: color ?? Colors.white,
    );
  }

  /// Creates a CustomText styled for app bar titles.
  ///
  /// Pre-configured with fontSize: 18, fontWeight: FontWeight.w600 for navigation titles.
  /// Automatically uses Colors.black if no color is specified.
  ///
  /// [text] must not be null and represents the app bar title content.
  factory CustomText.appBarTitle({required String text, Color? color}) {
    return CustomText(
      text: text,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: color ?? Colors.black,
    );
  }

  /// Creates a CustomText styled for error messages.
  ///
  /// Pre-configured with fontSize: 14, fontWeight: FontWeight.normal, color: Colors.red[600]
  /// for displaying validation errors and error states.
  ///
  /// [text] must not be null and represents the error content.
  factory CustomText.error({required String text, TextAlign? textAlign}) {
    return CustomText(
      text: text,
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.red.shade600,
      textAlign: textAlign,
    );
  }

  /// Creates a CustomText styled for success messages.
  ///
  /// Pre-configured with fontSize: 14, fontWeight: FontWeight.normal, color: Colors.green[600]
  /// for displaying success confirmations and positive feedback.
  ///
  /// [text] must not be null and represents the success content.
  factory CustomText.success({required String text, TextAlign? textAlign}) {
    return CustomText(
      text: text,
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.green.shade600,
      textAlign: textAlign,
    );
  }

  /// Builds the CustomText widget.
  ///
  /// Returns a Text widget with the specified styling applied.
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontFamily: fontFamily,
        height: height,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
