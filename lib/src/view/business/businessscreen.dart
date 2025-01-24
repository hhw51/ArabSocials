import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:arabsocials/src/controllers/navigation_controller.dart';
import 'package:arabsocials/src/services/auth_services.dart';
import 'package:arabsocials/src/widgets/business_tiles.dart';
import 'package:arabsocials/src/widgets/custombuttons.dart';
import 'package:arabsocials/src/widgets/textfomr_feild.dart';
import '../../apis/add_remove_favorite.dart';
import '../../view/profile/ProfileDetailsScreen.dart';

class Businessscreen extends StatefulWidget {
  const Businessscreen({super.key});

  @override
  State<Businessscreen> createState() => _BusinessscreenState();
}

class _BusinessscreenState extends State<Businessscreen> {
  final NavigationController navigationController = Get.put(NavigationController());
  final AuthService _authService = AuthService();
  final FavoritesService _favoritesService = FavoritesService();

  // Master list of all fetched businesses based on current filter
  List<Map<String, dynamic>> _allBusinesses = [];

  // List to display businesses after applying search filter
  List<Map<String, dynamic>> _filteredBusinesses = [];

  Set<int> _processingBusinessIds = {}; // To track processing business IDs
  bool _isLoading = true;

  bool _isLocationToggled = false;
  bool _isFavoriteToggled = false;

  // Controller for the search field
  final TextEditingController _searchController = TextEditingController();

  // Timer for debounce
  Timer? _debounce;

  static const String _baseImageUrl = 'http://35.222.126.155:8000';

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

  @override
  void initState() {
    super.initState();
    _fetchAllBusinesses(); // Fetch business data

    // Listen to changes in the search field with debounce
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel(); // Cancel the debounce timer
    super.dispose();
  }

  /// Resolves the image path for a business.
  String _resolveImagePath(String? rawPath) {
    if (rawPath == null || rawPath.isEmpty) {
      return "assets/logo/member_group.png";
    }
    if (!rawPath.startsWith('http')) {
      return '$_baseImageUrl$rawPath';
    }
    return rawPath;
  }

  /// Apply search filter to _allBusinesses and update _filteredBusinesses
  void _applySearchFilter() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredBusinesses = List.from(_allBusinesses);
      });
    } else {
      setState(() {
        _filteredBusinesses = _allBusinesses.where((business) {
          final name = business["name"]?.toLowerCase() ?? "";
          final category = business["category"]?.toLowerCase() ?? "";
          final location = business["location"]?.toLowerCase() ?? "";
          // Add more fields if necessary
          return name.contains(query) ||
              category.contains(query) ||
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

  /// Fetches all businesses from the backend.
  Future<void> _fetchAllBusinesses() async {
    setState(() => _isLoading = true);
    try {
      final businessData = await _authService.getOtherBusinessUsers();
      _allBusinesses = businessData.map<Map<String, dynamic>>((business) {
        return {
          "id": business["id"].toString(),
          "name": business["name"] ?? "No Name",
          "category": business["category"] ?? "No Category",
          "location": business["location"] ?? "Unknown",
          "imagePath": _resolveImagePath(business["image"]),
          "email": business["email"] ?? "No Email",
          "is_favorite": business["is_favorite"] == true, // Correctly mapped as boolean
        };
      }).toList();

      setState(() {
        _filteredBusinesses = List.from(_allBusinesses); // Initialize filtered list
        _isLoading = false;
      });
      print('All businesses fetched and updated.');
    } catch (e) {
      print("Error fetching businesses: $e");
      setState(() {
        _allBusinesses = [];
        _filteredBusinesses = [];
        _isLoading = false;
      });
    }
  }

  /// Fetches businesses with the same location from the backend.
  Future<void> _fetchSameLocationBusinesses(List<String> locations) async {
    setState(() => _isLoading = true);
    try {
      final locationData = await _authService.getBusinessUsersWithSameLocation(locations);
      _allBusinesses = locationData.map<Map<String, dynamic>>((business) {
        return {
          "id": business["id"].toString(),
          "name": business["name"] ?? "No Name",
          "category": business["category"] ?? "No Category",
          "location": business["location"] ?? "Unknown",
          "imagePath": _resolveImagePath(business["image"]),
          "email": business["email"] ?? "No Email",
          "is_favorite": business["is_favorite"] == true, // Correctly mapped as boolean
        };
      }).toList();

      setState(() {
        _filteredBusinesses = List.from(_allBusinesses); // Initialize filtered list
        _isLoading = false;
      });
      print('Same-location businesses fetched and updated.');
    } catch (e) {
      print("Error fetching same-location businesses: $e");
      setState(() {
        _allBusinesses = [];
        _filteredBusinesses = [];
        _isLoading = false;
      });
    }
  }

  /// Fetches favorite businesses from the backend.
  Future<void> _fetchFavoriteBusinesses() async {
    setState(() => _isLoading = true);
    try {
      final favoriteData = await _authService.getFavoriteBusinessUsers();
      _allBusinesses = favoriteData.map<Map<String, dynamic>>((business) {
        return {
          "id": business["id"].toString(),
          "name": business["name"] ?? "No Name",
          "category": business["category"] ?? "No Category",
          "location": business["location"] ?? "Unknown",
          "imagePath": _resolveImagePath(business["image"]),
          "email": business["email"] ?? "No Email",
          "is_favorite": business["is_favorite"] == true, // Correctly mapped as boolean
        };
      }).toList();

      setState(() {
        _filteredBusinesses = List.from(_allBusinesses); // Initialize filtered list
        _isLoading = false;
      });
      print('Favorite businesses fetched and updated.');
    } catch (e) {
      print("Error fetching favorite businesses: $e");
      setState(() {
        _allBusinesses = [];
        _filteredBusinesses = [];
        _isLoading = false;
      });
    }
  }

  /// Toggles the bookmark state of a business with optimistic UI update and processing flag.
  Future<void> _onFavoriteIconTap(int businessId) async {
    if (_processingBusinessIds.contains(businessId)) return;

    final businessIndex = _allBusinesses.indexWhere((business) => int.parse(business["id"]!) == businessId);
    if (businessIndex == -1) return;

    final isCurrentlyFavorite = _allBusinesses[businessIndex]["is_favorite"] == true;

    setState(() {
      _allBusinesses[businessIndex]["is_favorite"] = !isCurrentlyFavorite;
      _processingBusinessIds.add(businessId);
    });

    try {
      if (isCurrentlyFavorite) {
        await _favoritesService.removeFavorite(userId: businessId);
      } else {
        await _favoritesService.addFavorite(userId: businessId);
      }

      // Optionally, refetch the business list to ensure consistency
      // await _fetchAllBusinesses();
    } catch (e) {
      print('Failed to update favorite status: $e');

      // Revert UI state on error
      setState(() {
        _allBusinesses[businessIndex]["is_favorite"] = isCurrentlyFavorite;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update bookmark status: $e')),
      );
    } finally {
      setState(() {
        _processingBusinessIds.remove(businessId);
      });
    }
  }

  /// Toggles between showing all businesses and favorite businesses.
  void _onFavoriteTap() {
    if (_isLocationToggled) {
      setState(() => _isLocationToggled = false);
    }
    if (_isFavoriteToggled) {
      setState(() => _isFavoriteToggled = false);
      _fetchAllBusinesses();
    } else {
      setState(() => _isFavoriteToggled = true);
      _fetchFavoriteBusinesses();
    }
  }

  /// Opens a dialog for selecting locations with checkboxes
  void _onLocationTap() async {
    // If Location filter is already toggled and no selected states, reset filter
    if (_isLocationToggled && _selectedStates.isEmpty) {
      setState(() {
        _isLocationToggled = false;
        _selectedStates = [];
        // Reset other filters
        _isFavoriteToggled = false;
      });
      await _fetchAllBusinesses();
      return;
    }

    // If Location filter is already toggled and there are selected states, reset filter
    if (_isLocationToggled && _selectedStates.isNotEmpty) {
      setState(() {
        _isLocationToggled = false;
        _selectedStates = [];
        // Reset other filters
        _isFavoriteToggled = false;
      });
      await _fetchAllBusinesses();
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
          // Reset other filters
          _isFavoriteToggled = false;
        });
        await _fetchSameLocationBusinesses(selected);
      } else {
        // If no states were selected, remove the location filter
        setState(() {
          _isLocationToggled = false;
          _selectedStates = [];
          // Reset other filters
          _isFavoriteToggled = false;
        });
        await _fetchAllBusinesses();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 250, 244, 228),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Top bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          navigationController.navigateBack();
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Color.fromARGB(255, 35, 94, 77),
                          size: 24,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      CustomContainer(
                        text: "Favourite",
                        icon: Icons.favorite_border,
                        onTap: () {
                          _onFavoriteTap();
                        },
                      ),
                      SizedBox(width: 3.w),
                      CustomContainer(
                        text: "Location",
                        icon: Icons.location_on_outlined, // Update color based on toggle
                        onTap: () {
                          _onLocationTap();
                        },
                      ),
                      SizedBox(width: 3.w),
                      CustomContainer(
                        text: "Categories",
                        icon: Icons.category, // Use appropriate icon
                        onTap: () {
                          // Implement categories filter if needed
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                /// Title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    "Explore Businesses",
                    style: GoogleFonts.playfairDisplaySc(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                /// Search
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: CustomTextFormField(
                    controller: _searchController, // Assign controller
                    hintText: "Search businesses by name or category",
                  ),
                ),
                /// Content
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _filteredBusinesses.isEmpty
                      ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "No businesses found.",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                      : ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _filteredBusinesses.length,
                    itemBuilder: (context, index) {
                      final business = _filteredBusinesses[index];
                      final businessId = int.tryParse(business["id"] ?? "") ?? 0;
                      final isFavorite = business["is_favorite"] == true;
                      final isProcessing = _processingBusinessIds.contains(businessId);
                      return InkWell(
                        onTap: () {
                          navigationController.navigateToChild(
                            ProfileDetailsScreen(
                              title: "Business Profile",
                              name: business["name"]!,
                              professionOrCategory: business["category"]!,
                              location: business["location"]!,
                              imagePath: business["imagePath"]!,
                              about: "Details about ${business["name"]}",
                              interestsOrCategories: [
                                "Technology",
                                "Innovation",
                                "Finance"
                              ],
                              personalDetails: {
                                "Phone": "1234567890",
                                "Email": business["email"]!,
                                "Location": business["location"]!,
                                "Category": business["category"]!,
                              },
                            ),
                          );
                        },
                        child: BusinessTile(
                          imagePath: business["imagePath"]!,
                          name: business["name"]!,
                          category: business["category"]!,
                          location: business["location"]!,
                          isCircular: true,
                          isFavorite: isFavorite, // Use 'is_favorite' from API
                          isProcessing: isProcessing,
                          onFavoriteTap: () => _onFavoriteIconTap(businessId),
                          onTap: () {
                            navigationController.navigateToChild(
                              ProfileDetailsScreen(
                                title: "Business Profile",
                                name: business["name"]!,
                                professionOrCategory: business["category"]!,
                                location: business["location"]!,
                                imagePath: business["imagePath"]!,
                                about: "Details about ${business["name"]}",
                                interestsOrCategories: [
                                  "Technology",
                                  "Innovation",
                                  "Finance"
                                ],
                                personalDetails: {
                                  "Phone": "1234567890",
                                  "Email": business["email"]!,
                                  "Location": business["location"]!,
                                  "Category": business["category"]!,
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
