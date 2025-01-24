import 'package:arabsocials/src/controllers/navigation_controller.dart';
import 'package:arabsocials/src/controllers/notification_controller.dart'; // Add this line
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Notificationscreen extends StatefulWidget {
  const Notificationscreen({super.key});

  @override
  State<Notificationscreen> createState() => _NotificationscreenState();
}

class _NotificationscreenState extends State<Notificationscreen> {
  final NotificationController notificationController = Get.put(NotificationController()); // Add this line

  @override
  void initState() {
    super.initState();
    notificationController.fetchNotifications(); // Fetch notifications on screen load
  }

  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController = Get.put(NavigationController());
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 250, 244, 228),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          navigationController.navigateBack();
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: const Color.fromARGB(255, 35, 94, 77),
                          size: 34,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                "NOTIFICATIONS",
                style: GoogleFonts.playfairDisplaySc(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 12.h),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Text(
                      "Today",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Clear",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (notificationController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (notificationController.notifications.isEmpty) {
                    return Center(child: Text('No notifications available'));
                  }

                  return ListView.builder(
                    itemCount: notificationController.notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notificationController.notifications[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24.r,
                              backgroundColor: const Color.fromARGB(255, 200, 230, 201),
                              backgroundImage: notification.senderImage != null
                                  ? NetworkImage(notification.senderImage!)
                                  : AssetImage("assets/logo/image1.png") as ImageProvider,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  navigationController.updateIndex(4);
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notification.title ?? "",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    if (notification.eventTitle != null) ...[
                                      SizedBox(height: 4.h),
                                      Text(
                                        notification.eventTitle!,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    ],
                                    SizedBox(height: 4.h),
                                    Text(
                                      notification.timestamp ?? "",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}