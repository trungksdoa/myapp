import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:myapp/core/currency_format.dart';
import 'package:myapp/shared/model/product.dart';
import 'package:myapp/shared/widgets/common/app_spacing.dart';

class ProductInfoWidget extends StatelessWidget {
  final Product product;
  final double padding;
  final double fontSize;

  const ProductInfoWidget({
    super.key,
    required this.product,
    required this.padding,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.productName,
            style: TextStyle(
              fontSize: fontSize * 1.2,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          AppSpacing.vertical(8),
          Row(
            children: [
              Text(
                Currency.formatVND(product.productDetail?.price ?? 0),
                style: TextStyle(
                  fontSize: fontSize * 1.1,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              AppSpacing.horizontal(8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Còn hàng',
                  style: TextStyle(
                    fontSize: fontSize * 0.7,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.vertical(16),
          Text(
            'Mô tả sản phẩm',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          AppSpacing.vertical(8),
          Text(
            product.description,
            style: TextStyle(
              fontSize: fontSize * 0.85,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          AppSpacing.vertical(16),
          ProductAdditionalInfoWidget(fontSize: fontSize),
        ],
      ),
    );
  }
}

class ProductAdditionalInfoWidget extends StatelessWidget {
  final double fontSize;

  const ProductAdditionalInfoWidget({super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thông tin bổ sung',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        AppSpacing.vertical(8),
        Row(
          children: [
            Icon(Ionicons.star, color: Colors.orange, size: fontSize * 0.8),
            AppSpacing.horizontal(4),
            Text(
              '4.2 (120 đánh giá)',
              style: TextStyle(
                fontSize: fontSize * 0.8,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        AppSpacing.vertical(4),
        Row(
          children: [
            Icon(
              Ionicons.location_outline,
              color: Colors.grey,
              size: fontSize * 0.8,
            ),
            AppSpacing.horizontal(4),
            Text(
              'Giao hàng tận nơi',
              style: TextStyle(
                fontSize: fontSize * 0.8,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        AppSpacing.vertical(4),
        Row(
          children: [
            Icon(
              Ionicons.shield_checkmark_outline,
              color: Colors.grey,
              size: fontSize * 0.8,
            ),
            AppSpacing.horizontal(4),
            Text(
              'Bảo hành 12 tháng',
              style: TextStyle(
                fontSize: fontSize * 0.8,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
