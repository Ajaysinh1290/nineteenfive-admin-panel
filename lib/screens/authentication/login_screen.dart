import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/firebase/authentication/authentication.dart';
import 'package:nineteenfive_admin_panel/screens/home/load_data.dart';
import 'package:nineteenfive_admin_panel/utils/device_info.dart';
import 'package:nineteenfive_admin_panel/widgets/button/long_blue_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController passwordFieldController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  void login() async {
    if(formKey.currentState!.validate()) {
      bool result = await MyFirebaseAuth(context).signIn(passwordFieldController.text);
      if(result) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoadData()));
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: DeviceInfo.isMobile(context) ? double.infinity : 500,
          alignment: Alignment.center,
          constraints: BoxConstraints(
            maxHeight: 500
          ),
          padding: EdgeInsets.all(30.0),
          margin: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                  child: Image.asset(
                    'assets/logo/round_shaped_logo_with_white_background.png',
                    fit: BoxFit.cover,
                    width: 75,
                    height: 75,
                  )),
              SizedBox(
                height: 20,
              ),
              Text('Enter Admin Password',textAlign: TextAlign.center,),
              SizedBox(
                height: 50,
              ),
              Form(
                key: formKey,
                child: TextFormField(
                  validator: (value){
                    if(value.toString().isEmpty) {
                      return "* Required";
                    } else {
                      return null;
                    }
                  },
                  onEditingComplete: login,
                  controller: passwordFieldController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: Theme.of(context).textTheme.headline6,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)
                    ),

                    focusColor: Colors.white,
                  ),
                  style: Theme.of(context).textTheme.headline5,
                  obscureText: true,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              LongBlueButton(
                height: 60,
                text: 'Login',
                onPressed: login,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
