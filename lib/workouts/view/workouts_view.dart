import 'package:flutter/material.dart';
import '../../core/theme/styles.dart' as styles;

class WorkoutsView extends StatelessWidget {
  WorkoutsView({Key? key}) : super(key: key);
  @override
  Widget buildGroup(BuildContext context) {
    return Container(
      margin: styles.list.margin,
      child: ClipRRect(
        borderRadius: styles.list.borderRadius,
        child: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: styles.frame.boxDecoration,
            child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Text('Group', style: styles.list.title),
                trailing: Text('5', style: styles.list.title),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (_, index) {
                      return buildWorkout(context);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildWorkout(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: ListTile(
          title: Text(
            'workout name',
            style: styles.list.title,
          ),
          onLongPress: () {},
          onTap: () {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 8,
      itemBuilder: (context, i) {
        return buildGroup(context);
      },
    );
  }
}
