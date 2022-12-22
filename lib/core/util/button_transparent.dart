import 'package:flutter/material.dart';
import '../theme/styles.dart' as styles;

class ButtonTransparent extends StatelessWidget {
  const ButtonTransparent(
      {Key? key,
      required this.title,
      required this.onTap,
      this.icon,
      this.expand = true})
      : super(key: key);
  final Text title;
  final Widget? icon;
  final void Function() onTap;
  final bool expand;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: styles.button.borderRadius,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.black12,
          child: Ink(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: const BoxDecoration(color: Colors.white30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
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
    );
  }
}
