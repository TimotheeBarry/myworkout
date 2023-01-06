import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myworkout/core/util/custom_app_bar.dart';
import 'package:myworkout/core/util/custom_list_tile.dart';
import 'package:myworkout/core/util/functions.dart';
import 'package:myworkout/profile/model/dao/user_dao.dart';
import 'package:myworkout/profile/model/entity/user.dart';
import 'package:myworkout/profile/model/entity/user_statistic.dart';
import 'package:myworkout/profile/util/line_chart.dart';
import '../../core/theme/styles.dart' as styles;

class ProfileStatisticsView extends StatefulWidget {
  const ProfileStatisticsView({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  State<ProfileStatisticsView> createState() => _ProfileStatisticsViewState();
}

class _ProfileStatisticsViewState extends State<ProfileStatisticsView> {
  String type = 'weight';
  List<UserStatistic> userStatistics = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    final dao = UserDao();
    var _userStatistics = await dao.getUserStatistics(widget.user.id!, type);
    setState(() {
      print(_userStatistics.length);
      userStatistics = _userStatistics.reversed.toList();
    });
  }

  Widget buildItem(UserStatistic userStatistic) {
    return Container(
      margin: styles.list.marginV,
      decoration: styles.frame.boxDecoration,
      child: ClipRRect(
          borderRadius: styles.list.borderRadius,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onLongPress: () {},
              onTap: () {},
              child: Ink(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('dd/MM/yyyy').format(userStatistic.date!),
                        style: styles.frame.bigText),
                    Text(
                        '${roundDecimal(userStatistic.value!.toDouble(), 1)} kg',
                        style: styles.frame.subtitle),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.edit,
                            color: styles.frame.primaryTextColor))
                  ],
                ),
              ),
            ),
          )),
    );
  }

  double get chartHeight {
    var height = (MediaQuery.of(context).size.height - 50);

    var scale = height > 760 ? .4 : .5;

    //-50 pour prendre en compte l'appbar
    print(height*scale);
    return height*scale;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: styles.page.boxDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CustomAppBar(title: 'Statistiques'),
        body: Column(
          children: [
            SizedBox(
              height: chartHeight,
              child: LineChart(
                user: widget.user,
                data: userStatistics,
                type: type,
              ),
            ),
            styles.form.littleVoidSpace,
            Expanded(
              child: ListView.builder(
                padding: styles.page.margin,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemCount: userStatistics.length,
                itemBuilder: (context, i) {
                  return buildItem(userStatistics[i]);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
