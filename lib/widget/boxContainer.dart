import 'package:flutter/material.dart';

class BoxContainerShadow extends StatelessWidget {
  final Widget child;
  final double padding;
  final double margin;
  final Color backgroundColor;
  final double borderRadius;
  final BoxBorder? border;
  final Gradient? gradient;
  final List<BoxShadow>? customShadow;
  final bool hasShadow;
  final EdgeInsetsGeometry? customPadding;
  final EdgeInsetsGeometry? customMargin;

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
  });

  // Factory constructor cho blog card style
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

  // Factory constructor cho group card style
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

  // Factory constructor cho comment style
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

  @override
  Widget build(BuildContext context) {
    return Container(
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
