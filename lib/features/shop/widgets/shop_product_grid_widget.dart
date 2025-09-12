import 'package:flutter/material.dart';
import 'package:myapp/core/currency_format.dart';
import 'package:myapp/features/shop/logic/shop_logic.dart';
import 'package:myapp/route/navigate_helper.dart';
import 'package:myapp/shared/model/product.dart';
import 'package:provider/provider.dart';
import 'package:myapp/shared/widgets/cards/product_card.dart';

class ShopProductGridWidget extends StatelessWidget {
  final List<Product> productList;
  final Map<String, GlobalKey> productKeys;
  final TextEditingController searchController;
  final double paddingResponsive;

  const ShopProductGridWidget({
    super.key,
    required this.productList,
    required this.productKeys,
    required this.searchController,
    required this.paddingResponsive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(paddingResponsive * 1.5),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 10,
          mainAxisSpacing: 16,
        ),
        itemCount: productList.length,
        itemBuilder: (context, index) {
          final product = productList[index];

          // Search filter
          if (searchController.text.isNotEmpty &&
              !product.productName.toLowerCase().contains(
                searchController.text.toLowerCase(),
              )) {
            return const SizedBox.shrink();
          }

          return ProductCard(
            key: productKeys[product.productId],
            imageUrl:
                "https://res.cloudinary.com/dc1piksu8/image/upload/v1756239589/9725.jpg",
            categoryName: 'Thực phẩm bổ sung cho thú cưng',
            productName: product.productName,
            price: Currency.formatVND(product.productDetail!.price),
            onTap: () {
              NavigateHelper.goToDetailProduct(context, product.productId);
            },

            // Consumer DEEPEST - chỉ cho add to cart action
            onFavoritePressed: () {
              context.read<CartService>().addToCart(product);
            },

            shortDescription: product.description,
            rating: 4.2,
            isAvailable: true,
            cardColor: Colors.white,
            textColor: Colors.black,
            borderRadius: 8.0,
          );
        },
      ),
    );
  }
}
