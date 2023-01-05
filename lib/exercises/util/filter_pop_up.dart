import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:myworkout/core/util/custom_button.dart';
import 'package:myworkout/core/util/custom_check_box.dart';
import 'package:myworkout/core/util/custom_rect_tween.dart';
import 'package:myworkout/core/util/filter_button.dart';
import '../../core/theme/styles.dart' as styles;

class FilterPopUp extends StatefulWidget {
  const FilterPopUp(
      {Key? key, required this.applyFilters, required this.likedFilterChecked})
      : super(key: key);
  final void Function(
      {required bool liked,
      List<String>? equipments,
      List<String>? type}) applyFilters;
  final bool likedFilterChecked;
  @override
  State<FilterPopUp> createState() => _FilterPopUpState();
}

class _FilterPopUpState extends State<FilterPopUp> {
  bool filterLiked = false;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      filterLiked = widget.likedFilterChecked;
    });
    super.initState();
  }

  void onConfirm() {
    widget.applyFilters(liked: filterLiked);
    Navigator.pop(context);
  }

  void onCancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Hero(
            tag: 'filte',
            createRectTween: (begin, end) {
              return CustomRectTween(begin: begin!, end: end!);
            },
            child: Material(
              color: styles.popup.backgroundColor,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.filter_list_rounded,
                              color: styles.frame.primaryTextColor),
                          const SizedBox(width: 4),
                          Text('Filtrer', style: styles.popup.title)
                        ],
                      ),
                      styles.popup.divider,
                      Row(
                        children: [
                          CustomCheckBox(
                              value: filterLiked,
                              scale: 1.5,
                              borderColor: styles.popup.textColor,
                              activeColor: styles.page.darkBlue[0],
                              checkColor: styles.popup.backgroundColor,
                              onChanged: (value) {
                                setState(() {
                                  filterLiked = value!;
                                });
                              }),
                          Text('Exercices favoris', style: styles.popup.option),
                        ],
                      ),
                      styles.form.bigVoidSpace,
                      Row(
                        children: [
                          Expanded(
                            child: FilterButton(
                              title:
                                  Text('Annuler', style: styles.popup.cancel),
                              color: styles.popup.buttonCancelColor,
                              onTap: onCancel,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FilterButton(
                              title:
                                  Text('Valider', style: styles.popup.confirm),
                              color: styles.popup.buttonConfirmColor,
                              onTap: onConfirm,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
