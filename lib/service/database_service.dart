import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService{
  final String? uid;

  DataBaseService({required this.uid});

  // reference for our collection
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection = FirebaseFirestore.instance.collection("groups");


  // updating the user data

  Future updateUserData (String fullName, String email) async{
    return await userCollection.doc(uid).set({
      "fullName" : fullName,
      "email" : email,
      "group" : [],
      "profilePicture" : "",
      "uid" : uid
    });
  }

}