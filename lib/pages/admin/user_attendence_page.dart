import 'package:flutter/material.dart';
import 'package:info_cab_u/constant.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAttendancePage extends StatelessWidget {
  const UserAttendancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        title: const Center(
          child: Text(
            "Today’s Attendance",
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
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: textSecColor),
                hintText: "Search",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: textSecColor, width: 2.0),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: textSecColor, width: 2.0),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
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

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot bookingSnap =
                      snapshot.data!.docs[index];
                      final bookingData =
                      bookingSnap.data() as Map<String, dynamic>;

                      // Fetch user details using the userId
                      return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(bookingData['userId'])
                            .get(),
                        builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                          if (userSnapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          if (userSnapshot.hasError) {
                            return const Text('Failed to load user');
                          }

                          if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                            return const Text('User not found');
                          }

                          // User document exists, retrieve the name
                          final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                          final userName = userData['name'] ?? 'Unknown';
                          final userCompany = userData['company'];

                          return ListTile(
                            title: Text(
                              userName,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              // DateFormat.yMMMd().format(
                              //   DateTime.parse(bookingData['date']),
                              // ),
                              userCompany
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
