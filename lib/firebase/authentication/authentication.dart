import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:nineteenfive_admin_panel/widgets/dialog/my_dialog.dart';

class MyFirebaseAuth {
  BuildContext context;
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  MyFirebaseAuth(this.context);

  final String email = 'admin@admin.com';

  Future<bool> signIn(String password) async {
    try {
      MyDialog.showLoading(context);
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        MyDialog.showMyDialog(context, 'Email is not found!');
      } else if (e.code == 'wrong-password') {
        MyDialog.showMyDialog(context, "Wrong password!");
      } else {
        MyDialog.showMyDialog(context, e.message);
      }
    } catch (e) {
      Navigator.pop(context);
      await MyDialog.showMyDialog(context, 'Error');
      print(e);
    }
    return false;
  }

  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    try {
      MyDialog.showLoading(context);
      print(FirebaseAuth.instance.currentUser);
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: oldPassword);
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
      return true;
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        MyDialog.showMyDialog(context, 'Email is not found!');
      } else if (e.code == 'wrong-password') {
        MyDialog.showMyDialog(context, "Wrong password!");
      } else {
        MyDialog.showMyDialog(context, e.message);
      }
    } catch (e) {
      Navigator.pop(context);
      await MyDialog.showMyDialog(context, 'Error\n${e.toString()}');
      print(e);
    }
    return false;
  }
}
