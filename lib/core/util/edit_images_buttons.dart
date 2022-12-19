import 'package:flutter/material.dart';
import '../theme/styles.dart' as styles;

class EditImagesButtons extends StatelessWidget {
  const EditImagesButtons(
      {Key? key,
      required this.edit,
      this.onTapCamera,
      this.onTapGallery,
      this.onTapDelete})
      : super(key: key);
  final bool edit;
  final void Function()? onTapCamera;
  final void Function()? onTapGallery;
  final void Function()? onTapDelete;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: IconButton(
          icon:
              Icon(Icons.image, size: 40, color: styles.frame.primaryTextColor),
          onPressed: onTapGallery,
          padding: EdgeInsets.zero,
        )),
        Expanded(
            child: IconButton(
          icon: Icon(Icons.photo_camera,
              size: 40, color: styles.frame.primaryTextColor),
          onPressed: onTapGallery,
          padding: EdgeInsets.zero,
        )),
        edit
            ? Expanded(
                child: IconButton(
                icon: Icon(Icons.delete,
                    size: 40, color: styles.frame.primaryTextColor),
                onPressed: onTapDelete,
                padding: EdgeInsets.zero,
              ))
            : const SizedBox.shrink(),
      ],
    );
  }
}
