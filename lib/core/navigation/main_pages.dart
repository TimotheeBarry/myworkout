import 'package:flutter/material.dart';
import 'package:myworkout/core/util/custom_floating_button.dart';
import 'package:myworkout/core/util/edition_bar.dart';
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
  final GlobalKey<WorkoutsViewState> _workoutsKey = GlobalKey();

  @override
  initState() {
    currentIndex = 0;
    super.initState();
  }

  void setPage(index) {
    setState(() => {currentIndex = index});
  }

  Widget? buildNavigationBar() {
    if (currentIndex == 2 &&
        _exercisesKey.currentState != null &&
        _exercisesKey.currentState!.exercisesSelected.isNotEmpty) {
      return EditionBar(
        numberSelected: _exercisesKey.currentState!.exercisesSelected.length,
        onDelete: () {},
        onCopy: () {},
        onMove: () {},
      );
    } else if (currentIndex == 3 &&
        _workoutsKey.currentState != null &&
        _workoutsKey.currentState!.workoutsSelected.isNotEmpty) {
      return EditionBar(
        numberSelected: _workoutsKey.currentState!.workoutsSelected.length,
        onDelete: () {},
        onCopy: () {},
        onMove: () {},
      );
    } else {
      return CustomNavigationBar(
        currentIndex: currentIndex!,
        pageController: _pageController,
      );
    }
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
        bottomNavigationBar: buildNavigationBar(),
        floatingActionButton: buildFloatingActionButton(),
        body: PageView(
          onPageChanged: (index) {
            setPage(index);
          },
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          controller: _pageController,
          children: [
            ProfileView(),
            StatisticsView(),
            ExercisesView(
                key: _exercisesKey, updateParent: () => setState(() => {})),
            WorkoutsView(
                key: _workoutsKey, updateParent: () => setState(() => {})),
          ],
        ),
      ),
    );
  }
}
