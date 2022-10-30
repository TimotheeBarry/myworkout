import 'package:flutter/material.dart';
import 'package:myworkout/core/util/custom_floating_button.dart';
import 'package:myworkout/exercises/view/create_exercise_view.dart';
import 'package:myworkout/workouts/view/create_workout_view.dart';
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
  final GlobalKey<ExercisesViewState> _exercisesKey = GlobalKey();
  final GlobalKey<ExercisesViewState> _workoutsKey = GlobalKey();

  void setPage(index) {
    setState(() => {currentIndex = index});
  }

  Widget? buildFloatingActionButton() {
    switch (currentIndex) {
      case 2:
        return CustomFloatingButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateExerciseView(),
            ),
          ).then((_) => _exercisesKey.currentState!.synchronize()),
        );
      case 3:
        return CustomFloatingButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateWorkoutView(),
            ),
          ).then((_) => _workoutsKey.currentState!.synchronize()),
        );
      default:
        return null;
    }
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
        floatingActionButton: buildFloatingActionButton(),
        body: PageView(
          onPageChanged: (index) {
            setPage(index);
          },
          controller: _pageController,
          children: [
            ProfileView(),
            StatisticsView(),
            ExercisesView(key: _exercisesKey),
            WorkoutsView(),
          ],
        ),
      ),
    );
  }
}
