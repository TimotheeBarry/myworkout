import 'package:flutter/material.dart';
import '../../core/theme/styles.dart' as styles;

class InputField extends StatelessWidget {
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final EdgeInsetsGeometry? padding;
  final String? hintText;
  final double? height;
  final double? width;
  final TextInputType? keyboardType;
  final bool shadow;
  final double? radius;
  final int? maxLines;
  final String? initialValue;
  const InputField(
      {Key? key,
      this.onChanged,
      this.padding,
      this.height,
      this.hintText,
      this.onSubmitted,
      this.keyboardType,
      this.width,
      this.shadow = false,
      this.radius,
      this.maxLines = 1,
      this.initialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: styles.input.backgroundColor,
        borderRadius: BorderRadius.circular(
            radius ?? ((height == null) ? 24 : height! / 2)),
      ),
      child: TextFormField(
        style: styles.frame.bigText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        maxLines: maxLines,
        initialValue: initialValue,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: styles.input.hintStyle,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
