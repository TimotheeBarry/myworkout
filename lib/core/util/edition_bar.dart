import 'package:flutter/material.dart';
import '../theme/styles.dart' as styles;

class EditionBar extends StatelessWidget {
  EditionBar({
    this.onDelete,
    this.onCopy,
    this.onMove,
    this.onAdd,
    this.numberSelected,
  });
  void Function()? onDelete;
  void Function()? onCopy;
  void Function()? onMove;
  void Function()? onAdd;
  int? numberSelected = 0;

  Widget buildButton(
      {required IconData icon,
      required String label,
      required void Function()? onPressed}) {
    return ClipRRect(
      borderRadius: styles.frame.borderRadius,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: styles.frame.primaryTextColor,
                  size: 30,
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: styles.frame.primaryTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAddButton() {
    return ClipRRect(
      borderRadius: styles.frame.borderRadius,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onAdd,
          child: Ink(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add_rounded,
                  color: styles.frame.primaryTextColor,
                  size: 30,
                ),
                const SizedBox(width: 4),
                Text(
                  'Ajouter',
                  style: TextStyle(
                    color: styles.frame.primaryTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black26,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                  '$numberSelected sélectionné${numberSelected! > 1 ? 's' : ''}',
                  style: styles.frame.bigText),
            ),
            onCopy != null
                ? buildButton(
                    icon: Icons.copy_rounded,
                    label: 'Copier',
                    onPressed: onCopy)
                : const SizedBox.shrink(),
            onMove != null
                ? buildButton(
                    icon: Icons.import_export,
                    label: 'Déplacer',
                    onPressed: onMove)
                : const SizedBox.shrink(),
            onDelete != null
                ? buildButton(
                    icon: Icons.delete_rounded,
                    label: 'Supprimer',
                    onPressed: onDelete)
                : const SizedBox.shrink(),
            onAdd != null ? buildAddButton() : const SizedBox.shrink(),
          ],
        ));
  }
}
