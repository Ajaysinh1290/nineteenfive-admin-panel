import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_admin_panel/widgets/dialog/my_dialog.dart';
import 'package:nineteenfive_admin_panel/widgets/text_field/basic_text_field.dart';

class EditPrivacyPolicy extends StatelessWidget {

  final String privacyPolicy;
  EditPrivacyPolicy({Key? key,required this.privacyPolicy}) : super(key: key);

  updatePrimaryPolicy(String primaryPolicy,BuildContext context) async {
    MyDialog.showLoading(context);
    await FirebaseFirestore.instance
        .collection('admin')
        .doc('privacy_policy')
        .set({'privacy_policy': primaryPolicy});
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController primaryPolicyController =
    TextEditingController(text: privacyPolicy);
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Align(
        alignment: Alignment.center,
        child: Text(
          "Primary Policy",
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      content: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).primaryColor,
        child: BasicTextField(
          labelText: 'Primary Policy',
          expanded: true,
          controller: primaryPolicyController,
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
              updatePrimaryPolicy(primaryPolicyController.text,context);
              Navigator.pop(context);
            }),
      ],
    );
  }
}
