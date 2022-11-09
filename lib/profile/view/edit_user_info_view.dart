import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myworkout/core/util/custom_app_bar.dart';
import 'package:myworkout/core/util/custom_button.dart';
import 'package:myworkout/core/util/input_field.dart';
import 'package:myworkout/core/util/save_button.dart';
import 'package:myworkout/profile/model/dao/user_dao.dart';
import 'package:myworkout/profile/model/entity/user.dart';
import 'package:myworkout/profile/model/entity/user_measurements.dart';
import '../../core/theme/styles.dart' as styles;

class EditUserInfoView extends StatefulWidget {
  const EditUserInfoView({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  State<EditUserInfoView> createState() => _EditUserInfoViewState();
}

class _EditUserInfoViewState extends State<EditUserInfoView> {
  late DateTime date;
  late User editedUser;
  late UserMeasurements userMeasurements;

  @override
  void initState() {
    date = DateTime.now();
    editedUser = widget.user.copy();
    userMeasurements = UserMeasurements();
    super.initState();
  }

  Widget buildDateField() {
    return Column(
      children: [
        Text(
          'Date de naissance:',
          style: styles.frame.subtitle,
        ),
        styles.form.littleVoidSpace,
        CustomButton(
          title: Text(
              DateFormat('d MMM yyyy').format(editedUser.birthdate ?? date),
              style: styles.button.mediumText),
          onTap: () async {
            DateTime? newDate = await showDatePicker(
              context: context,
              initialDate: widget.user.birthdate!,
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (newDate != null) {
              setState(() {
                editedUser.birthdate = newDate;
              });
            }
          },
        )
      ],
    );
  }

  Widget buildUsernameField() {
    return Column(
      children: [
        Text('Nom d\'utilisateur', style: styles.frame.subtitle),
        styles.form.littleVoidSpace,
        InputField(
            initialValue: widget.user.username,
            hintText: 'Choisissez un nom d\'utilisateur...',
            onChanged: (username) {
              editedUser.username = username;
            })
      ],
    );
  }

  Widget inputRow(
      {Function(String)? onChanged,
      required String name,
      required String unit}) {
    return Row(
      children: [
        Expanded(
          flex: 1,
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
                contentPadding: const EdgeInsets.all(0),
                hintStyle: styles.input.hintStyle,
                enabledBorder: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.white, width: 1),
                ),
              ),
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child: Text(unit,
                textAlign: TextAlign.center, style: styles.frame.text))
      ],
    );
  }

  Widget buildUserInfoFrame() {
    return Container(
      margin: styles.frame.margin,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: styles.frame.boxDecoration,
          child: ClipRRect(
            borderRadius: styles.frame.borderRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                children: [
                  buildUsernameField(),
                  styles.form.mediumVoidSpace,
                  buildDateField(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMeasurementsFrame() {
    return Container(
      margin: styles.frame.margin,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: styles.frame.boxDecoration,
          child: ClipRRect(
            borderRadius: styles.frame.borderRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                children: [
                  Center(
                      child: Text('Date de la mesure',
                          style: styles.frame.subtitle)),
                  styles.form.littleVoidSpace,
                  CustomButton(
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
                      }),
                  styles.form.bigVoidSpace,
                  //height
                  inputRow(
                      name: 'Taille',
                      unit: 'cm',
                      onChanged: (height) {
                        userMeasurements.height =
                            height != null ? double.parse(height) : null;
                      }),
                  //weight
                  inputRow(
                      name: 'Poids',
                      unit: 'kg',
                      onChanged: (weight) {
                        userMeasurements.weight =
                            weight != null ? double.parse(weight) : null;
                      }),
                  //bodyfat
                  inputRow(
                      name: 'Bodyfat',
                      unit: '%',
                      onChanged: (bodyfat) {
                        userMeasurements.bodyfat =
                            bodyfat != null ? double.parse(bodyfat) : null;
                      }),
                  styles.form.bigVoidSpace,
                  SaveButton(onTap: () async {
                    final dao = UserDao();
                    await dao
                        .saveUserMeasurements(userMeasurements, date)
                        .then((value) => Navigator.pop(context));
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final dao = UserDao();
          await dao
              .updateUser(editedUser)
              .then((value) => Navigator.pop(context));
          return true;
        },
        child: Container(
          decoration: styles.page.boxDecoration,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: const CustomAppBar(title: 'Editer les informations'),
            body: SingleChildScrollView(
              child: Column(children: [
                buildUserInfoFrame(),
                buildMeasurementsFrame(),
              ]),
            ),
          ),
        ));
  }
}
