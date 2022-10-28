import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class CustomNavigationBar extends StatelessWidget {
  CustomNavigationBar({
    required this.currentIndex,
    required this.pageController,
  });
  int currentIndex;
  PageController pageController;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type:
          BottomNavigationBarType.fixed, // Fixed --> no animation when clicking
      backgroundColor: Color(0x7f000000),
      iconSize: 30,
      selectedItemColor: Colors.white,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: (index) {
        pageController.animateToPage(index,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut);
      },
      //items
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.solidCircleUser),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.chartColumn),
          label: 'Statistics',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.dumbbell),
          label: 'Exercises',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.list),
          label: 'Workouts',
        ),
      ],
    );
  }
}
