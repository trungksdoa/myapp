import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/core/utils/device_size.dart';
import 'package:myapp/features/shop/widgets/product_bottom_bar_widget.dart';
import 'package:myapp/features/shop/widgets/product_detail_header_widget.dart';
import 'package:myapp/features/shop/widgets/product_info_widget.dart';
import 'package:myapp/features/shop/widgets/product_main_image_widget.dart';
import 'package:myapp/features/shop/widgets/product_thumbnail_list_widget.dart';
import 'package:myapp/mock_data/shop_mock.dart';
import 'package:myapp/shared/model/product.dart';
import 'package:myapp/shared/widgets/common/notification.dart';

class DetailProductScreen extends StatefulWidget {
  final String? productId;

  const DetailProductScreen({super.key, this.productId});

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  late Product _product;
  int _currentImageIndex = 0;

  final List<String> _productImages = [
    'https://res.cloudinary.com/dc1piksu8/image/upload/v1756239589/9725.jpg',
    'https://res.cloudinary.com/dc1piksu8/image/upload/v1756239589/9725.jpg',
    'https://res.cloudinary.com/dc1piksu8/image/upload/v1756239589/9725.jpg',
    'https://res.cloudinary.com/dc1piksu8/image/upload/v1756239589/9725.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  void _loadProduct() {
    if (widget.productId != null) {
      try {
        _product = mockProducts.firstWhere(
          (product) => product.productId == widget.productId,
        );
      } catch (e) {
        _product = mockProducts.first;
      }
    } else {
      _product = mockProducts.first;
    }
  }

  void _onImageSelected(int index) {
    setState(() {
      _currentImageIndex = index;
    });
  }

  void _onAddToCart() {
    NotificationUtils.showNotificationWithAction(
      context,
      'Đã thêm ${_product.productName} vào giỏ hàng',
      actionLabel: "Xem ngay",
      onPressed: () {},
    );
  }

  void _onBuyNow() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng mua ngay đang phát triển')),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double paddingResponsive = DeviceSize.getResponsivePadding(width);
    double fontSize = DeviceSize.getResponsiveFontSize(width);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            ProductDetailHeaderWidget(
              padding: paddingResponsive,
              onBackPressed: () => context.pop(),
            ),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main image
                    ProductMainImageWidget(
                      width: width,
                      height: height * 0.4,
                      imageUrl: _productImages[_currentImageIndex],
                      currentIndex: _currentImageIndex,
                      totalImages: _productImages.length,
                    ),

                    // Thumbnail list
                    ProductThumbnailListWidget(
                      images: _productImages,
                      currentIndex: _currentImageIndex,
                      padding: paddingResponsive,
                      onImageSelected: _onImageSelected,
                    ),

                    // Product info
                    ProductInfoWidget(
                      product: _product,
                      padding: paddingResponsive,
                      fontSize: fontSize,
                    ),
                  ],
                ),
              ),
            ),

            // Bottom bar
            ProductBottomBarWidget(
              padding: paddingResponsive,
              fontSize: fontSize,
              onAddToCart: _onAddToCart,
              onBuyNow: _onBuyNow,
            ),
          ],
        ),
      ),
    );
  }
}
