import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key? key,
    this.title,
    this.subtitle,
    this.action,
    this.middle,
    this.onTap,
    this.onLongPress,
    this.padding,
  }) : super(key: key);
  final Widget? title;
  final Widget? action;
  final Widget? middle;
  final Widget? subtitle;
  final EdgeInsets? padding;
  final void Function()? onTap;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onLongPress: onLongPress,
        onTap: onTap,
        child: Ink(
          padding: padding,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title ?? const SizedBox.shrink(),
                        subtitle ?? const SizedBox.shrink(),
                      ],
                    )),
              ),
              Container(child: middle ?? const SizedBox.shrink()),
              Container(child: action ?? const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}
