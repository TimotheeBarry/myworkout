import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:myworkout/core/util/custom_app_bar.dart';
import 'package:myworkout/core/util/custom_button.dart';
import 'package:myworkout/core/util/save_button.dart';
import 'package:myworkout/profile/model/dao/user_dao.dart';
import 'package:myworkout/profile/model/entity/user.dart';
import 'package:myworkout/profile/model/entity/user_measurements.dart';
import '../../core/theme/styles.dart' as styles;

class EditMeasurementsView extends StatefulWidget {
  const EditMeasurementsView({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  State<EditMeasurementsView> createState() => _EditMeasurementsViewState();
}

class _EditMeasurementsViewState extends State<EditMeasurementsView> {
  late DateTime date;
  var userMeasurements = UserMeasurements();

  @override
  void initState() {
    super.initState();
    date = DateTime.now();
  }

  Widget customRow({
    required String name,
    required void Function(String) onChanged,
    Color? color,
  }) {
    return Container(
      decoration: BoxDecoration(color: color ?? Colors.transparent),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                name,
                style: styles.frame.subtitle,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: TextFormField(
                onChanged: onChanged,
                style: styles.list.subtitle,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '0.0',
                  contentPadding: EdgeInsets.all(0),
                  hintStyle: styles.input.hintStyle,
                  enabledBorder: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.white, width: 1),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: Text('cm',
                  textAlign: TextAlign.center, style: styles.frame.text))
        ],
      ),
    );
  }

  Widget buildMeasurementInputs() {
    /*creer le tableau des mensurations (la liste)*/
    return Container(
      margin: styles.frame.margin,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: styles.frame.boxDecoration,
          child: ClipRRect(
            borderRadius: styles.frame.borderRadius,
            child: Column(children: [
              customRow(
                  name: 'Cou',
                  onChanged: (value) {
                    setState(() {
                      userMeasurements.neck =
                          value.isNotEmpty ? double.parse(value) : null;
                    });
                  }),
              customRow(
                  name: 'Epaules',
                  onChanged: (value) {
                    setState(() {
                      userMeasurements.shoulders =
                          value.isNotEmpty ? double.parse(value) : null;
                    });
                  },
                  color: Colors.white10),
              customRow(
                  name: 'Pecs',
                  onChanged: (value) {
                    setState(() {
                      userMeasurements.chest =
                          value.isNotEmpty ? double.parse(value) : null;
                    });
                  }),
              customRow(
                  name: 'Biceps (G)',
                  onChanged: (value) {
                    setState(() {
                      userMeasurements.bicepsL =
                          value.isNotEmpty ? double.parse(value) : null;
                    });
                  },
                  color: Colors.white10),
              customRow(
                  name: 'Biceps (D)',
                  onChanged: (value) {
                    setState(() {
                      userMeasurements.bicepsR =
                          value.isNotEmpty ? double.parse(value) : null;
                    });
                  }),
              customRow(
                  name: 'Avant-Bras (G)',
                  onChanged: (value) {
                    setState(() {
                      userMeasurements.forearmL =
                          value.isNotEmpty ? double.parse(value) : null;
                    });
                  },
                  color: Colors.white10),
              customRow(
                  name: 'Avant-Bras (D)',
                  onChanged: (value) {
                    setState(() {
                      userMeasurements.forearmR =
                          value.isNotEmpty ? double.parse(value) : null;
                    });
                  }),
              customRow(
                  name: 'Poignet (G)',
                  onChanged: (value) {
                    setState(() {
                      userMeasurements.wristL =
                          value.isNotEmpty ? double.parse(value) : null;
                    });
                  },
                  color: Colors.white10),
              customRow(
                  name: 'Poignet (D)',
                  onChanged: (value) {
                    setState(() {
                      userMeasurements.wristR =
                          value.isNotEmpty ? double.parse(value) : null;
                    });
                  }),
              customRow(
                  name: 'Taille',
                  onChanged: (value) {
                    setState(() {
                      userMeasurements.waist =
                          value.isNotEmpty ? double.parse(value) : null;
                    });
                  },
                  color: Colors.white10),
              customRow(
                  name: 'Hanches',
                  onChanged: (value) {
                    setState(() {
                      userMeasurements.hips =
                          value.isNotEmpty ? double.parse(value) : null;
                    });
                  }),
              customRow(
                  name: 'Cuisse (G)',
                  onChanged: (value) {
                    setState(() {
                      userMeasurements.thighL =
                          value.isNotEmpty ? double.parse(value) : null;
                    });
                  },
                  color: Colors.white10),
              customRow(
                  name: 'Cuisse (D)',
                  onChanged: (value) {
                    setState(() {
                      userMeasurements.thighR =
                          value.isNotEmpty ? double.parse(value) : null;
                    });
                  }),
              customRow(
                  name: 'Mollet (G)',
                  onChanged: (value) {
                    setState(() {
                      userMeasurements.calveL =
                          value.isNotEmpty ? double.parse(value) : null;
                    });
                  },
                  color: Colors.white10),
              customRow(
                  name: 'Mollet (D)',
                  onChanged: (value) {
                    setState(() {
                      userMeasurements.calveR =
                          value.isNotEmpty ? double.parse(value) : null;
                    });
                  }),
              customRow(
                  name: 'Cheville (G)',
                  onChanged: (value) {
                    setState(() {
                      userMeasurements.ankleL =
                          value.isNotEmpty ? double.parse(value) : null;
                    });
                  },
                  color: Colors.white10),
              customRow(
                  name: 'Cheville (D)',
                  onChanged: (value) {
                    setState(() {
                      userMeasurements.ankleR =
                          value.isNotEmpty ? double.parse(value) : null;
                    });
                  }),
            ]),
          ),
        ),
      ),
    );
  }

  Widget buildDateFrame(BuildContext context) {
    return Container(
      margin: styles.frame.margin,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: styles.frame.boxDecoration,
          child: Column(
            children: [
              Center(
                  child:
                      Text('Date de la mesure:', style: styles.frame.subtitle)),
              styles.form.littleVoidSpace,
              CustomButton(
                  icon: Icon(Icons.calendar_month,
                      color: styles.button.foregroundColor),
                  title: Text(DateFormat('d MMM yyyy').format(date),
                      style: styles.button.mediumText),
                  onTap: () async {
                    DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (newDate != null) {
                      setState(() {
                        date = newDate;
                      });
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: styles.page.boxDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CustomAppBar(title: 'Editer les mensurations'),
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildDateFrame(context),
              buildMeasurementInputs(),
              styles.form.mediumVoidSpace,
              SaveButton(onTap: () async {
                final dao = UserDao();
                await dao.saveUserMeasurements(userMeasurements, date).then(
                      (value) => Navigator.pop(context),
                    );
              }),
              styles.form.mediumVoidSpace,
            ],
          ),
        ),
      ),
    );
  }
}
