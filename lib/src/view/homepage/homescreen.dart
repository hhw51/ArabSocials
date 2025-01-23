import 'package:arabsocials/src/apis/approved_events.dart';
import 'package:arabsocials/src/apis/get_featured_business.dart';
import 'package:arabsocials/src/apis/get_featured_events.dart';
import 'package:arabsocials/src/controllers/navigation_controller.dart';
import 'package:arabsocials/src/controllers/registerEventController.dart';
import 'package:arabsocials/src/services/auth_services.dart';
import 'package:arabsocials/src/view/events/promote_event.dart';
import 'package:arabsocials/src/view/events/register_event.dart';
import 'package:arabsocials/src/view/homepage/notification_screen.dart';
import 'package:arabsocials/src/view/profile/ProfileDetailsScreen.dart';
import 'package:arabsocials/src/widgets/custom_container.dart';
import 'package:arabsocials/src/widgets/custombuttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final NavigationController navigationController = Get.put(NavigationController());
  final AuthService authService = AuthService();
  final ApprovedEvents approvedEventsService = ApprovedEvents();
  final RegisterEventController eventController =
  Get.put(RegisterEventController());

  bool isLoading = true;
  List<dynamic> savedEvents = [];
  List<dynamic> favoriteUsers = [];
  List<dynamic> featuredEvents = [];
  List<dynamic> featuredBusinesses = [];
  bool isBusinessesLoading = true;

  static const String _baseImageUrl = 'http://35.222.126.155:8000';
  final String baseUrl = 'http://35.222.126.155:8000';

  Set<int> _bookmarkedEventIds = {};
  Set<int> _processingEventIds = {}; // Tracks events currently being processed
  bool _showingSavedEvents = false; // Indicates if showing saved events

  // Map to cache attendees per eventId
  Map<int, List<dynamic>> _attendeesMap = {};
  @override
  void initState() {
    super.initState();
    fetchInitialData();
    fetchFeaturedEvents();
    fetchFeaturedBusinesses();
  }


  Widget _buildGoingSection(List<dynamic> attendees) {
    if (attendees.isEmpty) {
      return SizedBox(); // Show nothing for 0 attendees
    }

    int displayCount = attendees.length <= 3 ? attendees.length : 3;
    int extraCount = attendees.length > 3 ? attendees.length - 3 : 0;

    return Row(
      children: [
        Container(
          height: 24.h,
          width: displayCount * 24.w +
              (displayCount - 1) * 6.w, // Adjust width based on number of images
          child: Stack(
            children: List.generate(displayCount, (i) {
              return Positioned(
                left: i * 18.w, // Overlap images slightly
                child: CircleAvatar(
                  radius: 10.r,
                  backgroundImage: attendees[i]['image'] != null &&
                      attendees[i]['image'].isNotEmpty
                      ? NetworkImage('$baseUrl${attendees[i]['image']}')
                      : AssetImage('assets/logo/member_group.png')
                  as ImageProvider,
                ),
              );
            }),
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          attendees.length > 3 ? '+$extraCount Going' : 'Going',
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color.fromARGB(255, 35, 94, 77),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }


  String _resolveImagePath(String? rawPath) {
    if (rawPath == null || rawPath.isEmpty) {
      return "assets/logo/member_group.png";
    }
    if (!rawPath.startsWith('http')) {
      return '$_baseImageUrl$rawPath';
    }
    return rawPath;
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
        savedEvents = fetchedEvents.map((event) {
          final eventDate = DateTime.parse(event['event_date']);
          final day = eventDate.day;
          final month = _monthAbbreviation(eventDate.month);
          return {
            ...event as Map<String, dynamic>,
            'day': day,
            'month': month,
            'bookmarked': event['bookmarked'] ?? false,
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

  Future<void> fetchInitialData() async {
    await Future.wait([
      fetchFavoriteUsers(),
    ]);
  }



  Future<void> fetchFavoriteUsers() async {
    try {
      final users = await authService.getFavoriteUsers();
      setState(() {
        favoriteUsers = users;
        print("Favouriets are fetching 🤢🤢🤢🤢🤢$favoriteUsers");
      });
    } catch (error) {
      print('Error fetching favorite users: $error');
    }
  }
  void fetchFeaturedEvents() async {
    try {
      final events = await GetFeaturedEvents().getFeaturedEvents();
      setState(() {
        featuredEvents = events;
        print("Featured Events are fetching 🌹🌹🌹🌹🌹$featuredEvents");
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching featured events: $e');
    }
  }
  void fetchFeaturedBusinesses() async {
    try {
      final businesses = await GetFeaturedBusinesses().getFeaturedBusinesses();
      setState(() {
        featuredBusinesses = businesses;
        print("The featured business peoples are coming🙌🙌🙌🙌🙌🙌🙌$featuredBusinesses");
        isBusinessesLoading = false;
      });
    } catch (e) {
      setState(() {
        isBusinessesLoading = false;
      });
      print('Error fetching featured businesses: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 244, 228),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          children: [
            // Top Bar
            Container(
              height: 112.h,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 35, 94, 77),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(36),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 30.h, left: 16.w, right: 16.w),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: 30.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Enter events, members, or business...",
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: const Color.fromARGB(255, 190, 218, 165),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        ),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color.fromARGB(255, 190, 218, 165),
                        ),
                        onChanged: (value) {
                          print("Input: $value");
                        },
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        navigationController.navigateToChild(Notificationscreen());
                      },
                      child: Image(
                        image: const AssetImage('assets/icons/homenotify.png'),
                        height: 36.h,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: SectionHeader(
                        title: "UPCOMING EVENTS",
                        actionText: "See all",
                        onTap: () {
                          print("See all tapped!");
                        },
                      ),
                    ),
                    SizedBox(
                        height: 237.h,
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            itemCount: featuredEvents.length,
                            itemBuilder: (context, index) {
                              final event = featuredEvents[index];
                              final eventId = event['id'] as int;
                              return FutureBuilder<List<dynamic>>(
                                  future: _fetchAttendees(eventId),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Container(
                                          height: 233.h,
                                          child: Center(
                                              child: CircularProgressIndicator()),
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Container(
                                          height: 233.h,
                                          child: Center(
                                              child: Text(
                                                  'Failed to load event data')),
                                        ),
                                      );
                                    } else {
                                      final attendees = snapshot.data ?? [];
                                      return InkWell(
                                        onTap: () {
                                          navigationController.navigateToChild(
                                            RegisterEvent(eventId: eventId),
                                          );
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 10.w),
                                          child: Container(
                                            width: 218.w,
                                            height: 237.h,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(16.r),
                                              color: const Color.fromARGB(255, 247, 247, 247),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(8.w),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(16.r),
                                                        child: Image.network(
                                                          event['flyer'] != null
                                                              ? 'http://35.222.126.155:8000${event['flyer']}'
                                                              : 'assets/logo/default.png',
                                                          fit: BoxFit.cover,
                                                          height: 131.h,
                                                          width: double.infinity,
                                                          errorBuilder: (context, error, stackTrace) =>
                                                              Image.asset(
                                                                'assets/logo/default.png',
                                                                fit: BoxFit.cover,
                                                                height: 131.h,
                                                                width: double.infinity,
                                                              ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 8.h,
                                                        left: 8.w,
                                                        child: Container(
                                                          height: 36.h,
                                                          width: 36.w,
                                                          decoration:
                                                          BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                6.r),
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            children: [
                                                              Text(
                                                                event['day']
                                                                    ?.toString() ??
                                                                    '',
                                                                style: GoogleFonts
                                                                    .playfairDisplaySc(
                                                                  fontSize: 14.sp,
                                                                  color: Colors
                                                                      .green,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                                ),
                                                                maxLines: 1,
                                                                overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                              ),
                                                              Text(
                                                                event['month']
                                                                    ?.toString() ??
                                                                    '',
                                                                style: GoogleFonts
                                                                    .playfairDisplaySc(
                                                                  fontSize: 8.sp,
                                                                  color: Colors
                                                                      .green,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                                ),
                                                                maxLines: 1,
                                                                overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 10.h,
                                                        right: 12.w,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              event['bookmarked'] =
                                                              !(event['bookmarked'] ?? false); // Toggle bookmarked
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
                                                              event['bookmarked'] ?? false
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
                                                  SizedBox(height: 8.h),
                                                  Text(
                                                    event['title']
                                                        ?.toString() ??
                                                        '',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.playfairDisplaySc(
                                                      fontSize: 12.sp,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                  _buildGoingSection(attendees),
                                                  SizedBox(height: 2.h),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_on,
                                                        size: 16.sp,
                                                        color: Colors.grey,
                                                      ),
                                                      SizedBox(width: 4.w),
                                                      Expanded(
                                                        child: Text(
                                                          event['location']
                                                              ?.toString() ??
                                                              '',
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
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                              );
                            })
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 86.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 190, 218, 165),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Promote events",
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                            color: const Color.fromARGB(
                                                255, 35, 94, 77),
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        ElevatedButton(
                                          onPressed: () {
                                            navigationController.navigateToChild(PromoteEvent());
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color.fromARGB(255, 35, 94, 77),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:BorderRadius.circular(8.r),
                                            ),
                                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                          ),
                                          child: Text(
                                            "PROMOTE",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w700,
                                              color: const Color.fromARGB(
                                                  255, 250, 244, 228),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Image.asset('assets/logo/homepromote.png',
                                    height: 85.h,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SectionHeader(
                            title: "FEATURED BUSINESS",
                            actionText: "See all",
                            onTap: () {
                              print("See all tapped!");
                            },
                          ),
                          SizedBox(
                            height: 80.h,
                            child: isBusinessesLoading
                                ? const Center(child: CircularProgressIndicator())
                                : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: featuredBusinesses.length,
                              itemBuilder: (context, index) {
                                final business = featuredBusinesses[index];
                                return CustomLogoContainer(imagePath: business['logo'] != null
                                    ? '$business${business['logo']}'
                                    :  "assets/logo/member_group.png",);
                              },
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Container(
                              height: 86.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 190, 218, 165),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  children: [
                                    // Text and Promote button
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Invite your friends",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w700,
                                              color: const Color.fromARGB(
                                                  255, 35, 94, 77),
                                            ),
                                          ),
                                          SizedBox(height: 8.h),
                                          ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:const Color.fromARGB(255, 35, 94, 77),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(8.r),
                                              ),
                                              padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 8.h),
                                            ),
                                            child: Text(
                                              "INVITE",
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w700,
                                                color: const Color.fromARGB(
                                                    255, 250, 244, 228),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Image Section
                                    Image.asset(
                                      'assets/logo/greensearch.png',
                                      height: 85.h,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SectionHeader(
                            title: "PEOPLE IM CONNECTED TO",
                            actionText: "See all",
                            onTap: () {
                              navigationController.currentIndex(2);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: SizedBox(
                              height: 88.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: favoriteUsers.length,
                                itemBuilder: (context, index) {
                                  final user = favoriteUsers[index];
                                  // log( _baseImageUrl+ user['image']??'');
                                  return InkWell(
                                    onTap: () {
                                      navigationController.navigateToChild(
                                        ProfileDetailsScreen(
                                          title: "Member Profile",
                                          name: user["name"]!,
                                          professionOrCategory: user["profession"]??"",
                                          location: user["location"]??"",
                                          imagePath: user["image"]!=null ?_baseImageUrl+user["image"]??"":'',
                                          about: "This is some info about ${user["name"]}",
                                          interestsOrCategories: [
                                            "Music",
                                            "Art",
                                            "Technology"
                                          ],
                                          personalDetails: {
                                            "Phone": "4788743654478",
                                            "Email": user["email"]??"",
                                            "Location": user["location"]??"",
                                            "Gender": "Female",
                                            "D.O.B": "03-11-2005",
                                            "Profession": user["profession"]??"",
                                            "Nationality": "USA",
                                            "Marital Status": "Single",
                                          },
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 12.w),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          ClipOval(
                                            child:user['image']!=null? Image.network(
                                              _baseImageUrl+user['image'] ?? '',
                                              width: 58.w,
                                              height: 58.h,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) =>
                                                  Image.asset(
                                                    "assets/logo/member_group.png",
                                                    width: 58.w,
                                                    height: 58.h,
                                                    fit: BoxFit.cover,
                                                  ),
                                            ):Image.asset(
                                              "assets/logo/member_group.png",
                                              width: 58.w,
                                              height: 58.h,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Text(
                                            user['name'] ?? '',
                                            style: GoogleFonts.playfairDisplaySc(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.green,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            user['profession'] ?? '',
                                            style: TextStyle(
                                              fontSize: 8.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey[700],
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Fetch attendees for a specific event and cache them
  Future<List<dynamic>> _fetchAttendees(int eventId) async {
    if (_attendeesMap.containsKey(eventId)) {
      return _attendeesMap[eventId]!;
    } else {
      try {
        final attendees =
        await eventController.getRegisteredUsersByEventId(eventId);
        setState(() {
          _attendeesMap[eventId] = attendees!;
        });
        return attendees!;
      } catch (e) {
        print('Error fetching attendees for event $eventId: $e');
        return [];
      }
    }
  }
}