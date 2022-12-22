import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key,
      required this.title,
      this.actions,
      this.leading,
      this.subtitle});
  final String title;
  final String? subtitle;
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
      title: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.lexend(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle != null
              ? Text(
                  subtitle!,
                  style: GoogleFonts.lexend(
                    fontSize: 12,
                    color: Colors.white60,
                   
                   
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
      centerTitle: true,
    );
  }
}
