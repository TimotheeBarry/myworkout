import 'package:flutter/material.dart';
import '../theme/styles.dart' as styles;

class FilterButton extends StatelessWidget {
  const FilterButton({
    Key? key,
    required this.title,
    required  this.color,
    required this.onTap,
    this.icon,
  }) : super(key: key);
  final Text title;
  final Widget? icon;
  final void Function() onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.black12,
          child: Ink(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration:  BoxDecoration(color: color),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
