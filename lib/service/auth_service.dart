import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // login
  Future loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }


  // register
  Future registerUserWithEmailAndPassword(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        // call our database service to update the user data
        await DataBaseService(uid: user.uid).savingUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // signout
  Future signOut() async {
    try {
      await HelperFunction.saveUserLoggedInStatus(false);
      await HelperFunction.saveUserNameSF("");
      await HelperFunction.saveEmailNameSF("");
      await firebaseAuth.signOut();
    } on Exception catch (e) {
      return null;
    }
  }
}
