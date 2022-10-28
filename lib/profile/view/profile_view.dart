import 'package:flutter/material.dart';
import '../../core/theme/styles.dart' as styles;

class ProfileView extends StatelessWidget {
  ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        margin: styles.frame.margin,
        decoration: styles.frame.boxDecoration,
        child: const Center(
          child: Text(
            'Profile',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
