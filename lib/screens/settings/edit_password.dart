import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/firebase/authentication/authentication.dart';
import 'package:nineteenfive_admin_panel/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_admin_panel/widgets/dialog/my_dialog.dart';
import 'package:nineteenfive_admin_panel/widgets/text_field/basic_text_field.dart';

class EditPassword extends StatefulWidget {

  EditPassword({Key? key}) : super(key: key);

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  final TextEditingController oldPasswordController = TextEditingController();

  final TextEditingController newPasswordController = TextEditingController();

  final TextEditingController newConfirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey();

  Future<void> validate(BuildContext context) async {
    print('in validate');
    if (formKey.currentState!.validate()) {
      print('validate');
      bool result = await MyFirebaseAuth(context).updatePassword(
          oldPasswordController.text, newPasswordController.text);
      if (result) {
        Navigator.pop(context);
        Navigator.pop(context);
        await MyDialog.showMyDialog(context, 'Password Updated');
      }
    }
  }

  String? passwordValidator(value) {
    if (value.isEmpty)
      return "Required *";
    else if (value.length < 6)
      return "Should be at least 6 characters";
    else if (value.length > 15)
      return "Should not be more than 15 characters";
    else
      return null;
  }

  String? confirmPasswordValidator(value) {
    if (value.isEmpty) {
      return "Required *";
    } else if (newPasswordController.text != value)
      return "Confirm password not matched..!";
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Align(
        alignment: Alignment.center,
        child: Text(
          "Change Password",
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width < 500
            ? MediaQuery.of(context).size.width
            : 500,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BasicTextField(
                labelText: 'Old Password',
                obscureText: true,
                controller: oldPasswordController,
                validator: passwordValidator,
              ),
              SizedBox(height: 20),
              BasicTextField(
                labelText: 'New Password',
                validator: passwordValidator,
                obscureText: true,
                controller: newPasswordController,
              ),
              SizedBox(
                height: 20,
              ),
              BasicTextField(
                labelText: 'Confirm Password',
                validator: confirmPasswordValidator,
                obscureText: true,
                controller: newConfirmPasswordController,
              ),
            ],
          ),
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
              validate(context);
            }),
      ],
    );
  }
}
