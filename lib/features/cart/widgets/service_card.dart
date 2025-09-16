import 'package:flutter/material.dart';
import 'package:flutter_cart/model/cart_model.dart';
import 'package:myapp/core/currency_format.dart';
import 'package:myapp/features/shop/logic/shop_logic.dart';
import 'package:myapp/shared/widgets/common/app_spacing.dart';
import 'package:provider/provider.dart';

class ServiceCard extends StatelessWidget {
  final CartModel cartItem;
  final CartService cartService;

  const ServiceCard({
    super.key,
    required this.cartItem,
    required this.cartService,
  });

  @override
  Widget build(BuildContext context) {
    // Extract service information from productMeta
    final services =
        cartItem.productMeta?['services'] as Map<String, dynamic>? ?? {};
    final note = services['note'] as String?;
    final dateTimeStr = services['dateTime'] as String?;

    // Parse datetime
    DateTime? serviceDateTime;
    if (dateTimeStr != null) {
      try {
        serviceDateTime = DateTime.parse(dateTimeStr);
      } catch (e) {
        serviceDateTime = null;
      }
    }

    final product = cartService.getProductFromId(cartItem.productId);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service header with image and basic info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service image
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                  image: DecorationImage(
                    image: AssetImage(
                      cartService.getProductImage(cartItem.productId),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              AppSpacing.horizontal(12),

              // Service details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service name
                    Text(
                      product.productName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    AppSpacing.vertical(4),

                    // Service category badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Dịch vụ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Price and quantity controls
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Price
                  Text(
                    Currency.formatVND(product.productDetail!.price),
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  AppSpacing.vertical(8),

                  // Quantity controls
                  Selector<CartService, int>(
                    selector: (context, cartService) =>
                        cartService.getItemQuantity(cartItem.productId),
                    builder: (context, quantity, child) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              if (quantity <= 1) {
                                cartService.removeItemFromCart(cartItem);
                                return;
                              }
                              cartService.updateQuantity(
                                cartItem,
                                quantity - 1,
                              );
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Icon(
                                Icons.remove,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          AppSpacing.horizontal(8),
                          Text(
                            '$quantity',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          AppSpacing.horizontal(8),
                          InkWell(
                            onTap: () {
                              cartService.updateQuantity(
                                cartItem,
                                quantity + 1,
                              );
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          AppSpacing.vertical(12),

          // Service details section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Appointment time
                if (serviceDateTime != null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.orange.shade600,
                      ),
                      AppSpacing.horizontal(8),
                      Text(
                        'Thời gian hẹn:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vertical(4),
                  Text(
                    '${serviceDateTime.day}/${serviceDateTime.month}/${serviceDateTime.year} - ${serviceDateTime.hour}:${serviceDateTime.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],

                // Note section
                if (note != null && note.isNotEmpty) ...[
                  if (serviceDateTime != null) AppSpacing.vertical(12),
                  Row(
                    children: [
                      Icon(Icons.note, size: 16, color: Colors.blue.shade600),
                      AppSpacing.horizontal(8),
                      Text(
                        'Ghi chú:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vertical(4),
                  Text(note, style: const TextStyle(fontSize: 14)),
                ],

                // If no service details
                if (serviceDateTime == null &&
                    (note == null || note.isEmpty)) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.grey.shade500,
                      ),
                      AppSpacing.horizontal(8),
                      Text(
                        'Chưa có thông tin đặt lịch',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
