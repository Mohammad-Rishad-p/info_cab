import 'package:flutter/material.dart';
import 'package:info_cab_u/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAttendancePage extends StatefulWidget {
  const UserAttendancePage({Key? key}) : super(key: key);

  @override
  _UserAttendancePageState createState() => _UserAttendancePageState();
}

class _UserAttendancePageState extends State<UserAttendancePage> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  Map<String, bool?> attendanceStatus = {}; // Declare attendanceStatus map


  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _submitAttendance() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Attendance Submission"),
        content: Text("Are you sure you want to submit the attendance?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // Update attendance statuses in Firestore
              attendanceStatus.forEach((bookingId, attended) {
                FirebaseFirestore.instance
                    .collection('bookings')
                    .doc(bookingId)
                    .update({'attended': attended});
              });

              // Show a snackbar to indicate success
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Attendance updated successfully!'),
                ),
              );

              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text("Submit"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Today’s List",
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _submitAttendance,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search, color: textSecColor),
                hintText: "Search User",
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
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('bookings')
                    .where('tripId', isEqualTo: args['tripId'])
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text('An error occurred'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No bookings available'));
                  }

                  //for search user
                  var filteredDocs = snapshot.data!.docs.where((doc) {
                    var bookingData = doc.data() as Map<String, dynamic>;
                    return bookingData['userName']
                        .toString()
                        .toLowerCase()
                        .contains(searchQuery);
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot bookingSnap = filteredDocs[index];
                      final bookingData =
                      bookingSnap.data() as Map<String, dynamic>;

                      return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(bookingData['userId'])   //users collection where booking le userid vech
                            .get(),
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          if (userSnapshot.hasError) {
                            return const Text('Failed to load user');
                          }

                          if (!userSnapshot.hasData ||
                              !userSnapshot.data!.exists) {
                            return const Text('User not found');
                          }

                          final userData =
                          userSnapshot.data!.data() as Map<String, dynamic>;
                          final userName = userData['name'] ?? 'Unknown';
                          final userCompany = userData['company'];
                          final isAttended = bookingData['attended'] ?? null;

                          Color containerColor;
                          String containerText;

                          if (isAttended == null) {
                            containerColor = textPrimColor;
                            containerText = 'Mark Here';
                          } else if (isAttended) {
                            containerColor = Colors.green;
                            containerText = 'Arrived';
                          } else {
                            containerColor = Colors.red;
                            containerText = 'Not Reached';
                          }

                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 1),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Text(
                                  userName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(userCompany),
                                trailing: GestureDetector(
                                  onTap: () {
                                    bool newAttendanceStatus;
                                    if (isAttended == null) {
                                      newAttendanceStatus = true;
                                    } else {
                                      newAttendanceStatus = !isAttended;
                                    }
                                    FirebaseFirestore.instance
                                        .collection('bookings')
                                        .doc(bookingSnap.id)
                                        .update(
                                        {'attended': newAttendanceStatus});
                                  },
                                  child: SizedBox(
                                    width: 90,
                                    height: 40,
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: containerColor,
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: Center(
                                        child: Text(
                                          containerText,
                                          style: const TextStyle(
                                              color: Colors.white
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
