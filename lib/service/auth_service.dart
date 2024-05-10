import 'package:chat_app/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;


  // login


  // register
  Future registerUserWithEmailAndPassword(String fullName, String email, String password) async{
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user!;

      if (user != null) {
        // call our database service to update the user data
        await DataBaseService(uid: user.uid).updateUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // signout
}