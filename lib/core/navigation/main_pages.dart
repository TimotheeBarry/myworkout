import 'package:flutter/material.dart';

import '../../exercises/view/exercises_view.dart';
import '../../profile/view/profile_view.dart';
import '../../statistics/view/statistics_view.dart';
import '../../workouts/view/workouts_view.dart';
import '../util/custom_app_bar.dart';
import 'custom_navigation_bar.dart';
import '../theme/styles.dart' as styles;

class MainPages extends StatefulWidget {
  const MainPages({super.key});

  @override
  State<MainPages> createState() => _MainPagesState();
}

class _MainPagesState extends State<MainPages> {
  int? currentIndex;
  final PageController _pageController = PageController(initialPage: 0);

  void setPage(index) {
    setState(() => {currentIndex = index});
  }

  @override
  initState() {
    currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: styles.page.boxDecoration,
      child: Scaffold(
        appBar: CustomAppBar(title: 'MyWorkout', actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
            ),
            onPressed: () {},
          )
        ]),
        backgroundColor: Colors.transparent,
        bottomNavigationBar: CustomNavigationBar(
          currentIndex: currentIndex!,
          pageController: _pageController,
        ),
        body: PageView(
          onPageChanged: (index) {
            setPage(index);
          },
          controller: _pageController,
          children: [
            ProfileView(),
            StatisticsView(),
            ExercisesView(),
            WorkoutsView(),
          ],
        ),
      ),
    );
  }
}
