import 'package:chat_app/pages/auth/group_info.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  const ChatPage({super.key, required this.groupId, required this.groupName, required this.userName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  String admin = "";
  Stream<QuerySnapshot>? chats; 

  @override
  void initState() {
    // TODO: implement initState
    getChatAndAdmin();
  }

  void getChatAndAdmin() {
    DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid).getChats(widget.groupId).then((value) {
      setState(() {
        chats = value;
      });
    });
    DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid).getGroupAdmin(admin).then((value) {
      setState(() {
        admin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.groupName, style: const TextStyle(color: Colors.white),),
        actions: [
          IconButton(onPressed: () {
            nextScreen(context, GroupInfo(groupId: widget.groupId, groupName: widget.groupName, adminName: admin,));
          }, icon: const Icon(Icons.info))
        ],
      ),
    );
  }
}