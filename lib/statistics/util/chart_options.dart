import 'package:flutter/material.dart';
import '../../core/theme/styles.dart' as styles;

class ChartOptions extends StatefulWidget {
  const ChartOptions({Key? key}) : super(key: key);

  @override
  State<ChartOptions> createState() => _ChartOptionsState();
}

class _ChartOptionsState extends State<ChartOptions> {
  int selectedOption = 0;

  Widget buildOption(BuildContext context, int index, String title) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSelected = index == selectedOption;
    return Container(
      width: screenWidth / 5,
      height: 32,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: isSelected ? Color(0x63ffffff) : Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                selectedOption = index;
              });
            },
            child: Ink(
              decoration: BoxDecoration(),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                      color: isSelected
                          ? styles.frame.primaryTextColor
                          : styles.frame.secondaryTextColor,
                      fontSize: isSelected ? 16 : 15,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0x63000000),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildOption(context, 0, '7j'),
          buildOption(context, 1, '30j'),
          buildOption(context, 2, '90j'),
          buildOption(context, 3, '1 an'),
          buildOption(context, 4, 'Tout'),
        ],
      ),
    );
  }
}
