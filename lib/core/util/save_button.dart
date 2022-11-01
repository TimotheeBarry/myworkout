import 'package:flutter/material.dart';
import '../theme/styles.dart' as styles;
import 'package:myworkout/core/util/custom_button.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({Key? key, required this.onTap}) : super(key: key);
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      title: Text('Enregistrer', style: styles.button.bigText),
      onTap: onTap,
    );
  }
}
