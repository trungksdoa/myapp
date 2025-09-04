import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/auth_factory.dart';
import 'package:myapp/route/navigate_helper.dart';
import 'package:myapp/service/interface/auth_repository.dart';
import '../core/colors.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  static const double logoSize = 58;
  static const double appBarFontSize = 25;
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
    this.height = 90,
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
      backgroundColor: AppColors.primary,
      toolbarHeight: widget.height,
      leadingWidth: MyAppBar.logoSize + 18,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Image.asset(
          widget.logoPath,
          width: MyAppBar.logoSize,
          height: MyAppBar.logoSize,
          fit: BoxFit.contain,
        ),
      ),
      centerTitle: true,
      automaticallyImplyLeading: true,
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
        if (_authService.isAuthenticated) ...[
          // User avatar/name
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8),
          //   child: Center(
          //     child: Text(
          //       _authService.username ?? 'User',
          //       style: TextStyle(
          //         color: AppColors.textOnPrimary,
          //         fontSize: 14,
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //   ),
          // ),
          // Logout button
          IconButton(
            icon: Icon(Icons.logout, size: 28, color: AppColors.textOnPrimary),
            onPressed: _handleLogout,
            tooltip: 'Đăng xuất',
          ),
        ] else ...[
          // Login button if not authenticated
          IconButton(
            icon: Icon(Icons.login, size: 28, color: AppColors.textOnPrimary),
            onPressed: () {
              Navigator.of(context).pushNamed('/auth/login');
            },
            tooltip: 'Đăng nhập',
          ),
        ],
      ],
    );
  }
}
