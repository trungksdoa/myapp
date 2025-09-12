import 'package:flutter/material.dart';
import 'package:imageflow/imageflow.dart';
import 'package:myapp/core/utils/device_size.dart';
import 'package:ionicons/ionicons.dart';

/// A customizable card widget for displaying product information.
class ProductCard extends StatefulWidget {
  /// The unique identifier of the product.
  final String? id;

  /// The URL of the product image.
  final String? imageUrl;

  /// A short description of the product.
  final String? shortDescription;

  /// The category name of the product.
  final String categoryName;

  /// The name of the product.
  final String productName;

  /// The price of the product.
  final String price;

  /// The currency symbol used for the price.
  final String? currency;

  /// A callback function triggered when the card is tapped.
  final VoidCallback? onTap;

  /// A callback function triggered when the favorite button is pressed.
  final VoidCallback? onFavoritePressed;

  /// Indicates whether the product is available.
  final bool? isAvailable;

  /// The background color of the card.
  final Color cardColor;

  /// The text color used for labels and descriptions.
  final Color textColor;

  /// The border radius of the card.
  final double borderRadius;

  /// The rating of the product (optional).
  final double? rating;

  /// The discount percentage of the product (optional).
  final double? discountPercentage;

  /// The width of the card
  final double? width;

  /// The height of the card
  final double? height;

  /// Bottom text for seller information
  final String? bottomText;

  /// Creates a [ProductCard] widget.
  const ProductCard({
    super.key,
    this.imageUrl,
    required this.categoryName,
    required this.productName,
    required this.price,
    this.currency = '\$',
    this.onTap,
    this.onFavoritePressed,
    this.shortDescription = '',
    this.id,
    this.isAvailable = true,
    this.cardColor = const Color(0xFFFFFFFF),
    this.textColor = const Color(0xFF000000),
    this.borderRadius = 12.0,
    this.rating,
    this.discountPercentage,
    this.width,
    this.height,
    this.bottomText = 'BOTTOM TEXT (CONTENT) BY (SELLER)',
  });

  @override
  ProductCardState createState() => ProductCardState();
}

class ProductCardState extends State<ProductCard> {
  bool _isAdded = false;

  @override
  Widget build(BuildContext context) {
    double responseWidth = MediaQuery.of(context).size.width;
    double responseHeight = MediaQuery.of(context).size.height;
    double responseImage = DeviceSize.getResponsiveImage(responseWidth);
    double responseFontSize = DeviceSize.getResponsiveFontSize(responseWidth);
    double responsePadding = DeviceSize.getResponsivePadding(responseWidth);

    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: Container(
        width: widget.width ?? responseWidth * 0.45,
        constraints: BoxConstraints(
          maxHeight: responseHeight * 0.4,
          minHeight: responseHeight * 0.25,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: IntrinsicHeight(
          // Thêm IntrinsicHeight để widget tự động fit height
          child: Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            elevation: 2,
            color: widget.cardColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image and favorite button
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(widget.borderRadius),
                        topRight: Radius.circular(widget.borderRadius),
                      ),
                      child: Container(
                        height: responseImage * 1.2, // Giảm từ 1.5 xuống 1.2
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: _buildProductImage(),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(32),
                          onTap: () {
                            setState(() {
                              _isAdded = !_isAdded;
                            });
                            if (widget.onFavoritePressed != null) {
                              widget.onFavoritePressed!();
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: _isAdded
                                  ? const Color.fromARGB(255, 245, 30, 15)
                                  : Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isAdded
                                  ? Ionicons.add_circle_outline
                                  : Icons.add_circle_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Discount badge if available
                    if (widget.discountPercentage != null)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                            ),
                          ),
                          child: Text(
                            '${widget.discountPercentage?.toStringAsFixed(0)}% OFF',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                // Product details - Thay Expanded bằng Flexible
                Flexible(
                  fit: FlexFit.loose, // Cho phép widget co lại nếu cần
                  child: Padding(
                    padding: EdgeInsets.all(responsePadding * 0.75),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.categoryName,
                          style: TextStyle(
                            fontSize: responseFontSize * 0.7,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: responsePadding * 0.125),
                        Text(
                          widget.productName,
                          style: TextStyle(
                            fontSize: responseFontSize,
                            fontWeight: FontWeight.bold,
                            color: widget.textColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Short description (if provided)
                        if (widget.shortDescription != null &&
                            widget.shortDescription!.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(
                              top: responsePadding * 0.125,
                            ),
                            child: Text(
                              widget.shortDescription!,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: responseFontSize * 0.75,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        // Product rating (if available)
                        if (widget.rating != null)
                          Padding(
                            padding: EdgeInsets.only(
                              top: responsePadding * 0.25,
                            ),
                            child: Row(
                              children: List.generate(
                                5,
                                (index) => Icon(
                                  index < widget.rating!.round()
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.orange,
                                  size: responseFontSize * 0.75,
                                ),
                              ),
                            ),
                          ),
                        // Spacer để đẩy phần availability và price xuống cuối
                        const Spacer(),
                        // Product availability and price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (widget.isAvailable!)
                              Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: responseFontSize * 0.9,
                                  ),
                                  SizedBox(width: responsePadding * 0.125),
                                  Text(
                                    'Còn hàng',
                                    style: TextStyle(
                                      fontSize: responseFontSize * 0.7,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            if (!widget.isAvailable!)
                              Row(
                                children: [
                                  Icon(
                                    Icons.do_disturb_alt_rounded,
                                    color: Colors.red,
                                    size: responseFontSize * 0.9,
                                  ),
                                  SizedBox(width: responsePadding * 0.125),
                                  Text(
                                    'Hết hàng',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: responseFontSize * 0.7,
                                    ),
                                  ),
                                ],
                              ),
                            Text(
                              widget.price,
                              style: TextStyle(
                                color: widget.textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: responseFontSize,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Caution banner at bottom
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: responsePadding * 0.25,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.yellow,
                    gradient: LinearGradient(
                      colors: [Colors.yellow, Color(0xFFFFE082)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.bottomText ?? 'BOTTOM TEXT (CONTENT) BY (SELLER)',
                      style: TextStyle(
                        fontSize: responseFontSize * 0.5,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background color while image loads
        Container(color: Colors.grey[200]),
        LazyCacheImage(
          imageUrl:
              widget.imageUrl ??
              'https://cdn3.iconfinder.com/data/icons/it-and-ui-mixed-filled-outlines/48/default_image-1024.png', // Replace with your image URL
          enableOfflineMode: false,
          enableAdaptiveLoading: false,
          fit: BoxFit.cover,

          cacheDuration: const Duration(days: 30),

          // Thêm error handler để debug
          errorWidget: Container(
            color: Colors.grey[300],
            child: Icon(Icons.error),
          ),

          // Thêm loading placeholder
          onRetry: () {},
        ),
        // The actual image
        // Image.network(
        //   widget.imageUrl,
        //   fit: BoxFit.cover,
        //   height: 140,
        //   width: double.infinity,
        //   loadingBuilder: (context, child, loadingProgress) {
        //     if (loadingProgress == null) {
        //       _isImageLoading = false;
        //       return child;
        //     }
        //     return Center(
        //       child: CircularProgressIndicator(
        //         value: loadingProgress.expectedTotalBytes != null
        //             ? loadingProgress.cumulativeBytesLoaded /
        //                 loadingProgress.expectedTotalBytes!
        //             : null,
        //         strokeWidth: 2,
        //         color: Colors.grey[400],
        //       ),
        //     );
        //   },
        //   errorBuilder: (context, error, stackTrace) {
        //     _imageError = true;
        //     // Fallback to placeholder or brand name when image fails to load
        //     return Center(
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Icon(
        //             Icons.image_not_supported_outlined,
        //             color: Colors.grey[400],
        //             size: 32,
        //           ),
        //           const SizedBox(height: 8),
        //           Text(
        //             widget.productName,
        //             style: TextStyle(
        //               color: Colors.grey[600],
        //               fontWeight: FontWeight.bold,
        //             ),
        //             textAlign: TextAlign.center,
        //             maxLines: 2,
        //             overflow: TextOverflow.ellipsis,
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        // ),
      ],
    );
  }
}
