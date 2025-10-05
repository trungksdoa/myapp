import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/core/utils/device_size.dart';
import 'package:myapp/features/shop/logic/shop_logic.dart';
import 'package:myapp/features/auth/service/auth_service.dart';
import 'package:myapp/features/shop/widgets/product_bottom_bar_widget.dart';
import 'package:myapp/features/shop/widgets/product_detail_header_widget.dart';
import 'package:myapp/features/shop/widgets/product_info_widget.dart';
import 'package:myapp/features/shop/widgets/product_main_image_widget.dart';
import 'package:myapp/features/shop/widgets/product_thumbnail_list_widget.dart';
// TODO: Comment out when API is ready
import 'package:myapp/route/navigate_helper.dart';
import 'package:myapp/shared/model/product.dart';
import 'package:myapp/shared/widgets/common/notification.dart';

class DetailProductScreen extends StatefulWidget {
  final String? productId;
  final String? category;

  const DetailProductScreen({super.key, this.productId, this.category});

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen>
    with SingleTickerProviderStateMixin {
  Product? _product;
  int _currentImageIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final CartService _cartService = CartService();
  // Dynamic product images - can be extended to load from API
  List<String> get _productImages {
    // In production, this should load from product data or API
    // For now, using default images
    return [
      'https://res.cloudinary.com/dc1piksu8/image/upload/v1756239589/9725.jpg',
      'https://res.cloudinary.com/dc1piksu8/image/upload/v1756239589/9725.jpg',
      'https://res.cloudinary.com/dc1piksu8/image/upload/v1756239589/9725.jpg',
      'https://res.cloudinary.com/dc1piksu8/image/upload/v1756239589/9725.jpg',
    ];
  }

  @override
  void initState() {
    super.initState();
    _loadProduct();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _animationController.forward();
  }

  void _loadProduct() async {
    if (widget.productId != null) {
      try {
        // TODO: Replace with service call when API is ready
        // For now using mock data
        setState(() {
          // Create a mock product for demonstration
          _product = Product(
            productId: widget.productId!,
            productName: 'Dịch vụ chăm sóc thú cưng',
            description: 'Dịch vụ chăm sóc chuyên nghiệp cho thú cưng',
            category: widget.category ?? 'care',
            status: true,
            shopId: 'shop_1',
          );
        });
      } catch (e) {
        setState(() {});
      }
    } else {
      // Default product
      setState(() {
        _product = Product(
          productId: 'default_1',
          productName: 'Dịch vụ mặc định',
          description: 'Dịch vụ chăm sóc mặc định',
          category: 'care',
          status: true,
          shopId: 'shop_1',
        );
      });
    }
  }

  void _onImageSelected(int index) {
    setState(() {
      _currentImageIndex = index;
    });
  }

  void _onAddToCart() async {
    HapticFeedback.mediumImpact();
    if (_product == null) return; // Guard against uninitialized product
    if (widget.category == 'care') {
      _product = _product!.copyWith(
        productName: 'New Name ${DateTime.now()}',
        description: 'New description',
        status: true,
        category: 'care',
        productDetail: null,
      );
      // Show booking dialog and get selected date/time and note
      Map<String, dynamic> bookingData = await _onBooking(_product!);

      final DateTime? selectedDateTime = bookingData['dateTime'];
      final String? note = bookingData['note'];

      if (selectedDateTime == null) {
        // User cancelled the booking or skipped, do not add to cart
        return;
      }

      // Add selected date/time and note to options
      final options = <String, dynamic>{};
      options['note'] = note;
      options['dateTime'] = selectedDateTime.toString();

      // Add to cart with options
      _cartService.addToCart(_product!, options: options);

      NotificationUtils.showNotificationWithAction(
        context,
        'Đã thêm ${_product!.productName} vào giỏ hàng',
        actionLabel: "Xem ngay",
        onPressed: () {},
      );
    } else {
      // Regular products
      setState(() {
        _cartService.addToCart(_product!);
      });

      NotificationUtils.showNotificationWithAction(
        context,
        'Đã thêm ${_product!.productName} vào giỏ hàng',
        actionLabel: "Xem ngay",
        onPressed: () {},
      );
    }
  }

  void _onBuyNow() async {
    HapticFeedback.mediumImpact();

    if (_product == null) return; // Guard
    if (widget.category == 'care') {
      Map<String, dynamic> bookingData = await _onBooking(_product!);
      final DateTime? selectedDateTime = bookingData['dateTime'];
      final String? note = bookingData['note'];

      if (selectedDateTime != null) {
        if (mounted) {
          NavigateHelper.goToOrderScreen(
            context,
            directBuy: true,
            product: _product!,
            dateTime: selectedDateTime.toString(),
            note: note, // Pass the note to order screen
          );
        }
      }
    } else {
      // Regular products
      NavigateHelper.goToOrderScreen(
        context,
        directBuy: true,
        product: _product!,
      );
    }
  }

  _onBooking(Product product) async {
    // Show booking dialog with date/time picker and note section
    Map<String, dynamic> bookingData = {};
    String note = '';

    final DateTime? selectedDateTime = await showBoardDateTimePicker(
      context: context,
      pickerType: DateTimePickerType.datetime,
      initialDate: DateTime.now(),
      minimumDate: DateTime.now(),
      maximumDate: DateTime.now().add(const Duration(days: 30)),
      options: const BoardDateTimeOptions(
        languages: BoardPickerLanguages(
          locale: 'vi',
          today: 'Hôm nay',
          tomorrow: 'Ngày mai',
          now: 'Bây giờ',
        ),
        backgroundColor: Colors.white,
        activeColor: Colors.orange,
        activeTextColor: Colors.white,
        showDateButton: true,
        boardTitle: 'Chọn thời gian dịch vụ',
        boardTitleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        startDayOfWeek: DateTime.monday,
        pickerFormat: 'dMy', // day-month-year
        useAmpm: false, // 24-hour format
        withSecond: false,
        inputable: true,
      ),
    );

    if (selectedDateTime != null) {
      // Show note dialog after date/time selection
      if (mounted) {
        final bool? confirmed = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'Thêm ghi chú',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Thời gian đã chọn: ${selectedDateTime.day}/${selectedDateTime.month}/${selectedDateTime.year} ${selectedDateTime.hour}:${selectedDateTime.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    maxLines: 3,
                    maxLength: 200,
                    decoration: InputDecoration(
                      hintText: 'Nhập ghi chú cho dịch vụ (tùy chọn)...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.orange,
                          width: 2,
                        ),
                      ),
                      counterText: '',
                    ),
                    onChanged: (value) {
                      note = value;
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Return false for skip
                  },
                  child: const Text(
                    'Bỏ qua',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Return true for confirm
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Xác nhận'),
                ),
              ],
            );
          },
        );

        // Only proceed if user confirmed (not skipped)
        if (confirmed == true) {
          bookingData['dateTime'] = selectedDateTime;
          bookingData['product'] = product;
          bookingData['note'] = note.trim().isEmpty ? null : note.trim();
        }
      }
    }

    return bookingData;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double paddingResponsive = DeviceSize.getResponsivePadding(width);
    double fontSize = DeviceSize.getResponsiveFontSize(width);

    // Show loading placeholder while product is being loaded
    if (_product == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with fade animation
            FadeTransition(
              opacity: _fadeAnimation,
              child: ProductDetailHeaderWidget(
                padding: paddingResponsive,
                onBackPressed: () {
                  HapticFeedback.lightImpact();
                  context.pop();
                },
              ),
            ),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Main image with Hero animation - CENTERED
                        Center(
                          child: Hero(
                            tag: 'product-${_product!.productId}',
                            child: ProductMainImageWidget(
                              width: width * 0.65,
                              height: height * 0.4,
                              imageUrl: _productImages[_currentImageIndex],
                              currentIndex: _currentImageIndex,
                              totalImages: _productImages.length,
                            ),
                          ),
                        ),

                        // Thumbnail list with slide animation
                        SlideTransition(
                          position: _slideAnimation,
                          child: ProductThumbnailListWidget(
                            images: _productImages,
                            currentIndex: _currentImageIndex,
                            padding: paddingResponsive,
                            onImageSelected: (index) {
                              HapticFeedback.selectionClick();
                              _onImageSelected(index);
                            },
                          ),
                        ),

                        // Product info with fade and slide animation
                        ProductInfoWidget(
                          product: _product!,
                          padding: paddingResponsive,
                          fontSize: fontSize,
                          category: widget.category,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom bar with slide up animation
            SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(
                        0.6,
                        1.0,
                        curve: Curves.easeOutQuart,
                      ),
                    ),
                  ),
              child: ProductBottomBarWidget(
                padding: paddingResponsive,
                fontSize: fontSize,
                onAddToCart: _onAddToCart,
                onBuyNow: _onBuyNow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
