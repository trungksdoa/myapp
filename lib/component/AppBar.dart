import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppBar extends StatefulWidget {
  static const double logoSize = 58;
  static const double appBarFontSize = 25;
  static const FontWeight appBarFontWeight = FontWeight.bold;
  static const Color colorPrimary = Color(0xFF2ea19c);
  static const Color colorCare = Colors.deepOrangeAccent;
  static const Color colorNest = Colors.white;
  static const Shadow nestTextShadow = Shadow(
    color: Colors.black45,
    offset: Offset(2, 4),
    blurRadius: 4,
  );

  final double expandedHeight;
  final String logoPath;

  const MyAppBar({
    Key? key,
    this.expandedHeight = 120,
    this.logoPath = 'assets/images/logo.png',
  }) : super(key: key);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: MyAppBar.colorPrimary,
      pinned: true,
      floating: true,
      expandedHeight: widget.expandedHeight,
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
                color: MyAppBar.colorCare,
                fontSize: MyAppBar.appBarFontSize,
                fontWeight: MyAppBar.appBarFontWeight,
              ),
            ),
            TextSpan(
              text: 'Nest',
              style: GoogleFonts.poppins(
                color: MyAppBar.colorNest,
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
          icon: Icon(Icons.menu, size: 32, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }
}
