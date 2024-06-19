import 'package:flutter/material.dart';
import 'package:info_cab_u/constant.dart';
import 'package:info_cab_u/pages/user/canceled_page.dart';
import 'package:info_cab_u/pages/user/completed_page.dart';
import 'package:info_cab_u/pages/user/upcoming_page.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Trips',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            bottom: const TabBar(unselectedLabelColor: textSecColor, tabs: [
              Tab(
                text: 'Completed',
              ),
              Tab(
                text: 'Upcoming',
              ),
              Tab(
                text: 'Canceled',
              )
            ]),
          ),
          body: TabBarView(
            children: [
              CompletedPage(),
              UpcomingPage(),
              CanceledPage()
            ],
          ),
        ),
    );
  }
}
