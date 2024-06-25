import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:info_cab_u/basic_widgets/heading_text_widget.dart';
import 'package:info_cab_u/constant.dart';

class DriverListPage extends StatefulWidget {
  const DriverListPage({super.key});

  @override
  State<DriverListPage> createState() => _DriverListPageState();
}

class _DriverListPageState extends State<DriverListPage> {
  @override
  Widget build(BuildContext context) {
    final CollectionReference drivers =
        FirebaseFirestore.instance.collection('drivers');

    void deleteUser(docId) {
      drivers.doc(docId).delete();
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Drivers',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(8, 24, 8, 8),
          child: StreamBuilder<QuerySnapshot>(
            stream: drivers.orderBy('name').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No data available'));
              } else {
                // return ListView.builder(
                //   itemCount: snapshot.data!.docs.length,
                //   itemBuilder: (context, index) {
                //     final DocumentSnapshot driverSnap = snapshot.data!.docs[index];
                //     // return ListTile(
                //     //   title: Text(driverSnap['name']),
                //     //   subtitle: Text(driverSnap['number']),
                //     // );
                //     return SizedBox(
                //       height: 50,
                //       child: Padding(
                //         padding: const EdgeInsets.all(.0),
                //         child: Container(
                //           child: Row(
                //             children: [
                //               CircleAvatar(backgroundColor:Color(0xFFD9DDFA),
                //                 child: Icon(Icons.person),
                //               ),
                //               Column(
                //                 children: [
                //                   Text(driverSnap['name'],style: TextStyle(
                //                     fontSize: 20,
                //                     fontWeight: FontWeight.w600
                //                   ),),
                //                   Text(driverSnap['number'])
                //                 ],
                //               )
                //             ],
                //           ),
                //         ),
                //       ),
                //     );
                //   },
                // );

                return ListView.builder(
                  // to get length from firestore
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    //to get all data to driverSnap from firestore in index order
                    final DocumentSnapshot driverSnap =
                        snapshot.data!.docs[index];
                    //setting driverName from driverSnap
                    final driverName = driverSnap['name'];
                    // setting driverNumber from driverSnap
                    final driverNumber = driverSnap['number'];
                    // to get the first letter of

                    final avatarLetter = driverName.isNotEmpty
                        ? driverName[0]
                        : '?'; // Handle empty names
                    return Padding(
                      padding: EdgeInsets.all(8),
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              // Shadow color
                              spreadRadius: 2,
                              // Spread radius
                              blurRadius: 5,
                              // Blur radius
                              offset:
                                  Offset(0, 2), // Offset in x and y direction
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: EdgeInsets.all(8),
                                  // the letter in circular Avatar
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
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
                                      backgroundColor: textPrimColor,
                                      radius: 25,
                                      child: Center(
                                        child: Text(
                                          avatarLetter,
                                          // Display the first letter of the name or a default
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //display user name
                                  // HText(content: driverName, textColor: textPrimColor),
                                  Text(
                                    driverName,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: textSecColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  // // display company name
                                  // NText(content: driverNumber, textColor: textSecColor)
                                  Text(
                                    driverNumber,
                                    style: TextStyle(
                                        fontSize: 18, color: textSecColor),
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
                                color: Colors.red,
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/add_driver');
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          tooltip: 'Add Driver',
          backgroundColor: textPrimColor,
        ),
      ),
    );
  }
}
