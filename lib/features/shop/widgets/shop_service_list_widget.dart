import 'package:flutter/material.dart';
import 'package:myapp/mock_data/shop_mock.dart';
import 'package:myapp/shared/widgets/common/card_item.dart';
import 'package:myapp/shared/widgets/common/notification.dart';

class ShopServiceListWidget extends StatelessWidget {
  final double paddingResponsive;
  const ShopServiceListWidget({super.key, required this.paddingResponsive});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 91,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: paddingResponsive,
          vertical: 8,
        ),
        children: services.map((service) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                // Handle shop tap
              },
              child: SizedBox(
                width: 100,
                child: PetServiceCard(
                  assetIcon: service['icon']!,
                  label: service['label']!,
                  size: 75,
                  onTap: () {
                    NotificationUtils.showNotification(
                      context,
                      'Đã chọn ${service['label']!}',
                    );
                  },
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
