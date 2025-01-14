import 'package:arab_socials/src/controllers/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../apis/register_event.dart';
import '../../controllers/registerEventController.dart';

class RegisterEvent extends StatefulWidget {
  final int? eventId; // Make event optional

  const RegisterEvent({this.eventId, super.key});

  @override
  State<RegisterEvent> createState() => _RegisterEventState();
}

class _RegisterEventState extends State<RegisterEvent> {
  bool isRegistered = false;
  @override
  Widget build(BuildContext context) {
    final eventController = Get.find<RegisterEventController>();
    final event = widget.eventId != null ? eventController.getEventById(widget.eventId!) : null;// Nullable event
    const String baseUrl = 'http://35.222.126.155:8000';

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 244, 228),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 300.h,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Header Image
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24.r),
                    bottomRight: Radius.circular(24.r),
                  ),
                  child: event != null && event['flyer'] != null && event['flyer'] != ''
                      ? Image.network(
                    '$baseUrl${event['flyer']}',
                    fit: BoxFit.cover,
                    height: 261.h,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      "assets/logo/homegrid.png",
                      fit: BoxFit.cover,
                      height: 261.h,
                      width: double.infinity,
                    ),
                  )
                      : Image.asset(
                    "assets/logo/homegrid.png",
                    fit: BoxFit.cover,
                    height: 261.h,
                    width: double.infinity,
                  ),
                ),
                // Back Button and Header Title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 35.h),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          final NavigationController navigationController = Get.find();
                          navigationController.navigateBack();
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Explore Events",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // White Container with Event Details
                Positioned(
                  bottom: 1.h,
                  left: 16.w,
                  right: 16.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Overlapping Circular Avatars
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              radius: 18.r,
                              backgroundImage: AssetImage("assets/logo/image1.png"),
                            ),
                            Positioned(
                              left: 24.w,
                              child: CircleAvatar(
                                radius: 18.r,
                                backgroundImage: AssetImage("assets/logo/image2.png"),
                              ),
                            ),
                            Positioned(
                              left: 48.w,
                              child: CircleAvatar(
                                radius: 18.r,
                                backgroundImage: AssetImage("assets/logo/image3.png"),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 60.w),
                        Text(
                          "+20 Going",
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: const Color.fromARGB(255, 35, 94, 77),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 35, 94, 77),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                          ),
                          child: Text(
                            "INVITE",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color.fromARGB(255, 250, 244, 228),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Event Details
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: event != null
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['title'] ?? "No Title",
                  style: GoogleFonts.playfairDisplaySc(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 12.h),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.calendar_today_outlined,
                    size: 16.sp,
                    color: Colors.grey,
                  ),
                  title: Text(
                    event['event_date']?.split("T")[0] ?? "No Date",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    "Time: ${event['event_date']?.split("T")[1]?.split("Z")[0] ?? "N/A"}",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.location_on_outlined,
                    size: 16.sp,
                    color: Colors.grey,
                  ),
                  title: Text(
                    event['location'] ?? "No Location",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    "Event Type: ${event['event_type'] ?? "N/A"}",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18.r,
                      backgroundImage: AssetImage("assets/logo/image1.png"),
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ashfak Sayem",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Organizer",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color.fromARGB(255, 35, 94, 77),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        "Follow",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25.h),
                Text(
                  "ABOUT",
                  style: GoogleFonts.playfairDisplaySc(
                    fontSize: 14.sp,
                    color: const Color.fromARGB(255, 35, 94, 77),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  event['description'] ?? "No Description",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromARGB(255, 143, 146, 137),
                  ),
                ),
                SizedBox(height: 15.h),
                ElevatedButton(
                  onPressed: () async {
                    final status = isRegistered ? 'cancelled' : 'registered';

                    try {
                      // Call the register API with the appropriate status
                      await RegisterEvents().registerForEvent(event['id'], status);

                      // Update the registration status and button text
                      setState(() {
                        isRegistered = !isRegistered;
                      });

                      // Show a Snackbar with a dynamic message
                      Get.snackbar(
                        'Success',
                        isRegistered
                            ? 'You have successfully registered for the event!'
                            : 'You have successfully unregistered from the event!',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    } catch (e) {
                      // Handle API errors (e.g., show a snackbar or toast)
                      print('Error updating registration: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to update registration status')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 35, 94, 77),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    minimumSize: Size(double.infinity, 56.h),
                  ),
                  child: Text(
                    isRegistered ? "UNREGISTER" : "REGISTER",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
                : Center(
              child: Text(
                "No event details available",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
