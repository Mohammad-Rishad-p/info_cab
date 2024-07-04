import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:info_cab_u/constant.dart';

import '../../functions/function_onWillPop.dart';

class VehicleListPage extends StatefulWidget {
  const VehicleListPage({Key? key}) : super(key: key);

  @override
  _VehicleListPageState createState() => _VehicleListPageState();
}

class _VehicleListPageState extends State<VehicleListPage> {
  final CollectionReference vehicles =
      FirebaseFirestore.instance.collection('vehicles');

  TextEditingController searchController = TextEditingController();
  String searchVehicle = '';

  void deleteVehicle(String docId) {
    vehicles.doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Vehicles',
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
                  decoration: const InputDecoration(
                    labelText: 'Search Vehicle',
                    labelStyle: TextStyle(color: textSecColor),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: textSecColor, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: textSecColor, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: OutlineInputBorder(
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
                    prefixIcon: Icon(Icons.search,color: textSecColor,),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchVehicle = value.toLowerCase();
                    });
                  },
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: vehicles.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No vehicles available'));
                      } else {
                  
                        var filteredDocs = snapshot.data!.docs.where((doc) {
                          return doc['vehicle']
                              .toString()
                              .toLowerCase()
                              .contains(searchVehicle);
                        }).toList();
                        
                        return ListView.builder(
                          itemCount: filteredDocs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot vehicleSnap =
                                filteredDocs[index];
                            final vehicleName = vehicleSnap['vehicle'] ?? 'Unknown';
                  
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                              child: Container(
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: textPrimColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        vehicleName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          deleteVehicle(vehicleSnap.id);
                                        },
                                        icon: const Icon(Icons.delete),
                                        iconSize: 25,
                                        color: Colors.red,
                                      ),
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
              Navigator.pushNamed(context, '/add_vehicle');
            },
            child: const Icon(
              Icons.add,
              color: textPrimColor,
            ),
            tooltip: 'Add Vehicle',
          ),
        ),
      ),
    );
  }
}
