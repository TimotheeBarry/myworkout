import 'package:flutter/material.dart';
import '../../core/theme/styles.dart' as styles;

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({Key? key, this.value, this.onChanged}) : super(key: key);
  final bool? value;
  final void Function(bool?)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.2,
      child: Theme(
        data: ThemeData(unselectedWidgetColor: styles.frame.primaryTextColor),
        child: Checkbox(
            activeColor: styles.button.backgroundColor,
            checkColor: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            value: value,
            onChanged: onChanged),
      ),
    );
  }
}
