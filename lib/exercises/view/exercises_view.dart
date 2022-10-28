import 'package:flutter/material.dart';
import '../../core/theme/styles.dart' as styles;

class ExercisesView extends StatelessWidget {
  const ExercisesView({Key? key}) : super(key: key);

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
                leading: const SizedBox(
                  height: 40,
                  width: 40,
                  child: Placeholder(),
                ),
                title: Text('Group', style: styles.list.title),
                trailing: Text('5', style: styles.list.title),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (_, index) {
                      return buildExercise(context);
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

  Widget buildExercise(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: ListTile(
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              SizedBox(
                width: 80,
                child: Placeholder(),
              ),
            ],
          ),
          title: Text(
            'exercise name',
            style: styles.list.title,
          ),
          subtitle: Text(
            'Lorem ipsum dolor sit amet. Sit voluptatem corrupti et laborum',
            style: styles.list.description,
          ),
          isThreeLine: true,
          onLongPress: () {},
          onTap: () {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 20,
      itemBuilder: (context, i) {
        return buildGroup(context);
      },
    );
  }
}
