import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:info_cab_u/basic_widgets/heading_text_widget.dart';
import 'package:info_cab_u/basic_widgets/normal_text_widget.dart';
import 'package:info_cab_u/components/container_card_widget.dart';
import 'package:info_cab_u/constant.dart';

class UsersListingPage extends StatefulWidget {
  @override
  State<UsersListingPage> createState() => _UsersListingPageState();
}

class _UsersListingPageState extends State<UsersListingPage> {
  // users collection Firebase instance
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

    // function to delete users from firestore
    void deleteUser(docId){
        users.doc(docId).delete();
      }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // menu button
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        title: Center(
          child: Text(
            "Users",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // search bar
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search",
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: textSecColor, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
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
            ),
            SizedBox(
              height: 48,
            ),


            // using stream builder list users from firebase
            Expanded(
              child: StreamBuilder(
                // listing the users in alphabetic order
                stream: users.orderBy('name').snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  //for checking the connection
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                    // checking the snapshot has any error
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error ${snapshot.error}'),
                    );
                    // checking the snapshot is empty
                  } else if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                    return Center(
                      child: Text('No data available'),
                    );
                  } else {
                    return ListView.builder(
                      // to get length from firestore
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        //to get all data to userSnap from firestore in index order
                        final DocumentSnapshot userSnap =
                            snapshot.data.docs[index];
                        //setting userName from userSnap     
                        final userName = userSnap['name'];
                        // setting companyName from userSnap  
                        final companyName = userSnap['company'];
                        // to get the first letter of name
                        final avatarLetter = userName.isNotEmpty
                            ? userName[0]
                            : '?'; // Handle empty names
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: primaryColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 229, 228, 228),
                                  blurRadius: 10,
                                  spreadRadius: 15,
                                )
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  // the letter in circular Avatar
                                  child: Container(
                                    child: CircleAvatar(
                                      backgroundColor: textPrimColor,
                                      radius: 30,
                                      child: Text(
                                        avatarLetter, // Display the first letter of the name or a default
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //display user name
                                    HText(content: userName, textColor: textPrimColor),
                                    // display company name
                                    NText(content: companyName, textColor: textSecColor)
                                  ],
                                ),
                                //delete button
                                IconButton(
                              onPressed: () {
                                deleteUser(userSnap.id);
                              },
                              icon: Icon(Icons.delete),
                              iconSize: 25,
                              color: Colors.red,
                            ),
                            // Padding(padding: EdgeInsets.only(left: 1))
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
    );
  }
}
