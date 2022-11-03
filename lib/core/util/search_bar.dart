import 'package:flutter/material.dart';
import '../theme/styles.dart' as styles;

class SearchBar extends StatelessWidget {
  final void Function(String)? onChanged;
  const SearchBar({this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
