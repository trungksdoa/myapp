import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:myapp/shared/widgets/common/app_spacing.dart';

class ProductBottomBarWidget extends StatelessWidget {
  final double padding;
  final double fontSize;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const ProductBottomBarWidget({
    super.key,
    required this.padding,
    required this.fontSize,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: (0.1)),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onAddToCart,
              icon: const Icon(Ionicons.bag_add_outline),
              label: const Text('Thêm vào giỏ'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          AppSpacing.horizontal(12),
          Expanded(
            child: OutlinedButton(
              onPressed: onBuyNow,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.blue),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Mua ngay',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: fontSize * 0.9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
