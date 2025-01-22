// eventscreen.dart
import 'package:arabsocials/src/view/events/promote_event.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:arabsocials/src/controllers/navigation_controller.dart';
import 'package:arabsocials/src/view/events/register_event.dart';
import 'package:arabsocials/src/widgets/custombuttons.dart';
import 'package:arabsocials/src/widgets/textfomr_feild.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../apis/approved_events.dart';
import '../../apis/get_saved_events.dart';
import '../../apis/save_remove_events.dart';
import '../../controllers/registerEventController.dart';
import '../../widgets/popup_event.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; 

class Eventscreen extends StatefulWidget {
  Eventscreen({super.key});

  @override
  State<Eventscreen> createState() => _EventscreenState();
}

class _EventscreenState extends State<Eventscreen> {
  final NavigationController navigationController =
      Get.put(NavigationController());
  final ApprovedEvents approvedEventsService = ApprovedEvents();
  final EventService _eventService = EventService(); 
  final GetSavedEvents _getSavedEvents = GetSavedEvents();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  final RegisterEventController eventController =
      Get.put(RegisterEventController()); 

  bool isLoading = true;
  List<dynamic> events = [];
  final String baseUrl = 'http://35.222.126.155:8000';

  Set<int> _bookmarkedEventIds = {};
  Set<int> _processingEventIds = {}; // Tracks events currently being processed
  bool _showingSavedEvents = false; // Indicates if showing saved events

  // Map to cache attendees per eventId
  Map<int, List<dynamic>> _attendeesMap = {};

  @override
  void initState() {
    super.initState();
    _loadBookmarkedEventIds().then((_) {
      fetchApprovedEvents();
    });
  }

  /// Loads bookmarked event IDs from secure storage.
  Future<void> _loadBookmarkedEventIds() async {
    try {
      final bookmarkedIdsString =
          await _secureStorage.read(key: 'bookmarkedEventIds');
      if (bookmarkedIdsString != null && bookmarkedIdsString.isNotEmpty) {
        setState(() {
          _bookmarkedEventIds =
              bookmarkedIdsString.split(',').map((id) => int.parse(id)).toSet();
        });
        print('Bookmarked Event IDs loaded: $_bookmarkedEventIds');
      } else {
        setState(() {
          _bookmarkedEventIds = {};
        });
        print('No bookmarked Event IDs found.');
      }
    } catch (e) {
      print('Error loading bookmarked event IDs: $e');
    }
  }

  /// Saves the current set of bookmarked event IDs to secure storage.
  Future<void> _saveBookmarkedEventIds() async {
    try {
      final bookmarkedIdsString = _bookmarkedEventIds.join(',');
      await _secureStorage.write(
          key: 'bookmarkedEventIds', value: bookmarkedIdsString);
      print('Bookmarked Event IDs saved: $_bookmarkedEventIds');
    } catch (e) {
      print('Error saving bookmarked event IDs: $e');
    }
  }

  /// Toggles the bookmark state of an event with optimistic UI update and processing flag.
  Future<void> _toggleBookmark(int eventId) async {
    if (_processingEventIds.contains(eventId)) {
      // Prevent multiple taps while processing
      return;
    }

    setState(() {
      _processingEventIds.add(eventId);
      // Optimistically update the UI
      if (_bookmarkedEventIds.contains(eventId)) {
        _bookmarkedEventIds.remove(eventId);
      } else {
        _bookmarkedEventIds.add(eventId);
      }
      _updateEventBookmarkState(eventId, _bookmarkedEventIds.contains(eventId));
    });

    try {
      bool isSaved;

      if (_bookmarkedEventIds.contains(eventId)) {
        // Add bookmark
        final response = await _eventService.saveEvent(eventId: eventId);
        isSaved = response['is_saved'];
        print('Save Event Response: $response');

        if (!isSaved) {
          // If API indicates failure, revert the UI
          setState(() {
            _bookmarkedEventIds.remove(eventId);
            _updateEventBookmarkState(eventId, false);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add to bookmarks')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Added to bookmarks')),
          );
        }
      } else {
        // Remove bookmark
        final response = await _eventService.removeEvent(eventId: eventId);
        isSaved = response['is_saved'];
        print('Remove Event Response: $response');

        if (isSaved) {
          // If API indicates failure to remove, revert the UI
          setState(() {
            _bookmarkedEventIds.add(eventId);
            _updateEventBookmarkState(eventId, true);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to remove from bookmarks')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Removed from bookmarks')),
          );
        }
      }

      // Persist the updated bookmarked event IDs
      await _saveBookmarkedEventIds();
    } catch (e) {
      print('Failed to toggle bookmark: $e');
      // Revert the optimistic UI update
      setState(() {
        if (_bookmarkedEventIds.contains(eventId)) {
          _bookmarkedEventIds.remove(eventId);
          _updateEventBookmarkState(eventId, false);
        } else {
          _bookmarkedEventIds.add(eventId);
          _updateEventBookmarkState(eventId, true);
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update bookmark status: $e')),
      );
    } finally {
      // Remove the processing flag
      setState(() {
        _processingEventIds.remove(eventId);
      });
    }
  }

  /// Updates the 'bookmarked' property of an event in the events list.
  void _updateEventBookmarkState(int eventId, bool isBookmarked) {
    final index = events.indexWhere((event) => event['id'] == eventId);
    if (index != -1) {
      setState(() {
        events[index]['bookmarked'] = isBookmarked;
      });
    }
  }

  Future<void> _toggleSavedEventsView() async {
    setState(() {
      isLoading = true;
    });

    if (_showingSavedEvents) {
      // Currently showing saved events, switch to all events
      await fetchApprovedEvents();
      setState(() {
        _showingSavedEvents = false;
      });
    } else {
      // Currently showing all events, switch to saved events
      await fetchSavedEvents();
      setState(() {
        _showingSavedEvents = true;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  /// Fetches saved events from the backend.
  Future<void> fetchSavedEvents() async {
    try {
      final fetchedSavedEvents = await _getSavedEvents.getSavedEvents();
      setState(() {
        events = fetchedSavedEvents.map((event) {
          final eventDate = DateTime.parse(event['event_date']);
          final day = eventDate.day;
          final month = _monthAbbreviation(eventDate.month);
          return {
            ...event as Map<String, dynamic>,
            'day': day,
            'month': month,
            'bookmarked': true, // Since these are saved events
          };
        }).toList();
        isLoading = false;
      });
      print('Saved events fetched and updated.');
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching saved events: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load saved events: $error')),
      );
    }
  }

  String _monthAbbreviation(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
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
            'bookmarked': _bookmarkedEventIds
                .contains(event['id']), // Set based on loaded bookmarks
          };
        }).toList();
        isLoading = false;
      });
      print('Events fetched and updated with bookmark states.');
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching events: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load events: $error')),
      );
    }
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
              (displayCount - 1) *
                  6.w, // Adjust width based on number of images
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
                          CustomContainer(
                            onTap: () {
                              _toggleSavedEventsView();
                            },
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Container(
                                          height: 233.h,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(16.r),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      child: Image.network(
                                                        event['flyer'] !=
                                                                    null &&
                                                                event['flyer'] !=
                                                                    ''
                                                            ? '$baseUrl${event['flyer']}'
                                                            : 'assets/logo/homegrid.png',
                                                        fit: BoxFit.cover,
                                                        height: 131.h,
                                                        width: double.infinity,
                                                        errorBuilder: (context,
                                                                error,
                                                                stackTrace) =>
                                                            Image.asset(
                                                          'assets/logo/homegrid.png',
                                                          fit: BoxFit.cover,
                                                          height: 131.h,
                                                          width:
                                                              double.infinity,
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
                                                    // Bookmark Button
                                                    Positioned(
                                                      top: 10.h,
                                                      right: 12.w,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          _toggleBookmark(
                                                              eventId);
                                                        },
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
                                                          child:
                                                              _processingEventIds
                                                                      .contains(
                                                                          eventId)
                                                                  ? Center(
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            18.w,
                                                                        height:
                                                                            18.h,
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          strokeWidth:
                                                                              2.0,
                                                                          valueColor:
                                                                              AlwaysStoppedAnimation<Color>(
                                                                            Colors.green,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Icon(
                                                                      event['bookmarked']
                                                                          ? Icons
                                                                              .bookmark
                                                                          : Icons
                                                                              .bookmark_outline,
                                                                      color: Colors
                                                                          .green,
                                                                      size:
                                                                          18.sp,
                                                                    ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                // Event Details
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 6),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          event['title']
                                                                  ?.toString() ??
                                                              '',
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: GoogleFonts
                                                              .playfairDisplaySc(
                                                            fontSize: 12.sp,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTapDown: (details) {
                                                          // Implement popup menu
                                                          showCustomPopupMenu(
                                                              context,
                                                              details
                                                                  .globalPosition,
                                                              event);
                                                        },
                                                        child: Container(
                                                          height: 20.h,
                                                          width: 20.w,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color
                                                                .fromARGB(255,
                                                                35, 94, 77),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
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
                                                // Attendees Section
                                                _buildGoingSection(attendees),
                                                SizedBox(height: 2.h),
                                                // Location
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 4),
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
                                                          event['location']
                                                                  ?.toString() ??
                                                              '',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                            color: Colors.grey,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
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
                                  }
                                },
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
