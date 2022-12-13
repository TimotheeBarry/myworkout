import 'package:flutter/material.dart';
import '../theme/styles.dart' as styles;

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.title,
      required this.onTap,
      this.icon})
      : super(key: key);
  final Text title;
  final Icon? icon;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: styles.button.borderRadius,
      elevation: 4,
      child: ClipRRect(
        borderRadius: styles.button.borderRadius,
        child: Material(
          child: InkWell(
            onTap: onTap,
            splashColor: Colors.black12,
            child: Ink(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(color: styles.button.backgroundColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon != null
                      ? Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: icon,
                        )
                      : const SizedBox.shrink(),
                  title,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
