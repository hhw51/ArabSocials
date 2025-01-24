import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:arabsocials/src/controllers/navigation_controller.dart';
import 'package:arabsocials/src/view/business/businessscreen.dart';
import 'package:arabsocials/src/view/events/eventscreen.dart';
import 'package:arabsocials/src/view/homepage/homescreen.dart';
import 'package:arabsocials/src/view/members/memberscreen.dart';
import 'package:arabsocials/src/view/profile/profilescreen.dart';

class BottomNav extends StatefulWidget {
  final Widget? child;

  const BottomNav({Key? key, this.child}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final NavigationController navigationController = Get.put(NavigationController());
  final List<Widget> _screens = [
    Homescreen(),
    Eventscreen(),
    Memberscreen(),
    Businessscreen(),
    Profilescreen(),
    // Temporary container for screens like ProfileDetailsScreen
    Container(),
  ];
  DateTime? _lastPressedAt;

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => WillPopScope(
        onWillPop: () async {
          if (navigationController.currentIndex.value != 0&&navigationController.showChildScreen.value== false) {
            navigationController.updateIndex(0);
            return false;

          }
          else if( navigationController.showChildScreen.value== true&&navigationController.currentIndex.value == 0){
            navigationController.updateIndex(0);
            return false;
          }    else if( navigationController.showChildScreen.value== false&&navigationController.currentIndex.value == 0){
            final now = DateTime.now();
            if (_lastPressedAt == null || now.difference(_lastPressedAt!) > Duration(seconds: 2)) {
              _lastPressedAt = now;
              Get.snackbar(
                'Exit App',
                'Press back again to exit',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              );
              return false;
            }
            return true;
          }else{
            navigationController.showChildScreen.value=false;
            navigationController.update();
          }
          return false;
        },
        child: Scaffold(
          body: Obx(() {
            if (navigationController.showChildScreen.value) {
              return navigationController.childScreen!;
            } else {
              return _screens[navigationController.currentIndex.value];
            }
          }),
          bottomNavigationBar: Container(
            height: 72.h,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 35, 94, 77),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(36),
              ),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                currentIndex: navigationController.currentIndex.value,
                onTap: (index) => navigationController.updateIndex(index),
                enableFeedback: false,
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
                    icon: Icon(Icons.event_note_outlined),
                    activeIcon: Icon(Icons.event_note),
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
        ),
      ),
    );
  }
}