import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/core/colors.dart';
import 'package:myapp/features/cart/widgets/cart_icon_widget.dart';
import 'package:myapp/service/auth_factory.dart';
import 'package:myapp/route/navigate_helper.dart';
import 'package:myapp/service/interface/auth_repository.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  static const double logoSize = 45;
  static const double appBarFontSize = 20;
  static const FontWeight appBarFontWeight = FontWeight.bold;
  static const Shadow nestTextShadow = Shadow(
    color: Colors.black45,
    offset: Offset(2, 4),
    blurRadius: 4,
  );

  final double height;
  final String logoPath;

  const MyAppBar({
    super.key,
    this.height = 70,
    this.logoPath = 'assets/images/logo.png',
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  late AuthRepository _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthFactory.instance;
  }

  Future<void> _handleLogout() async {
    try {
      await NavigateHelper().logoutAndNavigateToLogin(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi đăng xuất: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: widget.height,
      automaticallyImplyLeading: true,
      leadingWidth: MyAppBar.logoSize + 18,
      // Gradient background
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.85)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      // tappable logo
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Semantics(
          label: 'Home',
          button: true,
          child: InkWell(
            onTap: () => Navigator.of(context).pushNamed('/'),
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              widget.logoPath,
              width: MyAppBar.logoSize,
              height: MyAppBar.logoSize,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      centerTitle: true,
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Care',
              style: GoogleFonts.poppins(
                color: AppColors.careOrange,
                fontSize: MyAppBar.appBarFontSize,
                fontWeight: MyAppBar.appBarFontWeight,
              ),
            ),
            TextSpan(
              text: 'Nest',
              style: GoogleFonts.poppins(
                color: AppColors.nestWhite,
                fontSize: MyAppBar.appBarFontSize,
                fontWeight: MyAppBar.appBarFontWeight,
                shadows: [MyAppBar.nestTextShadow],
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        // Search
        IconButton(
          icon: const Icon(Icons.search, size: 24),
          color: AppColors.textOnPrimary,
          onPressed: () => Navigator.of(context).pushNamed('/search'),
          tooltip: 'Tìm kiếm',
        ),
        // Cart
        CartIconWidget(
          onCartPressed: () => NavigateHelper.goToCart(context),
          iconColor: Colors.white,
        ),
        const SizedBox(width: 6),
      ],
    );
  }
}
