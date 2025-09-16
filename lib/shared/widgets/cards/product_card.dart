import 'package:flutter/material.dart';

import 'package:myapp/core/utils/device_size.dart';

import 'package:myapp/shared/widgets/common/image_cache.dart';

class ProductCard extends StatefulWidget {
  final String? id;
  final String? imageUrl;
  final String? shortDescription;
  final String categoryName;
  final String productName;
  final String price;
  final String? currency;
  final VoidCallback? onTap;
  final VoidCallback? onFavoritePressed;
  final bool? isAvailable;
  final Color cardColor;
  final Color textColor;
  final double borderRadius;
  final double? rating;
  final double? discountPercentage;
  final double? width;
  final double? height;
  final String? bottomText;
  final bool? showAddToCartButton;

  const ProductCard({
    super.key,
    this.imageUrl,
    required this.categoryName,
    required this.productName,
    required this.price,
    this.currency = '₫',
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
    this.bottomText,
    this.showAddToCartButton = true,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  bool _isAddedToCart = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    widget.onTap?.call();
  }

  void _handleAddToCart() {
    setState(() {
      _isAddedToCart = !_isAddedToCart;
    });
    widget.onFavoritePressed?.call();
    // NotificationUtils.showNotificationWithAction(context, "Thêm sản", onPressed: onPressed)
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final responseFontSize = DeviceSize.getResponsiveFontSize(screenWidth);
    final responsePadding = DeviceSize.getResponsivePadding(screenWidth);
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: _buildCard(context, responseFontSize, responsePadding),
        );
      },
    );
  }

  Widget _buildCard(BuildContext context, double fontSize, double padding) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        width: widget.width ?? screenWidth * 0.45,
        padding: EdgeInsets.all(padding * 0.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          elevation: 0,
          color: widget.cardColor,
          child: Container(
            padding: EdgeInsets.all(padding * 0.5),
            height: widget.height ?? 260, // Giảm chiều cao xuống
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSection(fontSize),
                // Content section without Flexible wrapper
                Expanded(child: _buildContentSection(fontSize, padding)),
                // Thêm store info ở bottom
                _buildStoreInfo(fontSize, padding),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(double fontSize) {
    return Stack(
      alignment: Alignment.center, // Căn giữa toàn bộ stack
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(widget.borderRadius),
            topRight: Radius.circular(widget.borderRadius),
          ),
          child: AspectRatio(
            aspectRatio: 1.0, // Square image
            child: Container(
              color: Colors.grey[50],
              child: Center(
                // Căn giữa ảnh bên trong container
                child: _buildProductImage(),
              ),
            ),
          ),
        ),
        // Add to cart button
        Positioned(top: 8, right: 8, child: _buildAddToCartButton()),
        // Discount badge
        if (widget.discountPercentage != null && widget.discountPercentage! > 0)
          Positioned(top: 8, left: 8, child: _buildDiscountBadge()),
      ],
    );
  }

  Widget _buildProductImage() {
    return ImageCacheWidget(
      imageUrl:
          widget.imageUrl ??
          'https://cdn3.iconfinder.com/data/icons/it-and-ui-mixed-filled-outlines/48/default_image-1024.png',
      fit: BoxFit
          .contain, // Scale ảnh để fit toàn bộ mà không crop, giữ nguyên tỷ lệ
    );
  }

  Widget _buildAddToCartButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: _handleAddToCart,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.7),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.add_rounded, color: Colors.white, size: 16),
        ),
      ),
    );
  }

  Widget _buildDiscountBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '-${widget.discountPercentage!.toStringAsFixed(0)}%',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildContentSection(double fontSize, double padding) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: padding * 0.4,
        vertical: padding * 0.15,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category - always visible
          Text(
            widget.categoryName,
            style: TextStyle(
              fontSize: fontSize * 0.6,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: padding * 0.08),

          // Product name with availability icon - priority content
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.productName,
                  style: TextStyle(
                    fontSize: fontSize * 0.85,
                    fontWeight: FontWeight.w600,
                    color: widget.textColor,
                    height: 1.1,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: padding * 0.2),
              // Availability icon moved here
              Icon(
                widget.isAvailable == true
                    ? Icons.check_circle_rounded
                    : Icons.error_outline_rounded,
                color: widget.isAvailable == true ? Colors.green : Colors.red,
                size: fontSize * 0.65,
              ),
            ],
          ),

          // Description - optional content
          if (widget.shortDescription != null &&
              widget.shortDescription!.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: padding * 0.15),
              child: Text(
                widget.shortDescription!,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: fontSize * 0.6,
                  height: 1.1,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          // Spacer
          Expanded(child: SizedBox(height: 0)),

          // Rating and price in bottom section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.rating != null)
                _buildCompactRating(fontSize)
              else
                const SizedBox.shrink(),
              _buildBottomRow(fontSize),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactRating(double fontSize) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, color: Colors.amber, size: fontSize * 0.6),
        SizedBox(width: 2),
        Text(
          widget.rating?.toStringAsFixed(1) ?? '0.0',
          style: TextStyle(
            fontSize: fontSize * 0.6,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomRow(double fontSize) {
    return Text(
      widget.price,
      style: TextStyle(
        color: Colors.green[700],
        fontWeight: FontWeight.bold,
        fontSize: fontSize * 0.9,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.right,
    );
  }

  Widget _buildStoreInfo(double fontSize, double padding) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: padding * 0.4,
        vertical: padding * 0.3,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(widget.borderRadius),
          bottomRight: Radius.circular(widget.borderRadius),
        ),
      ),
      child: Row(
        children: [
          // Store logo
          Container(
            width: fontSize * 1.2,
            height: fontSize * 1.2,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(fontSize * 0.3),
            ),
            child: Icon(
              Icons.store,
              color: Colors.blue[700],
              size: fontSize * 0.8,
            ),
          ),

          SizedBox(width: padding * 0.4),

          // Store name
          Expanded(
            child: Text(
              'PetShop Việt Nam',
              style: TextStyle(
                fontSize: fontSize * 0.65,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Optional: Store rating or other info
          Icon(Icons.verified, color: Colors.blue[600], size: fontSize * 0.6),
        ],
      ),
    );
  }
}
