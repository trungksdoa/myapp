import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/core/theme/custom_colors.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;
  @override
  State<Home> createState() => _TestState();
}

class _TestState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.primaryColor,
        title: TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            minimumSize: Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: Colors.transparent,
          ),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Care',
                  style: GoogleFonts.poppins(
                    color: Colors.deepOrangeAccent,
                    fontSize: 20, // ↓ fontSize nhỏ lại, hiển thị cân đối
                    fontWeight: FontWeight.bold,
                    // shadows: [
                    //   Shadow(
                    //     color: Colors.black,
                    //     offset: Offset(2, 4),
                    //     blurRadius: 1,
                    //   ),
                    // ],
                  ),
                ),
                TextSpan(
                  text: 'Nest',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20, // ↓ đồng bộ size
                    fontWeight: FontWeight.bold,
                    // shadows: [
                    //   Shadow(
                    //     color: Colors.black,
                    //     offset: Offset(2, 4),
                    //     blurRadius: 1,
                    //   ),
                    // ],
                  ),
                ),
              ],
            ),
          ),
        ),
        leading: IconButton(icon: Icon(Icons.pets), onPressed: () {}),

        actions: [IconButton(icon: Icon(Icons.menu), onPressed: () {})],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
