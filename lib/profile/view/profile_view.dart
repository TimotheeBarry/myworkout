import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myworkout/profile/model/dao/user_dao.dart';
import 'package:myworkout/profile/model/entity/user_measurements.dart';
import '../../core/theme/styles.dart' as styles;
import '../model/entity/user.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  var user = User();
  var userMeasurement = UserMeasurements();

  @override
  void initState() {
    super.initState();
    synchronize();
  }

  void synchronize() async {
    final userDao = UserDao();
    User _user = await userDao.getUser();
    setState(() {
      user = _user;
    });
    UserMeasurements _userMeasurement =
        await userDao.getLatestUserMeasurements();
    setState(() {
      userMeasurement = _userMeasurement;
    });
  }

  Widget buildPersonalDataFrame(BuildContext context) {
    return Container(
        margin: styles.frame.margin,
        child: Material(
            color: Colors.transparent,
            child: Ink(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: styles.frame.boxDecoration,
                child: buildFrameData(context: context))));
  }

  Widget buildFrameData({required BuildContext context}) {
    return Column(
      children: [
        Row(
          children: [
            buildPersonalDataLeft(context: context),
            buildPersonalDataRight(context: context)
          ],
        ),
        const SizedBox(height: 12),
        buildPersonalDataButtons(context: context)
      ],
    );
  }

  Widget buildPersonalDataLeft({
    required BuildContext context,
  }) {
    return Flexible(
      fit: FlexFit.tight,
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(user.username ?? '?', style: styles.frame.subtitle),
          Text(
            '${user.age() ?? '?'} y.o',
            style: styles.frame.subtitle,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(FontAwesomeIcons.mars,
                  color: styles.frame.primaryTextColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPersonalDataRight({required BuildContext context}) {
    return Flexible(
      //flex: 1,
      child: Column(
        children: [
          buildPersonalDataRow(
              context: context,
              icon: FontAwesomeIcons.rulerVertical,
              text: '${userMeasurement.height ?? '?'} cm'),
          buildPersonalDataRow(
              context: context,
              icon: FontAwesomeIcons.weightScale,
              text: '${userMeasurement.weight ?? '?'} kg'),
          buildPersonalDataRow(
              context: context,
              icon: FontAwesomeIcons.droplet,
              text: '${userMeasurement.bodyfat ?? '?'} % BF'),
          buildPersonalDataRow(
              context: context,
              icon: FontAwesomeIcons.calculator,
              text: '${userMeasurement.bmi() ?? '?'} BMI'),
        ],
      ),
    );
  }

  Widget buildPersonalDataRow(
      {required BuildContext context, IconData? icon, required String text}) {
    return Row(
      //direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 20,
          width: 30,
          child: Center(
            child: FaIcon(icon, size: 16, color: styles.frame.primaryTextColor),
          ),
        ),
        Text(text, textAlign: TextAlign.left, style: styles.frame.subtitle),
      ],
    );
  }

  Widget buildPersonalDataButtons({required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {},
          icon: FaIcon(FontAwesomeIcons.solidPenToSquare,
              color: styles.frame.primaryTextColor),
        ),
        const SizedBox(width: 20),
        IconButton(
            onPressed: () {},
            icon: FaIcon(FontAwesomeIcons.chartLine,
                color: styles.frame.primaryTextColor)),
        const SizedBox(width: 20),
        IconButton(
          onPressed: () {},
          icon: FaIcon(FontAwesomeIcons.shareNodes,
              color: styles.frame.primaryTextColor),
        ),
      ],
    );
  }

  TableRow customTableRow(String name, double? value, {Color? color}) {
    return TableRow(
      decoration: BoxDecoration(color: color ?? Colors.transparent),
      children: [
        TableCell(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Text(
                name,
                style: styles.frame.subtitle,
              ),
            ),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Text(
                value != null ? '$value cm' : 'non renseigné',
                style: value != null
                    ? styles.frame.bigText
                    : styles.list.description,
              ),
            ),
          ),
        )
      ],
    );
  }

  List<TableRow> createTable(BuildContext context) {
    return [
      TableRow(
        children: [
          TableCell(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  'Mensurations',
                  style: styles.frame.title,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: FaIcon(FontAwesomeIcons.solidPenToSquare,
                    color: styles.frame.primaryTextColor),
                onPressed: () {},
              ),
              const SizedBox(width: 24),
              IconButton(
                icon: FaIcon(FontAwesomeIcons.chartLine,
                    color: styles.frame.primaryTextColor),
                onPressed: () {},
              )
            ],
          )
        ],
      ),
      customTableRow('Cou', userMeasurement.neck, color: Colors.white10),
      customTableRow('Epaules', userMeasurement.shoulders),
      customTableRow('Pecs', userMeasurement.chest, color: Colors.white10),
      customTableRow('Biceps (G)', userMeasurement.bicepsL),
      customTableRow('Biceps (D)', userMeasurement.bicepsR,
          color: Colors.white10),
      customTableRow('Avant-Bras (G)', userMeasurement.forearmL),
      customTableRow('Avant-Bras (D)', userMeasurement.forearmR,
          color: Colors.white10),
      customTableRow('Poignet (G)', userMeasurement.wristL),
      customTableRow('Poignet (D)', userMeasurement.wristR,
          color: Colors.white10),
      customTableRow('Taille', userMeasurement.waist),
      customTableRow('Hanches', userMeasurement.hips, color: Colors.white10),
      customTableRow('Cuisse (G)', userMeasurement.thighL),
      customTableRow('Cuisse (D)', userMeasurement.thighR,
          color: Colors.white10),
      customTableRow('Mollet (G)', userMeasurement.calveL),
      customTableRow('Mollet (D)', userMeasurement.calveR,
          color: Colors.white10),
      customTableRow('Cheville (G)', userMeasurement.ankleL),
      customTableRow('Cheville (D)', userMeasurement.ankleR,
          color: Colors.white10),
    ];
  }

  Widget buildMeasurementsTable(BuildContext context) {
    return Container(
      margin: styles.frame.margin,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: styles.frame.boxDecoration,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Table(children: createTable(context))),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        buildPersonalDataFrame(context),
        buildMeasurementsTable(context),
      ],
    ));
  }
}
