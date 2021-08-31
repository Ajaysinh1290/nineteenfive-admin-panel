import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_admin_panel/models/order.dart';
import 'package:nineteenfive_admin_panel/models/promo_code.dart';
import 'package:nineteenfive_admin_panel/screens/categories/add_category.dart';
import 'package:nineteenfive_admin_panel/screens/promocodes/add_promo_code.dart';
import 'package:nineteenfive_admin_panel/utils/color_palette.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';
import 'package:nineteenfive_admin_panel/utils/data/dummy_data.dart';
import 'package:nineteenfive_admin_panel/widgets/dialog/my_dialog.dart';
import 'package:nineteenfive_admin_panel/widgets/drop_down_button/my_drop_down_button.dart';
import 'package:nineteenfive_admin_panel/widgets/table/my_table.dart';

class PromoCodeScreen extends StatefulWidget {
  const PromoCodeScreen({Key? key}) : super(key: key);

  @override
  _PromoCodeScreenState createState() => _PromoCodeScreenState();
}

class _PromoCodeScreenState extends State<PromoCodeScreen> {
  ScrollController mainScrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  addNewPromoCode(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AddPromoCode();
        });
    setState(() {});
  }

  editPromoCode(BuildContext context, PromoCode promoCode) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AddPromoCode.updatePromoCode(promoCode);
        });
    setState(() {});
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Flex(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  direction: MediaQuery.of(context).size.width > 470
                      ? Axis.horizontal
                      : Axis.vertical,
                  children: [
                    Text(
                      "Promocodes",
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      onTap: () {
                        addNewPromoCode(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 20),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(
                                Constants.buttonBorderRadius)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              size: 20,
                              color: Theme.of(context).accentColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                'Add Promocode',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('promocodes')
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  late List<PromoCode> promoCodes;
                  if (snapshot.hasData) {
                    List data = snapshot.data.docs;
                    promoCodes = [];
                    data.forEach((element) {
                      promoCodes.add(PromoCode.fromJson(element.data()));
                    });
                    promoCodes = promoCodes.reversed.toList();
                  }
                  return !snapshot.hasData
                      ? Container(
                          width: double.infinity,
                          height: 400,
                          margin: EdgeInsets.all(20.0),
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(
                                  Constants.tableBorderRadius),
                              border: Border.all(
                                  color: Colors.grey[800] ?? Colors.grey,
                                  width: 1)),
                        )
                      : MyTable(
                          columns: List.generate(
                              Constants.promoCodesTableColumns.length,
                              (index) => DataColumn(
                                      label: Text(
                                    Constants.promoCodesTableColumns[index],
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ))),
                          rows: List.generate(
                              promoCodes.length,
                              (index) => DataRow(
                                      onSelectChanged: (_) {
                                        editPromoCode(
                                            context, promoCodes[index]);
                                      },
                                      cells: [
                                        DataCell(Row(
                                          children: [
                                            Text(
                                                '${promoCodes[index].promoCode}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  Clipboard.setData(
                                                      ClipboardData(
                                                          text:
                                                              promoCodes[index]
                                                                  .promoCode)).then((value) {
                                                                    MyDialog.showMyDialog(context, 'Promo code copied to clipboard');
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.copy,
                                                  size: 20,
                                                  color: Colors.white,
                                                ))
                                          ],
                                        )),
                                        DataCell(Text(
                                          Constants.currencySymbol +
                                              promoCodes[index]
                                                  .discount
                                                  .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5!
                                              .copyWith(
                                                  fontFamily:
                                                      GoogleFonts.openSans()
                                                          .fontFamily),
                                        )),
                                        DataCell(Text(
                                            Constants.onlyDateFormat.format(
                                                promoCodes[index].activeOn),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5)),
                                        DataCell(Text(
                                            Constants.onlyDateFormat.format(
                                                promoCodes[index].expireOn),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5)),
                                      ])),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
