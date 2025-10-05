// lib/features/shop/widgets/service_card_widget.dart

import 'package:flutter/material.dart';
import 'package:myapp/features/shop/service/interface/service-interface.dart';
import 'package:myapp/shared/model/shop.dart';
import 'package:myapp/shared/widgets/common/app_spacing.dart';

class ServiceCard extends StatelessWidget {
  final Service service;
  final VoidCallback onTap;
  final Shop? shop;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onTap,
    this.shop,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Service Image với overlay gradient
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      gradient: LinearGradient(
                        colors: [Colors.blue[100]!, Colors.blue[300]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: (service.imgUrl.isNotEmpty)
                        ? ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Image.network(
                              service.imgUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildDefaultIcon(),
                            ),
                          )
                        : _buildDefaultIcon(),
                  ),
                ],
              ),
            ),

            // ✅ Service & Shop Info
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service Name
                    Text(
                      service.name ?? 'Dịch vụ',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    AppSpacing.vertical(6),

                    // ✅ Shop Info Section
                    if (shop != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.blue[100]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Shop name với icon
                            Row(
                              children: [
                                Icon(
                                  Icons.store,
                                  size: 12,
                                  color: Colors.blue[700],
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    shop!.shopName,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue[700],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),

                            // Shop owner và working days
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 10,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    shop!.owner,
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  size: 10,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    shop!.workingDays,
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      AppSpacing.vertical(8),
                    ] else ...[
                      // Fallback khi không có shop info
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 12,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Thông tin shop đang cập nhật',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[500],
                                  fontStyle: FontStyle.italic,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),

                      AppSpacing.vertical(8),
                    ],

                    const Spacer(),

                    // ✅ Bottom Action Button
                    Container(
                      width: double.infinity,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue[400]!, Colors.blue[600]!],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onTap,
                          borderRadius: BorderRadius.circular(8),
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.visibility,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Xem chi tiết',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultIcon() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[100]!, Colors.blue[300]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Icon(_getServiceIcon(), size: 40, color: Colors.blue[600]),
    );
  }

  IconData _getServiceIcon() {
    final serviceName = (service.name ?? '').toLowerCase();

    if (serviceName.contains('spa') || serviceName.contains('tắm')) {
      return Icons.spa;
    } else if (serviceName.contains('khám') || serviceName.contains('bác sĩ')) {
      return Icons.medical_services;
    } else if (serviceName.contains('khách sạn') ||
        serviceName.contains('trông')) {
      return Icons.hotel;
    } else if (serviceName.contains('huấn luyện') ||
        serviceName.contains('training')) {
      return Icons.school;
    } else if (serviceName.contains('cắt') || serviceName.contains('tỉa')) {
      return Icons.content_cut;
    } else {
      return Icons.pets; // Default icon
    }
  }
}
