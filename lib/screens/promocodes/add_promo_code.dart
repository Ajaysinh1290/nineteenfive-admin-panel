import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nineteenfive_admin_panel/firebase/database/firebase_database.dart';
import 'package:nineteenfive_admin_panel/models/promo_code.dart';
import 'package:nineteenfive_admin_panel/utils/color_palette.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';
import 'package:nineteenfive_admin_panel/utils/device_info.dart';
import 'package:nineteenfive_admin_panel/widgets/button/long_blue_button.dart';
import 'dart:async';

import 'package:nineteenfive_admin_panel/widgets/dialog/my_dialog.dart';
import 'package:nineteenfive_admin_panel/widgets/text_field/basic_text_field.dart';

class AddPromoCode extends StatefulWidget {
  PromoCode? promoCode;

  AddPromoCode({Key? key}) : super(key: key);

  AddPromoCode.updatePromoCode(this.promoCode);

  @override
  _AddPromoCodeState createState() => _AddPromoCodeState();
}

class _AddPromoCodeState extends State<AddPromoCode> {
  double height = 210;
  GlobalKey<FormState> formKey = GlobalKey();
  ScrollController scrollController = ScrollController();

  TextEditingController discountController = TextEditingController();
  TextEditingController promoCodeNameController = TextEditingController();
  DateTime activeDate = DateTime.now();

  DateTime expireDate = DateTime.now();

  Future<DateTime> getDate(BuildContext context) async {
    DateTime date = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Theme.of(context).accentColor,
              onPrimary: Colors.black,
              surface: Theme.of(context).primaryColor,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Theme.of(context).cardColor,
          ),
          child: child ?? Container(),
        );
      },
      initialDate: date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != date)
      setState(() {
        date = picked;
      });
    return date;
  }

  validate() async {
    bool formValidate = formKey.currentState!.validate();
    if (formValidate && !validateDate()) {
      MyDialog.showMyDialog(
          context, "Expire date is must be greater than active date");
    } else if (await isPromoCodeAvailable()) {
      MyDialog.showMyDialog(context, "Promocode is already available");
    } else {

      if(formValidate) {
        if (widget.promoCode != null) {
          editPromoCode();
        } else {
          addPromoCode();
        }
      }

    }
  }

  Future<bool> isPromoCodeAvailable() async {
    bool isAvailable = false;
    if (widget.promoCode != null &&
        widget.promoCode!.promoCode == promoCodeNameController.text) {
      return isAvailable;
    }
    MyDialog.showLoading(context);
    await FirebaseFirestore.instance
        .collection('promocodes')
        .where('promo_code', isEqualTo: promoCodeNameController.text)
        .get()
        .then((QuerySnapshot snapshot) {
      isAvailable = snapshot.docs.length > 0;
    });
    Navigator.pop(context);
    return isAvailable;
  }

  bool validateDate() {
    DateTime firstDate = Constants.onlyDateFormat
        .parse(Constants.onlyDateFormat.format(activeDate));
    DateTime lastDate = Constants.onlyDateFormat
        .parse(Constants.onlyDateFormat.format(expireDate));
    return lastDate.difference(firstDate).inDays > 0;
  }

  editPromoCode() async {
    MyDialog.showLoading(context);
    widget.promoCode!.promoCode = promoCodeNameController.text;
    widget.promoCode!.discount = int.parse(discountController.text);
    widget.promoCode!.activeOn = activeDate;
    widget.promoCode!.expireOn = expireDate;
    await FirebaseDatabase.storePromoCode(widget.promoCode);
    Navigator.pop(context);
    Navigator.pop(context);
    MyDialog.showMyDialog(context, "Promo code Updated");
  }

  addPromoCode() async {
    MyDialog.showLoading(context);
    PromoCode promoCode = PromoCode(
        promoCodeId: DateTime.now().millisecondsSinceEpoch.toString(),
        promoCode: promoCodeNameController.text,
        discount: int.parse(discountController.text),
        activeOn: activeDate,
        expireOn: expireDate);
    await FirebaseDatabase.storePromoCode(promoCode);
    Navigator.pop(context);
    Navigator.pop(context);
    MyDialog.showMyDialog(context, "Promo code Published");
  }

  String? validator(value) {
    if (value.isEmpty) {
      return "* Required";
    } else {
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.promoCode != null) {
      promoCodeNameController.text = widget.promoCode!.promoCode;
      discountController.text = widget.promoCode!.discount.toString();
      activeDate = widget.promoCode!.activeOn;
      expireDate = widget.promoCode!.expireOn;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Text(
                widget.promoCode != null ? 'Update Promo code' : 'New Promo code',
                style: Theme.of(context).textTheme.bodyText1,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: 26,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            height: 2,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      titlePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      content: Container(
        width: DeviceInfo.isMobile(context)
            ? MediaQuery.of(context).size.width * 0.8
            : 500,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 28),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BasicTextField(
                    labelText: 'Promocode',
                    controller: promoCodeNameController,
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return "* Required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  BasicTextField(
                    labelText: 'Discount',
                    controller: discountController,
                    textInputType: TextInputType.number,
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
                  SizedBox(height: 20),
                  Text(
                    'Active on',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Constants.onlyDateFormat.format(activeDate),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.date_range,
                          size: 22,
                          color: Theme.of(context).accentColor,
                        ),
                        onPressed: () async {
                          activeDate = await getDate(context);
                          setState(() {});
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Expire on',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Constants.onlyDateFormat.format(expireDate),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.date_range,
                          size: 22,
                          color: Theme.of(context).accentColor,
                        ),
                        onPressed: () async {
                          expireDate = await getDate(context);
                          setState(() {});
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      contentPadding: EdgeInsets.all(0),
      actionsPadding: EdgeInsets.symmetric(horizontal: 20),
      actions: [
        Container(
          width: double.infinity,
          height: 2,
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (!DeviceInfo.isMobile(context))
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
            if (!DeviceInfo.isMobile(context))
              SizedBox(
                width: 10,
              ),
            Flexible(
              flex: DeviceInfo.isMobile(context) ? 1 : 0,
              child: LongBlueButton(
                width: DeviceInfo.isMobile(context) ? double.infinity : 150,
                text: widget.promoCode != null ? 'Update' : 'Publish',
                onPressed: () => validate(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
