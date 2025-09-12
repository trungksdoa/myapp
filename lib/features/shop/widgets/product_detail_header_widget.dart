import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ProductDetailHeaderWidget extends StatelessWidget {
  final double padding;
  final VoidCallback? onBackPressed;
  final VoidCallback? onFavoritePressed;

  const ProductDetailHeaderWidget({
    super.key,
    required this.padding,
    this.onBackPressed,
    this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onBackPressed,
            icon: const Icon(Ionicons.arrow_back, color: Colors.black),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shadowColor: Colors.black12,
              elevation: 2,
            ),
          ),
          IconButton(
            onPressed:
                onFavoritePressed ??
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã thêm vào yêu thích')),
                  );
                },
            icon: const Icon(Ionicons.heart_outline, color: Colors.black),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shadowColor: Colors.black12,
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }
}
