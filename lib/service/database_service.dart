import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService{
  final String? uid;

  DataBaseService({required this.uid});

  // reference for our collection

  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection = FirebaseFirestore.instance.collection("group");


  // saving the user data

  Future savingUserData (String fullName, String email) async{
    return await userCollection.doc(uid).set({
      "fullName" : fullName,
      "email" : email,
      "group" : [],
      "profilePicture" : "",
      "uid" : uid
    });
  }

  // geting user data

  Future gettingUserData(String email) async{
    QuerySnapshot snapshot = await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // get user groups
  getUserGroups() async{
    return userCollection.doc(uid).snapshots();
  }
}