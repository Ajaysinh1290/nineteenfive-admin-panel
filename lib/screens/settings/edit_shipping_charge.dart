import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';
import 'package:nineteenfive_admin_panel/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_admin_panel/widgets/dialog/my_dialog.dart';
import 'package:nineteenfive_admin_panel/widgets/text_field/basic_text_field.dart';

class EditShippingCharge extends StatelessWidget {
  final int shippingCharge;

  final GlobalKey<FormState> formKey = GlobalKey();

  EditShippingCharge({Key? key, required this.shippingCharge})
      : super(key: key);

  updateShippingCharge(int shippingCharge, BuildContext context) async {
    MyDialog.showLoading(context);
    await FirebaseFirestore.instance
        .collection('admin')
        .doc('settings')
        .set({'shipping_charge': shippingCharge});
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController shippingController =
        TextEditingController(text: shippingCharge.toString());
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Align(
        alignment: Alignment.center,
        child: Text(
          "Shipping Charge",
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width < 450
            ? MediaQuery.of(context).size.width
            : 450,
        child: Form(
          key: formKey,
          child: BasicTextField(
            labelText: 'Shipping Charge',
            textInputType: TextInputType.number,
            controller: shippingController,
            enableInteractiveSelection: false,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            suffixText: Constants.currencySymbol,
            validator: (value) {
              if (value.toString().isEmpty) {
                return "* Required";
              } else {
                return null;
              }
            },
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
              if (formKey.currentState!.validate()) {
                updateShippingCharge(
                    int.parse(shippingController.text), context);
                Navigator.pop(context);
              }
            }),
      ],
    );
  }
}
