import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/shared/widgets/common/image_cache.dart';

class ProductCard extends StatefulWidget {
  final String? id;
  final String? imageUrl;
  final String categoryName;
  final String productName;
  final String price;
  final String? originalPrice;
  final String? currency;
  final VoidCallback? onTap;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onAddToCart;
  final bool? isAvailable;
  final bool? isFavorite;
  final Color cardColor;
  final Color textColor;
  final double borderRadius;
  final double? rating;
  final int? reviewCount;
  final double? discountPercentage;
  final double? width;
  final double? height;
  final String? bottomText;
  final bool? showAddToCartButton;
  final bool? showFavoriteIcon;
  final String? badge; // "Bán chạy", "Mới", etc.
  final bool? isLoading;

  const ProductCard({
    super.key,
    this.id,
    this.imageUrl,
    required this.categoryName,
    required this.productName,
    required this.price,
    this.originalPrice,
    this.currency = '₫',
    this.onTap,
    this.onFavoritePressed,
    this.onAddToCart,
    this.isAvailable = true,
    this.isFavorite = false,
    this.cardColor = Colors.white,
    this.textColor = Colors.black,
    this.borderRadius = 10.0,
    this.rating,
    this.reviewCount,
    this.discountPercentage,
    this.width,
    this.height,
    this.bottomText,
    this.showAddToCartButton = true,
    this.badge,
    this.isLoading = false,
    this.showFavoriteIcon,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with TickerProviderStateMixin {
  late final AnimationController _scaleCtl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
  );

  late final AnimationController _favoriteCtl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  late final AnimationController _shimmerCtl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat();

  late final Animation<double> _scale = CurvedAnimation(
    parent: Tween(begin: 1.0, end: 0.97).animate(_scaleCtl),
    curve: Curves.easeOut,
  );

  late final Animation<double> _favoriteScale = CurvedAnimation(
    parent: Tween(begin: 1.0, end: 1.2).animate(_favoriteCtl),
    curve: Curves.elasticOut,
  );

  bool _isHovered = false;

  @override
  void dispose() {
    _scaleCtl.dispose();
    _favoriteCtl.dispose();
    _shimmerCtl.dispose();
    super.dispose();
  }

  Future<void> _press() async {
    HapticFeedback.lightImpact();
    await _scaleCtl.forward();
    await _scaleCtl.reverse();
    widget.onTap?.call();
  }

  void _onFavoritePressed() async {
    HapticFeedback.mediumImpact();
    await _favoriteCtl.forward();
    await _favoriteCtl.reverse();
    widget.onFavoritePressed?.call();
  }

  void _onAddToCart() async {
    HapticFeedback.mediumImpact();
    widget.onAddToCart?.call();

    // Show snackbar feedback
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã thêm ${widget.productName} vào giỏ hàng'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading == true) {
      return _buildLoadingCard();
    }

    return AnimatedBuilder(
      animation: Listenable.merge([_scale, _favoriteScale]),
      builder: (context, _) {
        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: Transform.scale(
            scale: _scale.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.width,
              height: widget.height,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(_isHovered ? 0.12 : 0.06),
                    blurRadius: _isHovered ? 12 : 8,
                    offset: Offset(0, _isHovered ? 4 : 2),
                  ),
                ],
              ),
              child: Material(
                color: widget.cardColor,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: InkWell(
                  onTap: widget.isAvailable == true ? _press : null,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: Opacity(
                    opacity: widget.isAvailable == true ? 1.0 : 0.6,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 6, child: _buildImageSection()),
                          const SizedBox(height: 8),
                          Expanded(flex: 4, child: _buildContentSection()),
                          const SizedBox(height: 4),
                          SizedBox(height: 18, child: _buildStoreSection()),
                          if (widget.showAddToCartButton == true) ...[
                            const SizedBox(height: 6),
                            _buildActionButton(),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: widget.cardColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: _buildShimmerBox(double.infinity, double.infinity),
              ),
              const SizedBox(height: 8),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerBox(60, 12),
                    const SizedBox(height: 4),
                    _buildShimmerBox(double.infinity, 16),
                    const SizedBox(height: 4),
                    _buildShimmerBox(100, 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerBox(double width, double height) {
    return AnimatedBuilder(
      animation: _shimmerCtl,
      builder: (context, _) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: LinearGradient(
              begin: Alignment(-1.0, -0.3),
              end: Alignment(1.0, 0.3),
              colors: [Colors.grey[300]!, Colors.grey[100]!, Colors.grey[300]!],
              stops: [
                _shimmerCtl.value - 0.3,
                _shimmerCtl.value,
                _shimmerCtl.value + 0.3,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSection() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius - 2),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[100],
        child: Stack(
          fit: StackFit.expand,
          children: [
            ImageCacheWidget(
              imageUrl:
                  widget.imageUrl ??
                  'https://cdn3.iconfinder.com/data/icons/it-and-ui-mixed-filled-outlines/48/default_image-1024.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),

            if (widget.showFavoriteIcon == true)
              // Favorite button
              Positioned(
                top: 6,
                right: 6,
                child: Transform.scale(
                  scale: _favoriteScale.value,
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    elevation: 2,
                    child: InkWell(
                      onTap: _onFavoritePressed,
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          widget.isFavorite == true
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 16,
                          color: widget.isFavorite == true
                              ? Colors.red
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Discount badge
            if ((widget.discountPercentage ?? 0) > 0)
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
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
                ),
              ),

            // Custom badge
            if (widget.badge != null && (widget.discountPercentage ?? 0) == 0)
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.badge!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            // Out of stock overlay
            if (widget.isAvailable == false)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(
                      widget.borderRadius - 2,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Hết hàng',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final nameSize = constraints.maxWidth < 120 ? 11.0 : 12.0;
        final catSize = constraints.maxWidth < 120 ? 8.5 : 9.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Category
            SizedBox(
              height: 12,
              child: Text(
                widget.categoryName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: catSize,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 2),

            // Product name
            Expanded(
              child: Text(
                widget.productName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: nameSize,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                  color: widget.textColor,
                ),
              ),
            ),
            const SizedBox(height: 2),

            // Price and Rating row
            SizedBox(
              height: 16,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: _buildPriceSection()),
                  const SizedBox(width: 4),
                  if (widget.rating != null) _buildRatingSection(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPriceSection() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            '${widget.price}${widget.currency}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
        ),
        if (widget.originalPrice != null) ...[
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              '${widget.originalPrice}${widget.currency}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey[500],
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRatingSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 10, color: Colors.amber),
          const SizedBox(width: 2),
          Text(
            widget.rating!.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Colors.amber,
            ),
          ),
          if (widget.reviewCount != null) ...[
            const SizedBox(width: 2),
            Text(
              '(${widget.reviewCount})',
              style: TextStyle(fontSize: 8, color: Colors.grey[600]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStoreSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.store_rounded, size: 10, color: Colors.blueGrey[600]),
        const SizedBox(width: 4),
        const Expanded(
          child: Text(
            'PetShop Việt Nam',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Icon(Icons.verified_rounded, size: 10, color: Colors.blue[600]),
      ],
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      height: 28,
      child: ElevatedButton(
        onPressed: widget.isAvailable == true ? _onAddToCart : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[600],
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add_shopping_cart_rounded, size: 14),
            SizedBox(width: 4),
            Text(
              'Thêm vào giỏ',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
