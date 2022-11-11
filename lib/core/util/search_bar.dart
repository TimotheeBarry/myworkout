import 'package:flutter/material.dart';
import 'package:myworkout/core/util/custom_rect_tween.dart';
import '../theme/styles.dart' as styles;

class SearchBar extends StatelessWidget {
  final void Function(String)? onChanged;
  final void Function()? onTapFilter;
  const SearchBar({this.onChanged, this.onTapFilter});

  Widget buildFilterButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Hero(
        tag: 'filter',
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin!, end: end!);
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTapFilter,
            child: Ink(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Row(children: [
                Icon(Icons.filter_list_rounded,
                    color: styles.frame.primaryTextColor),
                const SizedBox(width: 4),
                Text('Filtrer', style: styles.frame.subtitle)
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(left: 16),
        decoration: BoxDecoration(
          color: styles.input.backgroundColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search, size: 26, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                style: styles.frame.bigText,
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: 'Rechercher...',
                  hintStyle: styles.input.hintStyle,
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildSearchBar(),
        buildFilterButton(),
      ],
    );
  }
}
