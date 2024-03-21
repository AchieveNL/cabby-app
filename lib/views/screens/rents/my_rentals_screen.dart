import 'package:cabby/config/theme.dart';
import 'package:cabby/views/screens/rents/rents_tab.dart';
import 'package:cabby/views/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class MyRentalsScreen extends StatefulWidget {
  const MyRentalsScreen({super.key});

  @override
  _MyRentalsScreenState createState() => _MyRentalsScreenState();
}

class _MyRentalsScreenState extends State<MyRentalsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: buildAppBarForPage(
          context: context,
          title: 'Mijn reserveringen',
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: AppColors.primaryLightColor,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              children: [
                TabBar(
                  isScrollable: true,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: AppColors.primaryColor,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.primaryColor,
                  labelPadding: const EdgeInsets.only(right: 0, left: 0),
                  tabs: [
                    _customTab("Alle"),
                    _customTab("Actief"),
                    _customTab("Voltooid"),
                    _customTab("In behandeling"),
                    _customTab("Geannuleerd"),
                    _customTab("Afgewezen"),
                  ],
                ),
                const Expanded(
                  child: TabBarView(
                    children: [
                      RentsContent(status: "All"),
                      RentsContent(status: "Confirmed"),
                      RentsContent(status: "Completed"),
                      RentsContent(status: "Pending"),
                      RentsContent(status: "Canceled"),
                      RentsContent(status: "Rejected"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _customTab(String title) {
    return Tab(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
