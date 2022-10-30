import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/styles.dart' as styles;

class WorkoutListItem extends StatelessWidget {
  const WorkoutListItem({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: const EdgeInsets.symmetric(vertical: 1),
      child: ClipRRect(
        //borderRadius: BorderRadius.circular(10),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: Ink(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 12),
              decoration: BoxDecoration(color: Color.fromARGB(255, 54, 53, 132)),
              child: Column(
                children: [
                  ListTile(
                    leading: const SizedBox(
                      height: 40,
                      width: 40,
                      child: Placeholder(),
                    ),
                    title: Text('Nom exercice', style: styles.frame.subtitle),
                    trailing: ReorderableDragStartListener(
                      index: index,
                      child: Icon(
                        Icons.drag_handle,
                        color: styles.frame.primaryTextColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    margin: EdgeInsets.only(top: 4),
                    child: Column(
                      children: [
                        Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flex(
                              direction: Axis.vertical,
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: Row(children: [
                                    FaIcon(FontAwesomeIcons.chartLine,
                                        size: 12,
                                        color: styles.frame.primaryTextColor),
                                    SizedBox(width: 8),
                                    Text('4 x 8', style: styles.frame.text)
                                  ]),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: Row(children: [
                                    FaIcon(FontAwesomeIcons.weightHanging,
                                        size: 12,
                                        color: styles.frame.primaryTextColor),
                                    SizedBox(width: 8),
                                    Text('80 kg', style: styles.frame.text)
                                  ]),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: Row(children: [
                                    FaIcon(FontAwesomeIcons.hourglass,
                                        size: 12,
                                        color: styles.frame.primaryTextColor),
                                    SizedBox(width: 8),
                                    Text('1"30', style: styles.frame.text)
                                  ]),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 50,
                              width: 80,
                              child: Placeholder(),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
