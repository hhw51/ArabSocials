import 'package:arab_socials/src/view/events/promote_event.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:arab_socials/src/controllers/navigation_controller.dart';
import 'package:arab_socials/src/view/events/register_event.dart';
import 'package:arab_socials/src/widgets/custombuttons.dart';
import 'package:arab_socials/src/widgets/textfomr_feild.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../apis/approved_events.dart';
import '../../widgets/popup_event.dart';

class Eventscreen extends StatefulWidget {
  Eventscreen({super.key});

  @override
  State<Eventscreen> createState() => _EventscreenState();
}

class _EventscreenState extends State<Eventscreen> {
  final NavigationController navigationController = Get.put(NavigationController());
  final ApprovedEvents approvedEventsService = ApprovedEvents();

  bool isLoading = true;
  List<dynamic> events = [];
  final String baseUrl = 'http://35.222.126.155:8000';

  @override
  void initState() {
    super.initState();
    fetchApprovedEvents();
  }

  Widget _buildGoingSection() {
    return Row(
      children: [
        Container(
          height: 24.h,
          width: 56.w,
          child: Stack(
            children: [
              CircleAvatar(
                radius: 10.r,
                backgroundImage: AssetImage('assets/logo/image1.png'),
              ),
              Positioned(
                left: 15.w,
                child: CircleAvatar(
                  radius: 10.r,
                  backgroundImage: AssetImage('assets/logo/image2.png'),
                ),
              ),
              Positioned(
                left: 30.w,
                child: CircleAvatar(
                  radius: 10.r,
                  backgroundImage: AssetImage('assets/logo/image3.png'),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          "+25 Going",
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color.fromARGB(255, 35, 94, 77),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  String _monthAbbreviation(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  Future<void> fetchApprovedEvents() async {
    try {
      final fetchedEvents = await approvedEventsService.getApprovedEvents();
      setState(() {
        events = fetchedEvents.map((event) {
          final eventDate = DateTime.parse(event['event_date']);
          final day = eventDate.day;
          final month = _monthAbbreviation(eventDate.month);
          return {
            ...event as Map<String, dynamic>,
            'day': day,
            'month': month,
            'bookmarked': false, // Add a bookmarked property
          };
        }).toList();
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching events: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 250, 244, 228),
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              navigationController.navigateBack();
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: const Color.fromARGB(255, 35, 94, 77),
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Expanded(child: SizedBox()),
                          const CustomContainer(
                            text: "Saved",
                            icon: Icons.bookmark_border,
                          ),
                          const CustomContainer(
                            text: "Location",
                            icon: Icons.location_on_outlined,
                          ),
                          const CustomContainer(
                            text: "Date",
                            image: "assets/icons/calculator.png",
                          ),
                          const CustomContainer(
                            text: "Type",
                            icon: Icons.filter_alt_outlined,
                          ),
                        ],
                      ),
                    ),
                    // Custom Buttons Row
                    const SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            Custombutton(
                              text: "Sports",
                              icon: Icons.sports_basketball,
                              color: Color.fromARGB(255, 240, 99, 90),
                            ),
                            Custombutton(
                              text: "Music",
                              image: "assets/icons/musicicon.png",
                              color: Color.fromARGB(255, 245, 151, 98),
                            ),
                            Custombutton(
                              text: "Food",
                              image: "assets/icons/foodicon.png",
                              color: Color.fromARGB(255, 41, 214, 151),
                            ),
                            Custombutton(
                              text: "Drawing",
                              image: "assets/icons/painticon.png",
                              color: Color.fromARGB(255, 70, 205, 251),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Section Title
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22),
                      child: Text(
                        "EXPLORE EVENTS",
                        style: GoogleFonts.playfairDisplaySc(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Search Field
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: const CustomTextFormField(
                        hintText: "Search events",
                      ),
                    ),
                    // Events List
                    if (!isLoading)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Container(
                          height: 535.h,
                          child: ListView.builder(
                            itemCount: events.length,
                            itemBuilder: (context, index) {
                              final event = events[index];
                              return InkWell(
                                onTap: () {
                                  navigationController.navigateToChild(
                                    RegisterEvent(eventId: event['id']),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Container(
                                    height: 233.h,
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
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(12),
                                                child: Image.network(
                                                  event['flyer'] != null && event['flyer'] != ''
                                                      ? '$baseUrl${event['flyer']}'
                                                      : 'assets/logo/homegrid.png',
                                                  fit: BoxFit.cover,
                                                  height: 131.h,
                                                  width: double.infinity,
                                                  errorBuilder: (context, error, stackTrace) =>
                                                      Image.asset(
                                                        'assets/logo/homegrid.png',
                                                        fit: BoxFit.cover,
                                                        height: 131.h,
                                                        width: double.infinity,
                                                      ),
                                                ),
                                              ),
                                              // Date Container
                                              Positioned(
                                                top: 8.h,
                                                left: 8.w,
                                                child: Container(
                                                  height: 36.h,
                                                  width: 36.w,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(6.r),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        event['day']?.toString() ?? '',
                                                        style: GoogleFonts.playfairDisplaySc(
                                                          fontSize: 14.sp,
                                                          color: Colors.green,
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      Text(
                                                        event['month']?.toString() ?? '',
                                                        style: GoogleFonts.playfairDisplaySc(
                                                          fontSize: 8.sp,
                                                          color: Colors.green,
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              // Bookmark Button
                                              Positioned(
                                                top: 10.h,
                                                right: 12.w,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      event['bookmarked'] =
                                                      !event['bookmarked']; // Toggle bookmarked state
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 36.h,
                                                    width: 36.w,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(6.r),
                                                    ),
                                                    child: Icon(
                                                      event['bookmarked']
                                                          ? Icons.bookmark
                                                          : Icons.bookmark_outline,
                                                      color: Colors.green,
                                                      size: 18.sp,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Event Details
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 6),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    event['title']?.toString() ?? '',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.playfairDisplaySc(
                                                      fontSize: 12.sp,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTapDown: (details) {
                                                    // Implement popup menu
                                                    showCustomPopupMenu(
                                                        context, details.globalPosition, event);
                                                  },
                                                  child: Container(
                                                    height: 20.h,
                                                    width: 20.w,
                                                    decoration: BoxDecoration(
                                                      color: const Color.fromARGB(255, 35, 94, 77),
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: Icon(
                                                      Icons.more_vert,
                                                      size: 16.sp,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          _buildGoingSection(),
                                          SizedBox(height: 2.h),
                                          // Location
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  size: 16.sp,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(width: 4.w),
                                                Expanded(
                                                  child: Text(
                                                    event['location']?.toString() ?? '',
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: Colors.grey,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.2),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 10.h, right: 10.w),
          child: Container(
            height: 40.h,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 35, 94, 77),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: TextButton(
              onPressed: () {
                navigationController.navigateToChild(PromoteEvent());
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
              ),
              child: Text(
                "PROMOTE",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromARGB(255, 250, 244, 228),
                ),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
