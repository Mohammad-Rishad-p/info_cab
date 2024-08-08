import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:info_cab_u/basic_widgets/heading_text_widget.dart';
import 'package:info_cab_u/basic_widgets/normal_text_widget.dart';
import 'package:info_cab_u/components/container_card_widget.dart';
import 'package:info_cab_u/constant.dart';

import '../../functions/function_onWillPop.dart';

class UsersListPage extends StatefulWidget {
  const UsersListPage({super.key});

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  final CollectionReference users = FirebaseFirestore.instance.collection('users');
  TextEditingController searchController = TextEditingController();
  String searchUser = '';

  void deleteUser(String docId) {
    users.doc(docId).delete();
  }

  void showDeleteConfirmationDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Are you sure you want to delete this user?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteUser(docId);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Employees"),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // search bar
              SizedBox(
                height: 50,
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    // suffixIcon: IconButton(
                    //   onPressed: (){
                    //     setState(() {
                    //       searchController.clear();
                    //       searchUser = '';
                    //     });
                    //
                    //   }, icon: Icon(CupertinoIcons.xmark,
                    // color: textSecColor,),
                    // ),
                    prefixIcon: Icon(Icons.search, color: textSecColor,),
                    hintText: "Search User",
                    hintStyle: TextStyle(

                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: textSecColor, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: textSecColor, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchUser = value.toLowerCase();
                    });
                  },
                ),
              ),
              SizedBox(height: 20),

              Expanded(
                child: StreamBuilder(
                  stream: users.orderBy('name').snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    else if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                      return Center(child: Text('No data available'));
                    } else {
                      var filteredDocs = snapshot.data!.docs.where((doc) {
                        return doc['name']
                            .toString()
                            .toLowerCase()
                            .contains(searchUser);
                      }).toList();
                      return ListView.builder(
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot userSnap =
                          filteredDocs[index];
                          final userName = userSnap['name'];
                          final companyName = userSnap['company'];
                          final avatarLetter = userName.isNotEmpty
                              ? userName[0]
                              : '?'; // Handle empty names
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                color: textPrimColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 1),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(16, 00, 0, 0),
                                    // the letter in circular Avatar
                                    child: CircleAvatar(
                                      radius: 25,
                                      child: Center(
                                        child: Text(
                                          avatarLetter,
                                          // Display the first letter of the name or a default
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: textPrimColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // display user name
                                      Text(
                                        userName,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                      // display company name
                                      Text(
                                        companyName,
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                  // delete button
                                  IconButton(
                                    onPressed: () {
                                      showDeleteConfirmationDialog(
                                          context, userSnap.id);
                                    },
                                    icon: Icon(Icons.delete),
                                    iconSize: 25,
                                    tooltip: 'Delete Employee',
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
