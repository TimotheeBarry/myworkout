import 'package:flutter/material.dart';
import '../theme/styles.dart' as styles;

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key, required this.title, required this.onTap, this.widthFactor})
      : super(key: key);
  final Text title;
  final void Function() onTap;
  final double? widthFactor;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: styles.button.borderRadius,
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Ink(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(color: styles.button.backgroundColor),
            child: FractionallySizedBox(
              widthFactor: widthFactor ?? .5,
              child: Center(child: title),
            ),
          ),
        ),
      ),
    );
  }
}
