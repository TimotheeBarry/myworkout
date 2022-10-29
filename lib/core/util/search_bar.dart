import 'package:flutter/material.dart';
import '../theme/styles.dart' as styles;

class SearchBar extends StatelessWidget {
  final void Function(String)? onChanged;
  const SearchBar({this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: styles.page.margin,
      padding: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        color: Color(0x63ffffff),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search, size: 26, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              style: const TextStyle(color: Colors.white),
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: 'Rechercher...',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
