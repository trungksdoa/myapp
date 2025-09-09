import 'package:flutter/material.dart';

/// A highly customizable card widget with predefined factory constructors
/// for common UI patterns like blog cards, service cards, chat messages, etc.
///
/// Supports advanced styling options including gradients, custom shadows,
/// borders, and interactive capabilities through onTap callbacks.
class CustomCard extends StatelessWidget {
  /// The child widget to be contained within the card.
  final Widget child;

  /// The margin around the card container.
  final EdgeInsetsGeometry? margin;

  /// The padding inside the card container.
  final EdgeInsetsGeometry? padding;

  /// The border radius of the card's corners.
  final double borderRadius;

  /// The background color of the card.
  /// Ignored if gradient is provided.
  final Color? backgroundColor;

  /// The elevation (shadow intensity) of the card.
  final double elevation;

  /// The color of the card's shadow.
  final Color? shadowColor;

  /// Custom border to apply to the card.
  final Border? border;

  /// Gradient to use as background instead of solid color.
  final Gradient? gradient;

  /// Callback function executed when the card is tapped.
  /// Makes the card interactive when provided.
  final VoidCallback? onTap;

  /// Optional fixed width for the card.
  final double? width;

  /// Optional fixed height for the card.
  final double? height;

  /// Creates a customizable card widget.
  ///
  /// [child] must not be null and represents the content of the card.
  ///
  /// Example:
  /// ```dart
  /// CustomCard(
  ///   child: Text('Card Content'),
  ///   margin: EdgeInsets.all(16),
  ///   padding: EdgeInsets.all(24),
  ///   borderRadius: 20.0,
  ///   elevation: 8.0,
  ///   backgroundColor: Colors.blue,
  ///   onTap: () => print('Card tapped'),
  /// )
  /// ```
  const CustomCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.borderRadius = 16.0,
    this.backgroundColor,
    this.elevation = 6.0,
    this.shadowColor,
    this.border,
    this.gradient,
    this.onTap,
    this.width,
    this.height,
  });

  /// Creates a CustomCard styled as a blog post card.
  ///
  /// Pre-configured with teal gradient, enhanced shadows, and appropriate spacing
  /// for displaying blog content with an attractive visual hierarchy.
  ///
  /// [child] must not be null and represents the blog content.
  factory CustomCard.blog({
    required Widget child,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
  }) {
    return CustomCard(
      margin: margin ?? const EdgeInsets.all(12),
      padding: EdgeInsets.zero,
      borderRadius: 16.0,
      gradient: LinearGradient(
        colors: [Colors.white, Colors.teal.shade50],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(color: Colors.teal.withValues(alpha: 0.2), width: 1),
      shadowColor: Colors.teal.withValues(alpha: 0.15),
      elevation: 8.0,
      onTap: onTap,
      child: child,
    );
  }

  /// Creates a CustomCard styled for service/product display.
  ///
  /// Pre-configured with standard white background and moderate shadows,
  /// optimized for service listings and product cards in grids.
  ///
  /// [child] must not be null and represents the service content.
  factory CustomCard.service({required Widget child, VoidCallback? onTap}) {
    return CustomCard(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      borderRadius: 12.0,
      backgroundColor: Colors.white,
      elevation: 4.0,
      shadowColor: Colors.grey.withValues(alpha: 0.2),
      onTap: onTap,
      child: child,
    );
  }

  /// Creates a CustomCard styled for group/category display.
  ///
  /// Allows custom background color while maintaining consistent styling
  /// for group-related content and navigation items.
  ///
  /// [child] must not be null and represents the group content.
  /// [backgroundColor] must not be null and defines the card's background.
  factory CustomCard.group({
    required Widget child,
    required Color backgroundColor,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
  }) {
    return CustomCard(
      margin: margin ?? const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.zero,
      borderRadius: 12.0,
      backgroundColor: backgroundColor,
      elevation: 3.0,
      shadowColor: Colors.grey.withValues(alpha: 0.2),
      onTap: onTap,
      child: child,
    );
  }

  /// Creates a CustomCard styled for chat messages.
  ///
  /// Automatically adjusts styling based on whether the message is from user or others,
  /// using blue for user messages and white for others.
  ///
  /// [child] must not be null and represents the message content.
  /// [isUser] determines the message sender and styling.
  factory CustomCard.chatMessage({
    required Widget child,
    required bool isUser,
    EdgeInsetsGeometry? margin,
  }) {
    return CustomCard(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.all(12),
      borderRadius: 16.0,
      backgroundColor: isUser ? Colors.blue : Colors.white,
      elevation: 2.0,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      child: child,
    );
  }

  /// Creates a CustomCard styled for informational content.
  ///
  /// Uses light blue background with borders, perfect for alerts, notices,
  /// and important information display.
  ///
  /// [child] must not be null and represents the informational content.
  factory CustomCard.info({
    required Widget child,
    Color? backgroundColor,
    EdgeInsetsGeometry? margin,
  }) {
    return CustomCard(
      margin: margin ?? const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      borderRadius: 12.0,
      backgroundColor: backgroundColor ?? Colors.blue.shade50,
      border: Border.all(color: Colors.blue.shade200),
      elevation: 0.0,
      child: child,
    );
  }

  /// Creates a CustomCard styled for user profiles.
  ///
  /// Pre-configured with enhanced elevation and spacing for displaying
  /// user information and profile-related content.
  ///
  /// [child] must not be null and represents the profile content.
  factory CustomCard.profile({
    required Widget child,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    double? padding,
  }) {
    return CustomCard(
      margin: margin ?? const EdgeInsets.all(16),
      padding: EdgeInsets.all(padding ?? 16),
      borderRadius: 16.0,
      backgroundColor: Colors.white,
      elevation: 8.0,
      shadowColor: Colors.grey.withValues(alpha: 0.2),
      onTap: onTap,
      child: child,
    );
  }

  /// Creates a CustomCard styled for comments.
  ///
  /// Uses subtle teal gradient with minimal shadows and borders,
  /// optimized for comment threads and user interactions.
  ///
  /// [child] must not be null and represents the comment content.
  factory CustomCard.comment({
    required Widget child,
    EdgeInsetsGeometry? margin,
  }) {
    return CustomCard(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(12),
      borderRadius: 12.0,
      gradient: LinearGradient(
        colors: [Colors.white, Colors.teal.shade50],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(color: Colors.teal.withValues(alpha: 0.15), width: 1),
      elevation: 2.0,
      shadowColor: Colors.teal.withValues(alpha: 0.05),
      child: child,
    );
  }

  /// Builds the CustomCard widget.
  ///
  /// Returns a Container with Card-like styling, including shadows,
  /// borders, gradients, and interactive capabilities through InkWell.
  @override
  Widget build(BuildContext context) {
    Widget cardChild = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: gradient == null ? backgroundColor : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: shadowColor ?? Colors.grey.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: elevation,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(borderRadius),
            child: Padding(
              padding: padding ?? const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ),
      ),
    );

    if (margin != null) {
      cardChild = Padding(padding: margin!, child: cardChild);
    }

    return cardChild;
  }
}
