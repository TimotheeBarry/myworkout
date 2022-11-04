import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key, required this.title, this.actions, this.leading});
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      actions: actions,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        title,
        style: GoogleFonts.lexend(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
    );
  }
}
