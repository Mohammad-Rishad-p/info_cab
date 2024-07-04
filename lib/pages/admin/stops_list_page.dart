import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:info_cab_u/constant.dart';

class StopsListPage extends StatefulWidget {
  const StopsListPage({Key? key}) : super(key: key);

  @override
  State<StopsListPage> createState() => _StopsListPageState();
}

class _StopsListPageState extends State<StopsListPage> {
  final CollectionReference stops =
      FirebaseFirestore.instance.collection('stops');
  TextEditingController searchController = TextEditingController();
  String searchStop = '';

  void deleteStop(String docId) {
    stops.doc(docId).delete();
  }

  Future<void> showDeleteConfirmationDialog(
      BuildContext context, String docId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Stop'),
          content: Text('Are you sure you want to delete this stop?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // dismiss the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteStop(docId);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pickup Points'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addStop');
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search",
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
                  searchStop = value.toLowerCase();
                });
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: stops.orderBy('stop').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No stops available'));
                  } else {
                    var filteredDocs = snapshot.data!.docs.where((doc) {
                      return doc['stop']
                          .toString()
                          .toLowerCase()
                          .contains(searchStop);
                    }).toList();

                    return ListView.builder(
                      itemCount: filteredDocs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot stopSnap = filteredDocs[index];
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                          child: Container(
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
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  stopSnap['stop'],
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.white),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    showDeleteConfirmationDialog(
                                        context, stopSnap.id);
                                  },
                                  icon:
                                      Icon(Icons.delete, color: Colors.redAccent),
                                ),
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
    );
  }
}
