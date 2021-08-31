import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nineteenfive_admin_panel/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_admin_panel/widgets/dialog/my_dialog.dart';
import 'package:nineteenfive_admin_panel/widgets/text_field/basic_text_field.dart';

class EditAbout extends StatelessWidget {
  final String about;

  EditAbout({Key? key, required this.about}) : super(key: key);
  updateAbout(String about,BuildContext context) async {
    MyDialog.showLoading(context);
    await FirebaseFirestore.instance
        .collection('admin')
        .doc('about')
        .set({'about': about});
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController aboutController = TextEditingController(text: about);

    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Align(
        alignment: Alignment.center,
        child: Text(
          "About",
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      content: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).primaryColor,
        child: BasicTextField(
          labelText: 'About',
          expanded: true,
          controller: aboutController,
          textInputType: TextInputType.multiline,
          validator: (value) {
            if (value.toString().isEmpty) {
              return "* Required";
            } else {
              return null;
            }
          },
        ),
      ),
      actions: [
        LongBlueButton(
          width: 100,
          color: Colors.transparent,
          textStyle: Theme.of(context)
              .textTheme
              .headline3!
              .copyWith(color: Colors.white),
          text: 'Cancel',
          onPressed: () => Navigator.pop(context),
        ),
        SizedBox(
          width: 10,
        ),
        LongBlueButton(
            width: 150,
            text: 'Update',
            onPressed: () {
              updateAbout(aboutController.text,context);
              Navigator.pop(context);
            }),
      ],
    );
  }
}
