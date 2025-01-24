// lib\src\view\events\eventscreen.dart

import 'dart:async';

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
import '../../apis/get_events_by_location.dart'; // Add this line

class Eventscreen extends StatefulWidget {
  Eventscreen({super.key});

  @override
  State<Eventscreen> createState() => _EventscreenState();
}

class _EventscreenState extends State<Eventscreen> {
  final NavigationController navigationController =
  Get.put(NavigationController());
  final ApprovedEvents approvedEventsService = ApprovedEvents();
  final EventService _eventService = EventService(); // Initialize EventService
  final GetSavedEvents _getSavedEvents = GetSavedEvents();
  final GetEventsByLocation _getEventsByLocation = GetEventsByLocation(); // Add this line

  final RegisterEventController eventController =
  Get.put(RegisterEventController()); // Initialize RegisterEventController

  bool isLoading = true;

  // Master list of all fetched events based on current filter
  List<Map<String, dynamic>> _allEvents = [];

  // List to display events after applying search filter
  List<Map<String, dynamic>> _filteredEvents = [];

  Set<int> _processingEventIds = {}; // Tracks events currently being processed
  bool _showingSavedEvents = false; // Indicates if showing saved events

  // Controller for the search field
  final TextEditingController _searchController = TextEditingController();

  Timer? _debounce; // Added debounce timer

  // Map to cache attendees per eventId
  Map<int, List<dynamic>> _attendeesMap = {};

  static const String baseUrl = 'http://35.222.126.155:8000';

  // List of U.S. states
  final List<String> _usStates = [
    "Alabama",
    "Alaska",
    "Arizona",
    "Arkansas",
    "California",
    "Colorado",
    "Connecticut",
    "Delaware",
    "Florida",
    "Georgia",
    "Hawaii",
    "Idaho",
    "Illinois",
    "Indiana",
    "Iowa",
    "Kansas",
    "Kentucky",
    "Louisiana",
    "Maine",
    "Maryland",
    "Massachusetts",
    "Michigan",
    "Minnesota",
    "Mississippi",
    "Missouri",
    "Montana",
    "Nebraska",
    "Nevada",
    "New Hampshire",
    "New Jersey",
    "New Mexico",
    "New York",
    "North Carolina",
    "North Dakota",
    "Ohio",
    "Oklahoma",
    "Oregon",
    "Pennsylvania",
    "Rhode Island",
    "South Carolina",
    "South Dakota",
    "Tennessee",
    "Texas",
    "Utah",
    "Vermont",
    "Virginia",
    "Washington",
    "West Virginia",
    "Wisconsin",
    "Wyoming",
  ];

  // Store selected states
  List<String> _selectedStates = [];
  bool _isLocationToggled = false; // Add this line

  @override
  void initState() {
    super.initState();
    fetchApprovedEvents();

    // Listen to changes in the search field with debounce
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel(); // Cancel the debounce timer
    super.dispose();
  }

  /// Toggles the bookmark state of an event with optimistic UI update and processing flag.
  Future<void> _toggleBookmark(int eventId) async {
    if (_processingEventIds.contains(eventId)) {
      // Prevent multiple taps while processing
      return;
    }

    final eventIndex = _allEvents.indexWhere((event) => event['id'] == eventId);
    if (eventIndex == -1) return;

    final isCurrentlyBookmarked = _allEvents[eventIndex]['bookmarked'] == true;

    // Add to processing
    setState(() {
      _processingEventIds.add(eventId);
    });

    try {
      Map<String, dynamic> response;
      if (isCurrentlyBookmarked) {
        // Remove bookmark
        response = await _eventService.removeEvent(eventId: eventId);
        // response['is_saved'] should be false
        bool isSaved = response['is_saved'] == true;

        if (!isSaved) {
          // Successfully removed
          setState(() {
            _allEvents[eventIndex]['bookmarked'] = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Removed from bookmarks')),
          );
        } else {
          // Failed to remove
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to remove from bookmarks')),
          );
          // Revert UI
          setState(() {
            _allEvents[eventIndex]['bookmarked'] = true;
          });
        }
      } else {
        // Add bookmark
        response = await _eventService.saveEvent(eventId: eventId);
        // response['is_saved'] should be true
        bool isSaved = response['is_saved'] == true;

        if (isSaved) {
          setState(() {
            _allEvents[eventIndex]['bookmarked'] = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Added to bookmarks')),
          );
        } else {
          // Failed to add
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add to bookmarks')),
          );
          // Revert UI
          setState(() {
            _allEvents[eventIndex]['bookmarked'] = false;
          });
        }
      }
    } catch (e) {
      print('Failed to toggle bookmark: $e');

      // Revert the UI state if the API call fails
      setState(() {
        _allEvents[eventIndex]['bookmarked'] = isCurrentlyBookmarked;
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

  /// Toggles between showing all approved events and saved events.
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
    setState(() {
      isLoading = true;
    });
    try {
      final fetchedSavedEvents = await _getSavedEvents.getSavedEvents();
      final processedEvents = fetchedSavedEvents.map((event) {
        final eventDate = DateTime.parse(event['event_date']);
        final day = eventDate.day;
        final month = _monthAbbreviation(eventDate.month);
        return {
          ...event as Map<String, dynamic>,
          'day': day,
          'month': month,
          'bookmarked': event['is_saved'] == true, // Map is_saved to bookmarked
        };
      }).toList();

      setState(() {
        _allEvents = processedEvents;
        _applySearchFilter(); // Apply any existing search query
        _showingSavedEvents = true;
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

  /// Converts month number to its abbreviation.
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

  /// Fetches approved events from the backend.
  Future<void> fetchApprovedEvents() async {
    setState(() {
      isLoading = true;
    });
    try {
      final fetchedEvents = await approvedEventsService.getApprovedEvents();
      final processedEvents = fetchedEvents.map((event) {
        final eventDate = DateTime.parse(event['event_date']);
        final day = eventDate.day;
        final month = _monthAbbreviation(eventDate.month);
        return {
          ...event as Map<String, dynamic>,
          'day': day,
          'month': month,
          'bookmarked': event['is_saved'] == true, // Map is_saved to bookmarked
        };
      }).toList();

      setState(() {
        _allEvents = processedEvents;
        _applySearchFilter(); // Apply any existing search query
        _showingSavedEvents = false;
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

  /// Apply search filter to _allEvents and update _filteredEvents
  void _applySearchFilter() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredEvents = List.from(_allEvents);
      });
    } else {
      setState(() {
        _filteredEvents = _allEvents.where((event) {
          final title = event["title"]?.toString().toLowerCase() ?? "";
          final type = event["event_type"]?.toString().toLowerCase() ?? "";
          final location = event["location"]?.toString().toLowerCase() ?? "";
          // Add more fields if necessary
          return title.contains(query) ||
              type.contains(query) ||
              location.contains(query);
        }).toList();
      });
    }
  }

  /// Listener callback for search input changes with debounce
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _applySearchFilter();
    });
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

  /// Builds the "Going" section with attendee avatars.
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
          width: displayCount * 24.w + (displayCount - 1) * 6.w, // Adjust width based on number of images
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

  /// Opens a dialog for selecting locations with checkboxes
  void _onLocationTap() async {
    // If Location filter is already toggled and no selected states, reset filter
    if (_isLocationToggled && _selectedStates.isEmpty) {
      setState(() {
        _isLocationToggled = false;
        _selectedStates = [];
      });
      await fetchApprovedEvents();
      return;
    }

    // If Location filter is already toggled and there are selected states, reset filter
    if (_isLocationToggled && _selectedStates.isNotEmpty) {
      setState(() {
        _isLocationToggled = false;
        _selectedStates = [];
      });
      await fetchApprovedEvents();
      return;
    }

    // Show the dialog and wait for user selection
    final selected = await showDialog<List<String>>(
      context: context,
      builder: (context) {
        // Temporary list to hold selections
        List<String> tempSelected = List.from(_selectedStates);

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Select Locations'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: _usStates.map((state) {
                    return CheckboxListTile(
                      title: Text(state),
                      value: tempSelected.contains(state),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            tempSelected.add(state);
                          } else {
                            tempSelected.remove(state);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cancel
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(tempSelected); // Return selected
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );

    // If the user pressed OK and made a selection
    if (selected != null) {
      if (selected.isNotEmpty) {
        // Apply the location filter
        setState(() {
          _isLocationToggled = true;
          _selectedStates = selected;
        });
        await _fetchEventsByLocation(selected);
      } else {
        // If no states were selected, remove the location filter
        setState(() {
          _isLocationToggled = false;
          _selectedStates = [];
        });
        await fetchApprovedEvents();
      }
    }
  }

  /// Fetches events based on selected locations.
  Future<void> _fetchEventsByLocation(List<String> locations) async {
    setState(() => isLoading = true);
    try {
      final locationData = await _getEventsByLocation.getEventsByLocations(locations);
      _allEvents = locationData.map<Map<String, dynamic>>((event) {
        final eventDate = DateTime.parse(event.eventDate);
        final day = eventDate.day;
        final month = _monthAbbreviation(eventDate.month);
        return {
          "id": event.id,
          "title": event.title,
          "description": event.description,
          "event_date": event.eventDate,
          "location": event.location,
          "day": day,
          "month": month,
          "bookmarked": false, // Default to false, update as needed
        };
      }).toList();
      _applySearchFilter(); // Apply any existing search query
    } catch (e) {
      print("Error fetching events by location: $e");
      // Clear lists on error
      setState(() {
        _allEvents = [];
        _filteredEvents = [];
      });
    } finally {
      setState(() => isLoading = false);
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
                          const Expanded(child: SizedBox()),
                          SizedBox(width: 3.w),
                          CustomContainer(
                            text: "Saved",
                            icon: Icons.bookmark_border,
                            onTap: () {
                              _toggleSavedEventsView();
                            },
                          ),
                          CustomContainer(
                            text: "Location",
                            icon: Icons.location_on_outlined,
                            onTap: () {
                              _onLocationTap();
                            },
                          ),
                          const CustomContainer(
                            text: "Date",
                            image: "assets/icons/calculator.png",
                          ),
                        ],
                      ),
                    ),
                    // Custom Buttons Row
                    // Section Title
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
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
                      child: CustomTextFormField(
                        controller: _searchController,
                        hintText: "Search events",
                      ),
                    ),
                    // Events List
                    if (!isLoading)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: _filteredEvents.isEmpty
                            ? Center(
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              "No events found.",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                            : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _filteredEvents.length,
                          itemBuilder: (context, index) {
                            final event = _filteredEvents[index];
                            final eventId = event['id'] as int;

                            return FutureBuilder<List<dynamic>>(
                              future: _fetchAttendees(eventId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Padding(
                                    padding:
                                    const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Container(
                                      height: 233.h,
                                      child: Center(
                                          child:
                                          CircularProgressIndicator()),
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Padding(
                                    padding:
                                    const EdgeInsets.symmetric(
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
                                              horizontal: 12,
                                              vertical: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(12),
                                                    child: event['flyer'] !=
                                                        null &&
                                                        event['flyer']
                                                            .isNotEmpty
                                                        ? Image.network(
                                                      '$baseUrl${event['flyer']}',
                                                      fit: BoxFit.cover,
                                                      height: 131.h,
                                                      width:
                                                      double.infinity,
                                                      errorBuilder:
                                                          (context,
                                                          error,
                                                          stackTrace) =>
                                                          Image.asset(
                                                            'assets/logo/homegrid.png',
                                                            fit:
                                                            BoxFit.cover,
                                                            height:
                                                            131.h,
                                                            width:
                                                            double.infinity,
                                                          ),
                                                    )
                                                        : Image.asset(
                                                      'assets/logo/homegrid.png',
                                                      fit: BoxFit.cover,
                                                      height: 131.h,
                                                      width:
                                                      double.infinity,
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
                                                              fontSize:
                                                              14.sp,
                                                              color:
                                                              Colors.green,
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
                                                              fontSize:
                                                              8.sp,
                                                              color:
                                                              Colors.green,
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
                                                          color:
                                                          Colors.white,
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              6.r),
                                                        ),
                                                        child: _processingEventIds
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
                                                padding:
                                                const EdgeInsets
                                                    .symmetric(
                                                    vertical: 6),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        event['title']
                                                            ?.toString() ??
                                                            '',
                                                        maxLines: 1,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                        style: GoogleFonts
                                                            .playfairDisplaySc(
                                                          fontSize:
                                                          12.sp,
                                                          color:
                                                          Colors.black,
                                                          fontWeight:
                                                          FontWeight
                                                              .w700,
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTapDown:
                                                          (details) {
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
                                                              .fromARGB(
                                                              255,
                                                              35,
                                                              94,
                                                              77),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              6),
                                                        ),
                                                        child: Icon(
                                                          Icons.more_vert,
                                                          size: 16.sp,
                                                          color:
                                                          Colors.white,
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
                                                padding:
                                                const EdgeInsets
                                                    .symmetric(
                                                    vertical: 4),
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
                                                          fontSize:
                                                          12.sp,
                                                          color:
                                                          Colors.grey,
                                                        ),
                                                        maxLines: 1,
                                                        overflow:
                                                        TextOverflow
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
                  ],
                ),
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.1), // Optional: Dim the background
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
