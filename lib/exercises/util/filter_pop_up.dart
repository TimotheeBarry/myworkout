import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:myworkout/core/util/custom_button.dart';
import 'package:myworkout/core/util/custom_check_box.dart';
import 'package:myworkout/core/util/custom_rect_tween.dart';
import '../../core/theme/styles.dart' as styles;

class FilterPopUp extends StatefulWidget {
  const FilterPopUp({Key? key}) : super(key: key);

  @override
  State<FilterPopUp> createState() => _FilterPopUpState();
}

class _FilterPopUpState extends State<FilterPopUp> {
  bool filterLiked = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Hero(
            tag: 'filter',
            createRectTween: (begin, end) {
              return CustomRectTween(begin: begin!, end: end!);
            },
            child: Material(
              color: Colors.white54,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(children: [
                        Icon(Icons.filter_list_rounded,
                            color: styles.frame.primaryTextColor),
                        const SizedBox(width: 4),
                        Text('Filtrer', style: styles.frame.title)
                      ]),
                      styles.frame.divider,
                      Row(
                        children: [
                          CustomCheckBox(
                              value: filterLiked,
                              onChanged: (value) {
                                setState(() {
                                  filterLiked = value!;
                                });
                              }),
                          Text('Exercices favoris',
                              style: styles.frame.subtitle),
                        ],
                      ),
                      styles.form.bigVoidSpace,
                      CustomButton(
                        title: Text('Valider', style: styles.button.mediumText),
                        onTap: () {},
                      ),
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
