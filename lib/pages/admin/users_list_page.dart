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
  // users collection Firebase instance
  final CollectionReference users = FirebaseFirestore.instance.collection('users');
  TextEditingController searchController = TextEditingController();
  String searchUser = '';

  // function to delete users from Firestore
  void deleteUser(String docId) {
    users.doc(docId).delete();
  }

  // function to show delete confirmation dialog
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
                Navigator.of(context).pop(); // dismiss the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteUser(docId);
                Navigator.of(context).pop(); // dismiss the dialog
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

              // using stream builder list users from firebase
              Expanded(
                child: StreamBuilder(
                  // listing the users in alphabetic order
                  stream: users.orderBy('name').snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    // for checking the connection
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    // checking the snapshot has any error
                    else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    // checking the snapshot is empty
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
                        // to get length from firestore
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, index) {
                          // to get all data to userSnap from firestore in index order
                          final DocumentSnapshot userSnap =
                          filteredDocs[index];
                          // setting userName from userSnap
                          final userName = userSnap['name'];
                          // setting companyName from userSnap
                          final companyName = userSnap['company'];
                          // to get the first letter of name
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
