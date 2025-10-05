import 'package:flutter/material.dart';
import 'package:myapp/features/shop/service/interface/service-interface.dart';
import 'package:myapp/features/shop/widgets/service_card_widget.dart';

import 'package:myapp/shared/model/shop.dart';

class ServiceGridWidget extends StatelessWidget {
  final List<Service> services;
  final Function(Service) onServiceTap;
  final double paddingResponsive;
  final List<Shop>? shops;

  const ServiceGridWidget({
    super.key,
    required this.services,
    required this.onServiceTap,
    required this.paddingResponsive,
    this.shops,
  });

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: paddingResponsive),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          // Find shop by shopId from service
          Shop? shop;
          if (shops != null && shops!.isNotEmpty) {
            try {
              shop = shops!.firstWhere((s) => s.shopId == service.shopId);
            } catch (e) {
              // If not found, use first shop as fallback
              shop = shops!.first;
            }
          }

          return ServiceCard(
            service: service,
            onTap: () => onServiceTap(service),
            shop: shop,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Không tìm thấy dịch vụ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hiện tại không có dịch vụ nào',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
