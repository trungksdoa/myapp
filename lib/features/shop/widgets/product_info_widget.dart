import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:myapp/core/currency_format.dart';
import 'package:myapp/route/navigate_helper.dart';
import 'package:myapp/shared/model/product.dart';
import 'package:myapp/shared/widgets/common/app_spacing.dart';

class ProductInfoWidget extends StatelessWidget {
  final Product product;
  final double padding;
  final double fontSize;
  final String? category;

  const ProductInfoWidget({
    super.key,
    required this.product,
    required this.padding,
    required this.fontSize,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        product.productName,
                        style: TextStyle(
                          fontSize: fontSize * 1.3,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey[900],
                          height: 1.3,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    if (product.category.toLowerCase() == 'care') ...[
                      AppSpacing.horizontal(8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.purple[50],
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.purple.shade200,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Ionicons.time_outline,
                              size: fontSize * 0.8,
                              color: Colors.purple[700],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '60 phút',
                              style: TextStyle(
                                fontSize: fontSize * 0.8,
                                color: Colors.purple[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.vertical(12),
          // Shop info section
          InkWell(
            onTap: () {
              NavigateHelper.goToShopDetailScreen(
                context,
                shopId: product.shopId,
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: padding * 0.4,
                vertical: padding * 0.3,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  // Shop avatar
                  Container(
                    width: fontSize * 2,
                    height: fontSize * 2,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue[200]!, width: 1),
                    ),
                    child: Center(
                      child: Icon(
                        Ionicons.storefront_outline,
                        color: Colors.blue[700],
                        size: fontSize * 1.2,
                      ),
                    ),
                  ),
                  AppSpacing.horizontal(12),
                  // Shop info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'PetShop Việt Nam',
                              style: TextStyle(
                                fontSize: fontSize * 0.9,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[900],
                              ),
                            ),
                            AppSpacing.horizontal(4),
                            Icon(
                              Ionicons.shield_checkmark,
                              color: Colors.blue[600],
                              size: fontSize * 0.9,
                            ),
                          ],
                        ),
                        AppSpacing.vertical(2),
                        Text(
                          'Online 12 phút trước',
                          style: TextStyle(
                            fontSize: fontSize * 0.75,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // View shop button
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: padding * 0.4,
                      vertical: padding * 0.2,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Xem Shop',
                      style: TextStyle(
                        fontSize: fontSize * 0.75,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.vertical(12),
          // Price and stock section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    Currency.formatVND(product.productDetail?.price ?? 0),
                    style: TextStyle(
                      fontSize: fontSize * 1.2,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).primaryColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                  AppSpacing.horizontal(12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.green.shade200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Ionicons.checkmark_circle,
                          size: fontSize * 0.8,
                          color: Colors.green[700],
                        ),
                        const SizedBox(width: 4),
                        if (product.category.toLowerCase() == 'care') ...[
                          Text(
                            'Đang cung cấp',
                            style: TextStyle(
                              fontSize: fontSize * 0.75,
                              color: Colors.green[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ] else ...[
                          Text(
                            'Còn hàng',
                            style: TextStyle(
                              fontSize: fontSize * 0.75,
                              color: Colors.green[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

              // Show service duration for care category
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

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String text,
    required String subtext,
    required double fontSize,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: fontSize * 1.1),
        ),
        AppSpacing.horizontal(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: fontSize * 0.9,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[900],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtext,
                style: TextStyle(
                  fontSize: fontSize * 0.8,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Thông tin chi tiết',
              style: TextStyle(
                fontSize: fontSize * 1.1,
                fontWeight: FontWeight.w700,
                color: Colors.grey[900],
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        AppSpacing.vertical(16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!, width: 1),
          ),
          child: Column(
            children: [
              _buildInfoItem(
                context,
                icon: Ionicons.star,
                iconColor: Colors.orange,
                text: '4.2',
                subtext: '120 đánh giá',
                fontSize: fontSize,
              ),
              AppSpacing.vertical(12),
              _buildInfoItem(
                context,
                icon: Ionicons.location_outline,
                iconColor: Theme.of(context).primaryColor,
                text: 'Giao hàng tận nơi',
                subtext: '2-3 ngày',
                fontSize: fontSize,
              ),
              AppSpacing.vertical(12),
              _buildInfoItem(
                context,
                icon: Ionicons.shield_checkmark_outline,
                iconColor: Colors.green[700]!,
                text: 'Bảo hành chính hãng',
                subtext: '12 tháng',
                fontSize: fontSize,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
