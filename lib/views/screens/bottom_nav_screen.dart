import 'package:cabby/config/theme.dart';
import 'package:cabby/views/screens/home/home_screen.dart';
import 'package:cabby/views/screens/messages_screen.dart';
import 'package:cabby/views/screens/rents/my_rentals_screen.dart';
import 'package:cabby/views/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavScreen extends StatefulWidget {
  final int initialIndex;

  const BottomNavScreen({super.key, this.initialIndex = 0});

  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  final List<Widget> _pages = [
    const HomeScreen(),
    const MessagesScreen(),
    const MyRentalsScreen(),
    const ProfileScreen(),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          selectedLabelStyle:
              const TextStyle(fontSize: 12.0), // Adjust as needed
          unselectedLabelStyle:
              const TextStyle(fontSize: 12.0), // Adjust as needed
          items: [
            _customBottomNavItem(
                iconPath: 'assets/svg/home.svg', label: 'Home'),
            _customBottomNavItem(
                iconPath: 'assets/svg/messages.svg', label: 'Berichten'),
            _customBottomNavItem(
                iconPath: 'assets/svg/rentals.svg', label: 'Reserveringen'),
            _customBottomNavItem(
                iconPath: 'assets/svg/profile.svg', label: 'Profiel'),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _customBottomNavItem(
      {required String iconPath, required String label}) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        color: Colors.grey,
      ),
      activeIcon: SvgPicture.asset(
        iconPath,
        color: AppColors.primaryColor,
      ),
      label: label,
    );
  }
}
