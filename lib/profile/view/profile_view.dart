import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/styles.dart' as styles;

class ProfileView extends StatelessWidget {
  ProfileView({Key? key}) : super(key: key);

  Widget buildPersonalDataFrame(BuildContext context) {
    return Container(
        margin: styles.frame.margin,
        child: Ink(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: styles.frame.boxDecoration,
            child: buildFrameData(context: context)));
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
          Text('Tim', style: styles.frame.subtitle),
          Text('22 y.o', style: styles.frame.subtitle),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(FontAwesomeIcons.mars, color: styles.frame.color),
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
              text: '180 cm'),
          buildPersonalDataRow(
              context: context,
              icon: FontAwesomeIcons.weightScale,
              text: '77 kg'),
          buildPersonalDataRow(
              context: context,
              icon: FontAwesomeIcons.droplet,
              text: '15 % BF'),
          buildPersonalDataRow(
              context: context,
              icon: FontAwesomeIcons.calculator,
              text: '23.8 BMI'),
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
            child: FaIcon(icon, size: 16, color: styles.frame.color),
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
              color: styles.frame.color),
        ),
        const SizedBox(width: 20),
        IconButton(
            onPressed: () {},
            icon:
                FaIcon(FontAwesomeIcons.chartLine, color: styles.frame.color)),
        const SizedBox(width: 20),
        IconButton(
          onPressed: () {},
          icon: FaIcon(FontAwesomeIcons.shareNodes, color: styles.frame.color),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [buildPersonalDataFrame(context)],
    ));
  }
}
