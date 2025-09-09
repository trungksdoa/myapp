import 'package:flutter/material.dart';

/// A customizable container widget with shadow and styling options.
/// Provides predefined factory constructors for common use cases like blog cards,
/// group cards, and comments.
///
/// The container supports various styling options including background colors,
/// gradients, borders, shadows, and rounded corners.
class BoxContainerShadow extends StatelessWidget {
  /// The child widget to be contained within this box.
  final Widget child;

  final double? height;

  /// The default padding value applied around the child.
  /// This is used when [customPadding] is not specified.
  final double padding;

  /// The default margin value applied around the container.
  /// This is used when [customMargin] is not specified.
  final double margin;

  /// The background color of the container.
  /// Ignored if [gradient] is provided.
  final Color backgroundColor;

  /// The border radius of the container's corners.
  final double borderRadius;

  /// Custom border to apply to the container.
  final BoxBorder? border;

  /// Gradient to apply as the background instead of solid color.
  final Gradient? gradient;

  /// Custom shadows to apply to the container.
  /// If null, default shadow will be used when [hasShadow] is true.
  final List<BoxShadow>? customShadow;

  /// Whether to apply shadow to the container.
  final bool hasShadow;

  /// Custom padding to override the default [padding] value.
  final EdgeInsetsGeometry? customPadding;

  /// Custom margin to override the default [margin] value.
  final EdgeInsetsGeometry? customMargin;

  /// Creates a customizable container box with shadow.
  ///
  /// [child] must not be null.
  ///
  /// Example:
  /// ```dart
  /// BoxContainerShadow(
  ///   child: Text('Hello World'),
  ///   padding: 16.0,
  ///   margin: 8.0,
  ///   backgroundColor: Colors.blue,
  ///   borderRadius: 8.0,
  /// )
  /// ```
  const BoxContainerShadow({
    super.key,
    required this.child,
    this.padding = 20.0,
    this.margin = 0.0,
    this.backgroundColor = Colors.white,
    this.borderRadius = 12.0,
    this.border,
    this.gradient,
    this.customShadow,
    this.hasShadow = true,
    this.customPadding,
    this.customMargin,
    this.height,
  });

  /// Creates a BoxContainerShadow styled as a blog card.
  ///
  /// Uses a subtle teal gradient, teal border, and enhanced shadow
  /// specifically designed for blog content presentation.
  ///
  /// [child] must not be null.
  factory BoxContainerShadow.blogCard({
    required Widget child,
    double padding = 0.0,
    double margin = 12.0,
    double borderRadius = 16.0,
  }) {
    return BoxContainerShadow(
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      gradient: LinearGradient(
        colors: [Colors.white, Colors.teal.shade50],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(color: Colors.teal.withValues(alpha: 0.2), width: 1),
      customShadow: [
        BoxShadow(
          color: Colors.teal.withValues(alpha: 0.15),
          spreadRadius: 2,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
      child: child,
    );
  }

  /// Creates a BoxContainerShadow styled for group card.
  ///
  /// Pre-configured with:
  /// - Shadow: BoxShadow(color: Colors.grey[200], spreadRadius: 1, blurRadius: 3)
  /// - Elevation: minimal with offset (0, 2)
  ///
  /// [child] must not be null.
  /// [backgroundColor] must not be null and sets the custom background.
  factory BoxContainerShadow.groupCard({
    required Widget child,
    required Color backgroundColor,
    double padding = 0.0,
    double margin = 12.0,
    double borderRadius = 12.0,
    EdgeInsetsGeometry? customMargin,
  }) {
    return BoxContainerShadow(
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      customMargin: customMargin,
      customShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.2),
          spreadRadius: 1,
          blurRadius: 3,
          offset: const Offset(0, 2),
        ),
      ],
      child: child,
    );
  }

  /// Creates a BoxContainerShadow styled for comment display.
  ///
  /// Pre-configured with:
  /// - Gradient: LinearGradient(colors: [Colors.white, Colors.teal.shade50])
  /// - Border: Border.all(color: Colors.teal[150], width: 1)
  /// - Shadow: BoxShadow(color: Colors.teal[50], blurRadius: 4)
  /// - Margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8)
  ///
  /// [child] must not be null.
  factory BoxContainerShadow.comment({
    required Widget child,
    double padding = 12.0,
    EdgeInsetsGeometry? margin,
  }) {
    return BoxContainerShadow(
      padding: padding,
      customMargin:
          margin ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: 12.0,
      gradient: LinearGradient(
        colors: [Colors.white, Colors.teal.shade50],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(color: Colors.teal.withValues(alpha: 0.15), width: 1),
      customShadow: [
        BoxShadow(
          color: Colors.teal.withValues(alpha: 0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
      child: child,
    );
  }

  /// Build the BoxContainerShadow widget.
  ///
  /// Returns a Container with the specified styling applied.
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: customPadding ?? EdgeInsets.all(padding),
      margin: customMargin ?? EdgeInsets.all(margin),
      decoration: BoxDecoration(
        color: gradient == null ? backgroundColor : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        boxShadow: hasShadow
            ? (customShadow ??
                  [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ])
            : null,
      ),
      child: child,
    );
  }
}
