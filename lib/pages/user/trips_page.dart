import 'package:flutter/material.dart';
import 'package:info_cab_u/constant.dart';
import 'package:info_cab_u/pages/user/canceled_page.dart';
import 'package:info_cab_u/pages/user/completed_page.dart';
import 'package:info_cab_u/pages/user/upcoming_page.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({Key? key}) : super(key: key);

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Trips',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Completed'),
            Tab(text: 'Upcoming'),
            Tab(text: 'Canceled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CompletedTrips(),
          UpcomingTrips(),
          CanceledTrips(),
        ],
      ),
    );
  }
}

class CompletedTrips extends StatelessWidget {
  const CompletedTrips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return TripCard(
          name: 'Aswin',
          company: 'Techgentsia',
          date: 'Sunday, 12 June',
          location: 'Alappuzha - Infopark',
          price: 'Rs. 125',
        );
      },
    );
  }
}

class UpcomingTrips extends StatelessWidget {
  const UpcomingTrips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Upcoming Trips'),
    );
  }
}

class CanceledTrips extends StatelessWidget {
  const CanceledTrips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
