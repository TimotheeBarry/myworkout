import 'package:flutter/material.dart';
import 'package:myworkout/core/util/custom_app_bar.dart';
import 'package:myworkout/profile/model/entity/user.dart';
import 'package:myworkout/profile/util/line_chart.dart';
import '../../core/theme/styles.dart' as styles;

class ProfileStatisticsView extends StatefulWidget {
  const ProfileStatisticsView({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  State<ProfileStatisticsView> createState() => _ProfileStatisticsViewState();
}

class _ProfileStatisticsViewState extends State<ProfileStatisticsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: styles.page.boxDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CustomAppBar(title: 'Statistiques'),
        body: SingleChildScrollView(
          child: Column(children: [SizedBox(height: 350, child: LineChart())]),
        ),
      ),
    );
  }
}
