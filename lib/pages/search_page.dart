import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController searchController = TextEditingController();
  
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Search", style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white),),
      ),

      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(child: TextField(
                  controller: searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search groups...",
                    hintStyle: TextStyle(color: Colors.white, fontSize: 16)
                  ),
                )),

                GestureDetector(
                  onTap: () {
                    initiateSearchMethod();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40)
                    ),
                    child: const Icon(Icons.search, color: Colors.white,),
                  ),
                )
              ],
            ),
          ),
          isLoading ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),) : groupList()
        ],
      ),
    );
  }

  initiateSearchMethod(){
    if(searchController.text.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      
    }
  }

  groupList(){

  }
}