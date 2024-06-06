import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {
  final String? uid;

  DataBaseService({required this.uid});

  // reference for our collection

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("group");

  // saving the user data

  Future savingUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "group": [],
      "profilePicture": "",
      "uid": uid
    });
  }

  // geting user data

  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // get user groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  // creating a group
  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": "",
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": ""
    });

    // update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = await userCollection.doc(uid);
    return await userDocumentReference.update({
      "group":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_${groupName}"])
    });
  }

  // getting the chats
  Future getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
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

// get group member
  Future getGroupMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

// search
  Future searchByName(String groupName) async {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

// function => bool
  Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> group = await documentSnapshot["group"];
    if (group.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

// toggling the group join/exit
  Future toggleGroupJoin(
      String groupId, String groupName, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> group = await documentSnapshot["group"];
    // if user has our groups => then remove then or also in other part re join

    if (group.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "group": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDocumentReference.update({
        "group": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }

  // send message

  Future sendMessage(String groupId, Map<String, dynamic> chatMessageData) async{
    groupCollection.doc(groupId).collection("message").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage" : chatMessageData["message"],
      "recentMessageSender" : chatMessageData["sender"],
      "recentMessageTime" : chatMessageData["time"].toString(), 
    });
  }
}
