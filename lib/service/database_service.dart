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

  // creating a group
  Future createGroup (String userName, String id, String groupName) async{
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName" : groupName,
      "groupIcon" : "",
      "admin" : "${id}_$userName",
      "members" : "",
      "groupId" : "",
      "recentMessage" : "",
      "recentMessageSender" : ""
    });

    // update the members
    await groupDocumentReference.update({
      "members" : FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId" : groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = await userCollection.doc(uid);
    return await userDocumentReference.update({
      "group" : FieldValue.arrayUnion(["${groupDocumentReference.id}_${groupName}"])
    });
  }


  // getting the chats
  getChats(String groupId) async{
    return groupCollection.doc(groupId).collection("messages").orderBy("time").snapshots();
  }
  
  getGroupAdmin(String groupId) async{
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot["admin"];
  }
  

  /*
  Future getGroupAdmin(String groupId) async {
  if (groupId.isEmpty || groupId == null) {
    return null; // Boş veya null groupId'yi yönet (isteğe bağlı)
  }

  DocumentReference d = groupCollection.doc(groupId);
  DocumentSnapshot documentSnapshot = await d.get();
  return documentSnapshot["admin"];
}
*/

/*
Future getGroupAdmin(String groupId) async {
  DocumentReference? d = groupId?.isNotEmpty == true ? groupCollection.doc(groupId) : null;
  if (d == null) {
    return null; // Boş veya null groupId'yi yönet (isteğe bağlı)
  }

  DocumentSnapshot documentSnapshot = await d.get();
  return documentSnapshot["admin"];
}
*/

}