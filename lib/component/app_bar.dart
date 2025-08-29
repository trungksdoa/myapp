import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        IconButton(
          icon: Icon(Icons.menu, size: 32, color: AppColors.textOnPrimary),
          onPressed: () {},
        ),
      ],
    );
  }
}
