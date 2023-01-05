import 'package:flutter/material.dart';
import '../../core/theme/styles.dart' as styles;

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox(
      {Key? key,
      this.value,
      this.onChanged,
      this.checkColor,
      this.activeColor,
      this.borderColor,
      this.scale})
      : super(key: key);
  final bool? value;
  final Color? checkColor;
  final Color? activeColor;
  final Color? borderColor;
  final double? scale;
  final void Function(bool?)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale ?? 1.2,
      child: Theme(
        data: ThemeData(
            unselectedWidgetColor:
                borderColor ?? styles.frame.primaryTextColor),
        child: Checkbox(
            activeColor: activeColor ?? styles.button.backgroundColor,
            checkColor: checkColor ?? Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            value: value,
            onChanged: onChanged),
      ),
    );
  }
}
