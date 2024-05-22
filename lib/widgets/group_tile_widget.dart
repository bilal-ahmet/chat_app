import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatefulWidget {
  String userName;
  String groupId;
  String groupName;
  
  GroupTile({super.key, required this.userName, required this.groupId, required this.groupName});

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(context, ChatPage(groupId: widget.groupId, groupName: widget.groupName, userName: widget.userName,));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(widget.groupName.substring(0,1).toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
          ),
          title: Text(widget.groupName, style: const TextStyle(fontWeight: FontWeight.bold),),
          subtitle: Text("Join the conversation as ${widget.userName}", style: const TextStyle(fontSize: 13),),
        ),
      ),
    );
  }
}