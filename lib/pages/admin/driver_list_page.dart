import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:info_cab_u/basic_widgets/heading_text_widget.dart';
import 'package:info_cab_u/constant.dart';

import '../../functions/function_onWillPop.dart';

class DriverListPage extends StatefulWidget {
  const DriverListPage({super.key});

  @override
  State<DriverListPage> createState() => _DriverListPageState();
}

class _DriverListPageState extends State<DriverListPage> {
  final CollectionReference drivers =
      FirebaseFirestore.instance.collection('drivers');

  TextEditingController searchController = TextEditingController();
  String searchDriver = '';

  void deleteUser(docId) {
    drivers.doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Drivers',
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
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
                    prefixIcon: Icon(Icons.search),
                    labelText: "Search Driver",
                    labelStyle: TextStyle(color: textSecColor),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: textSecColor, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: textSecColor, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.redAccent, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.redAccent, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchDriver = value.toLowerCase();
                    });
                  },
                ),
                SizedBox(height: 20),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: drivers.orderBy('name').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No data available'));
                      } else {
                        var filteredDocs = snapshot.data!.docs.where((doc) {
                          return doc['name']
                              .toString()
                              .toLowerCase()
                              .contains(searchDriver);
                        }).toList();

                        return ListView.builder(
                          // to get length from firestore
                          itemCount: filteredDocs.length,
                          itemBuilder: (context, index) {
                            //to get all data to driverSnap from firestore in index order
                            final DocumentSnapshot driverSnap =
                                filteredDocs[index];
                            //setting driverName from driverSnap
                            final driverName = driverSnap['name'];
                            // setting driverNumber from driverSnap
                            final driverNumber = driverSnap['number'];
                            // to get the first letter of

                            final avatarLetter = driverName.isNotEmpty
                                ? driverName[0]
                                : '?'; // Handle empty names
                            return Padding(
                              padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
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
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(16, 00, 0, 0),
                                          // the letter in circular Avatar
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  // Shadow color
                                                  spreadRadius: 1,
                                                  // Spread radius
                                                  blurRadius: 2,
                                                  // Blur radius
                                                  offset: Offset(0,
                                                      3), // Offset in x and y direction
                                                ),
                                              ],
                                            ),
                                            child: CircleAvatar(
                                              radius: 25,
                                              child: Center(
                                                child: Text(
                                                  avatarLetter,
                                                  // Display the first letter of the name or a default
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: textPrimColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          //display user name
                                          // HText(content: driverName, textColor: textPrimColor),
                                          Text(
                                            driverName,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                          // // display company name
                                          // NText(content: driverNumber, textColor: textSecColor)
                                          Text(
                                            driverNumber,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      //delete button
                                      IconButton(
                                        onPressed: () {
                                          deleteUser(driverSnap.id);
                                        },
                                        icon: Icon(Icons.delete),
                                        iconSize: 25,
                                        color: Colors.redAccent,
                                      ),
                                      // Padding(padding: EdgeInsets.only(left: 1))
                                    ],
                                  ),
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
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add_driver');
            },
            child: Icon(
              Icons.add,
              color: textPrimColor,
            ),
            tooltip: 'Add Driver',
          ),
        ),
      ),
    );
  }
}
