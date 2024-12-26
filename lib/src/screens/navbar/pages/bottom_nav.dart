import 'package:arab_socials/src/screens/business/businessscreen.dart';
import 'package:arab_socials/src/screens/events/eventscreen.dart';
import 'package:arab_socials/src/screens/homepage/homescreen.dart';
import 'package:arab_socials/src/screens/members/memberscreen.dart';
import 'package:arab_socials/src/screens/profile/profilescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final RxInt _currentIndex = 0.obs;

  final List<Widget> _screens = [
    const Homescreen(),
    const Eventscreen(),
    const Memberscreen(),
    const Businessscreen(),
    const Profilescreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: _screens[_currentIndex.value],
        bottomNavigationBar: Container(
          height: 72.h,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 35, 94, 77),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(36),
            ),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: _currentIndex.value,
            onTap: (index) => _currentIndex.value = index,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            selectedItemColor: const Color.fromARGB(255, 225, 173, 116),
            unselectedItemColor: const Color.fromARGB(255, 190, 218, 165),
            showUnselectedLabels: true,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                activeIcon: Icon(Icons.home_filled),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/events.png',
                  width: 22.w,
                  height: 23.h,
                ),
                activeIcon: Image.asset(
                  'assets/icons/activebusiness.png',
                  width: 22.w,
                  height: 23.h,
                ),
                label: 'Events',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.group_outlined),
                activeIcon: Icon(Icons.group),
                label: 'Members',
              ),
              BottomNavigationBarItem(
               icon: Image.asset(
                  'assets/icons/business.png',
                  width: 22.w,
                  height: 23.h,
                ),
                activeIcon: Image.asset(
                  'assets/icons/business.png',
                  width: 22.w,
                  height: 23.h,
                  color: const Color.fromARGB(255, 225, 173, 116),
                ),
                label: 'Businesses',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_2_rounded),
                activeIcon: Icon(Icons.person_2_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
