import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/models/order.dart';
import 'package:nineteenfive_admin_panel/models/user_data.dart';
import 'package:nineteenfive_admin_panel/screens/customers/customer_address_and_liked_products.dart';
import 'package:nineteenfive_admin_panel/screens/customers/customer_personal_details.dart';
import 'package:nineteenfive_admin_panel/screens/customers/customers_orders_table.dart';

class CustomerDetails extends StatefulWidget {
  final UserData userData;
  final Function() onBackButtonPressed;

  CustomerDetails(
      {Key? key, required this.userData, required this.onBackButtonPressed})
      : super(key: key);

  @override
  _CustomerDetailsState createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  ScrollController mainScrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: mainScrollController,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: widget.onBackButtonPressed,
                      icon: Icon(
                        Icons.arrow_back_sharp,
                        size: 24,
                        color: Colors.white,
                      )),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    widget.userData.userName,
                    style: Theme.of(context).textTheme.bodyText1,
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Flex(
                direction:MediaQuery.of(context).size.width > 860?Axis.horizontal:Axis.vertical ,
                children: [
                  CustomerPersonalDetails(userData: widget.userData, width: MediaQuery.of(context).size.width > 860?null:double.infinity,),
                  SizedBox(
                    width: 10,
                    height: 10,
                  ),
                  Flexible(
                    flex: MediaQuery.of(context).size.width>860?1:0,
                      child: CustomerAddressAndLikedProducts(
                        userData: widget.userData,
                      )),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              CustomersOrders(userData: widget.userData)
            ],
          ),
        ),
      ),
    );
  }
}
