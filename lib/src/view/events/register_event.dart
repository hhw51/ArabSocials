// register_event.dart
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
  bool isProcessing = false; // Flag to indicate if processing is ongoing

  @override
  void initState() {
    super.initState();
    _loadRegistrationStatus();
  }

  /// Loads the registration status for the given event.
  Future<void> _loadRegistrationStatus() async {
    final eventController = Get.find<RegisterEventController>();
    if (widget.eventId != null) {
      setState(() {
        isRegistered = eventController.registeredEventIds.contains(widget.eventId);
      });
      print('Initial registration status for Event ID ${widget.eventId}: $isRegistered');
    }
  }

  /// Handles the registration/unregistration logic.
  Future<void> _handleRegistration() async {
    if (isProcessing || widget.eventId == null) return;

    setState(() {
      isProcessing = true;
      isRegistered = !isRegistered; // Optimistically update the UI
    });

    final eventController = Get.find<RegisterEventController>();
    final eventId = widget.eventId!;
    final status = isRegistered ? 'registered' : 'cancelled';

    try {
      final response = await RegisterEvents().registerForEvent(eventId, status);
      print('Register Event Response: $response');

      // Determine the type of response
      if (response.containsKey('id') && response.containsKey('status')) {
        // Registration response
        await eventController.updateRegistrationStatus(eventId, isRegistered);

        // Show a success snackbar
        Get.snackbar(
          'Success',
          isRegistered
              ? 'You have successfully registered for the event!'
              : 'You have successfully unregistered from the event!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (response.containsKey('message')) {
        // Unregistration response
        await eventController.updateRegistrationStatus(eventId, isRegistered);

        // Show a success snackbar
        Get.snackbar(
          'Success',
          response['message'],
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        throw Exception('Invalid response from server.');
      }
    } catch (e) {
      print('Error during registration: $e');
      // Revert the optimistic UI update
      setState(() {
        isRegistered = !isRegistered;
      });

      // Show an error snackbar
      Get.snackbar(
        'Error',
        'Failed to update registration status: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventController = Get.find<RegisterEventController>();
    final event = widget.eventId != null
        ? eventController.getEventById(widget.eventId!)
        : null; // Nullable event
    final creator = widget.eventId != null
        ? eventController.getEventCreatorByEventId(widget.eventId!)
        : null; // Fetch creator details
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
                ? SingleChildScrollView(
              child: Column(
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
                  SizedBox(height: 12.h), // Add some spacing before creator details
                  // **Dynamic Event Creator Details**
                  if (creator != null)
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18.r,
                          backgroundImage: creator['image'] != null && creator['image'] != ''
                              ? NetworkImage('$baseUrl${creator['image']}')
                              : AssetImage("assets/logo/member_group.png") as ImageProvider, // Fallback image
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              creator['name'] ?? "No Name",
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
                          onPressed: () {
                            // Implement follow functionality if needed
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 35, 94, 77),
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
                    )
                  else
                  // If creator details are not available, show a placeholder or nothing
                    Container(),
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
                    onPressed: isProcessing ? null : _handleRegistration,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 35, 94, 77),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      minimumSize: Size(double.infinity, 56.h),
                    ),
                    child: isProcessing
                        ? SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.0,
                      ),
                    )
                        : Text(
                      isRegistered ? "UNREGISTER" : "REGISTER",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
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
