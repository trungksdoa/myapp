import 'package:flutter/material.dart';
import 'package:myapp/mock_data/shop_mock.dart';
import 'package:myapp/shared/widgets/common/notification.dart';

class ShopServiceListWidget extends StatefulWidget {
  final double paddingResponsive;
  final void Function(String? categoryKey)? onServiceTap;
  const ShopServiceListWidget({
    super.key,
    required this.paddingResponsive,
    this.onServiceTap,
  });

  @override
  State<ShopServiceListWidget> createState() => _ShopServiceListWidgetState();
}

class _ShopServiceListWidgetState extends State<ShopServiceListWidget> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 94,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              widget.paddingResponsive,
              4,
              widget.paddingResponsive,
              2,
            ),
            child: Text(
              'Danh mục',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: widget.paddingResponsive,
                vertical: 4,
              ),
              children: [
                // Bỏ phần "All" category
                ...services.map(
                  (service) => _buildServiceCard(
                    service['key'] as String,
                    service['icon']!,
                    service['label']!,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(String categoryKey, String icon, String label) {
    final isSelected = _selectedCategory == categoryKey;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            NotificationUtils.hideCurrentNotification(context);
            // Chỉ set category được chọn, không có logic deselect
            _selectedCategory = categoryKey;
          });
          widget.onServiceTap?.call(_selectedCategory);
          NotificationUtils.showNotification(context, 'Đã chọn $label');
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 58,
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isSelected
                        ? Colors.blue.withValues(alpha: 0.3)
                        : Colors.grey.withValues(alpha: 0.15),
                    width: 0.8,
                  ),
                ),
                child: Image.asset(
                  icon,
                  width: 22,
                  height: 22,
                  color: isSelected ? Colors.blue : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.blue : Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
