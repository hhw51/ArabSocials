import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:arabsocials/src/controllers/navigation_controller.dart';
import 'package:arabsocials/src/view/profile/ProfileDetailsScreen.dart';
import 'package:arabsocials/src/widgets/custombuttons.dart';
import 'package:arabsocials/src/widgets/member_tiles.dart';
import 'package:arabsocials/src/widgets/textfomr_feild.dart';
import '../../apis/get_favorites.dart';
import '../../apis/get_other_users.dart';
import '../../apis/same-profession.dart';
import '../../apis/same_location.dart';
import '../../apis/add_remove_favorite.dart'; // Ensure this import exists

class Memberscreen extends StatefulWidget {
  Memberscreen({Key? key}) : super(key: key);

  @override
  State<Memberscreen> createState() => _MemberscreenState();
}

class _MemberscreenState extends State<Memberscreen> {
  final NavigationController navigationController = Get.put(NavigationController());
  final FavoritesService _favoritesService = FavoritesService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Master list of all fetched members based on current filter
  List<Map<String, dynamic>> _allMembers = [];

  // List to display members after applying search filter
  List<Map<String, dynamic>> _filteredMembers = [];

  Set<int> _processingUserIds = {}; // To track processing user IDs
  bool _isLoading = true;

  bool _isLocationToggled = false;
  bool _isProfessionToggled = false;
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
    _fetchOtherUsers();
    _loadFavoriteUserIds();

    // Listen to changes in the search field with debounce
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel(); // Cancel the debounce timer
    super.dispose();
  }

  void _loadFavoriteUserIds() async {
    try {
      // Read the stored favorite IDs as a comma-separated string
      final favoriteIdsString = await _secureStorage.read(key: 'favoriteUserIds');

      if (favoriteIdsString != null && favoriteIdsString.isNotEmpty) {
        setState(() {
          _allMembers.forEach((member) {
            final userId = int.tryParse(member["id"] ?? "") ?? 0;
            if (favoriteIdsString.split(',').contains(userId.toString())) {
              member["is_favorite"] = true;
            } else {
              member["is_favorite"] = false;
            }
          });
          _filteredMembers = List.from(_allMembers);
        });
      } else {
        // Initialize is_favorite to false if no favorites are stored
        setState(() {
          _allMembers.forEach((member) {
            member["is_favorite"] = false;
          });
          _filteredMembers = List.from(_allMembers);
        });
      }
    } catch (e) {
      print('Error loading favorite users: $e');
    }
  }

  /// Resolves the image path for a member.
  String _resolveImagePath(String? rawPath) {
    if (rawPath == null || rawPath.isEmpty) {
      return "assets/logo/member_group.png"; // local fallback
    }
    if (!rawPath.startsWith('http')) {
      return '$_baseImageUrl$rawPath';
    }
    return rawPath;
  }

  /// Apply search filter to _allMembers and update _filteredMembers
  void _applySearchFilter() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredMembers = List.from(_allMembers);
      });
    } else {
      setState(() {
        _filteredMembers = _allMembers.where((member) {
          final name = member["name"]?.toLowerCase() ?? "";
          final profession = member["profession"]?.toLowerCase() ?? "";
          return name.contains(query) || profession.contains(query);
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

  /// Fetches all members from the backend.
  Future<void> _fetchOtherUsers() async {
    setState(() => _isLoading = true);
    try {
      final data = await GetOtherUsers().getOtherUsers(); // Returns List<User>
      _allMembers = data.map<Map<String, dynamic>>((user) {
        return {
          "id": user.id.toString(),
          "name": user.name ?? "",
          "profession": user.profession ?? "No Profession",
          "location": user.location ?? "USA",
          "imagePath": _resolveImagePath(user.image),
          "email": user.email ?? "",
          "is_favorite": user.is_favorite == true,
          "phone": user.phone ?? "",
          "gender": user.gender ?? "",
          "nationality": user.nationality ?? "",
          "dob": user.dob ?? "",
          "marital_status": user.maritalStatus ?? "" // Ensure is_favorite is fetched
        };
      }).toList();
      _applySearchFilter(); // Apply any existing search query
    } catch (e) {
      print("Error fetching users: $e");
      // Clear lists on error
      setState(() {
        _allMembers = [];
        _filteredMembers = [];
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Fetches users based on selected locations.
  Future<void> _fetchSameLocationUsers(List<String> locations) async {
    setState(() => _isLoading = true);
    try {
      final sameLocData = await SameLocation().getUsersByLocations(locations); // Pass selected locations
      _allMembers = sameLocData.map<Map<String, dynamic>>((user) {
        return {
          "id": user.id.toString(),
          "name": user.name ?? "",
          "profession": user.profession ?? "No Profession",
          "location": user.location ?? "USA",
          "imagePath": _resolveImagePath(user.image),
          "email": user.email ?? "",
          "is_favorite": user.is_favorite == true,
          "phone": user.phone ?? "",
          "gender": user.gender ?? "",
          "nationality": user.nationality ?? "",
          "dob": user.dob ?? "",
          "marital_status": user.maritalStatus ?? "", // Ensure is_favorite is fetched
        };
      }).toList();
      _applySearchFilter(); // Apply any existing search query
    } catch (e) {
      print("Error fetching same-location users: $e");
      // Clear lists on error
      setState(() {
        _allMembers = [];
        _filteredMembers = [];
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchSameProfessionUsers() async {
    setState(() => _isLoading = true);
    try {
      final sameProfData = await SameProfession().getSameProfessionUsers(); // Returns List<User>
      _allMembers = sameProfData.map<Map<String, dynamic>>((user) {
        return {
          "id": user.id.toString(),
          "name": user.name ?? "",
          "profession": user.profession ?? "No Profession",
          "location": user.location ?? "USA",
          "imagePath": _resolveImagePath(user.image),
          "email": user.email ?? "",
          "is_favorite": user.is_favorite == true,
          "phone": user.phone ?? "",
          "gender": user.gender ?? "",
          "nationality": user.nationality ?? "",
          "dob": user.dob ?? "",
          "marital_status": user.maritalStatus ?? "" // Ensure is_favorite is fetched
        };
      }).toList();
      _applySearchFilter(); // Apply any existing search query
    } catch (e) {
      print("Error fetching same-profession users: $e");
      // Clear lists on error
      setState(() {
        _allMembers = [];
        _filteredMembers = [];
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchFavoriteUsers() async {
    setState(() => _isLoading = true);
    try {
      final favoriteData = await GetFavorites().getFavoriteUsers(); // Returns List<User>
      _allMembers = favoriteData.map<Map<String, dynamic>>((user) {
        return {
          "id": user.id.toString(),
          "name": user.name ?? "",
          "profession": user.profession ?? "No Profession",
          "location": user.location ?? "USA",
          "imagePath": _resolveImagePath(user.image),
          "email": user.email ?? "",
          "is_favorite": user.is_favorite == true,
          "phone": user.phone ?? "",
          "gender": user.gender ?? "",
          "nationality": user.nationality ?? "",
          "dob": user.dob ?? "",
          "marital_status": user.maritalStatus ?? "" // Ensure is_favorite is fetched
        };
      }).toList();
      _applySearchFilter(); // Apply any existing search query
    } catch (e) {
      print("Error fetching favorite users: $e");
      // Clear lists on error
      setState(() {
        _allMembers = [];
        _filteredMembers = [];
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Toggles the favorite status of a member with optimistic UI update and processing flag.
  Future<void> _onFavoriteIconTap(int userId) async {
    if (_processingUserIds.contains(userId)) return; // Prevent multiple taps

    final memberIndex = _allMembers.indexWhere((member) => int.parse(member["id"]!) == userId);
    if (memberIndex == -1) return;

    final isCurrentlyFavorite = _allMembers[memberIndex]["is_favorite"] == true;

    // **Optimistically update the UI**
    setState(() {
      _allMembers[memberIndex]["is_favorite"] = !isCurrentlyFavorite;
      _processingUserIds.add(userId); // Mark as processing
    });

    try {
      if (isCurrentlyFavorite) {
        await _favoritesService.removeFavorite(userId: userId);
      } else {
        await _favoritesService.addFavorite(userId: userId);
      }

      // **Persist the updated favoriteUserIds to Flutter Secure Storage**
      final favoriteIds = _allMembers
          .where((member) => member["is_favorite"] == true)
          .map((member) => member["id"])
          .join(',');

      await _secureStorage.write(
        key: 'favoriteUserIds',
        value: favoriteIds,
      );
    } catch (e) {
      print('Failed to update favorite status: $e');

      // **Revert the UI state if the API call fails**
      setState(() {
        _allMembers[memberIndex]["is_favorite"] = isCurrentlyFavorite;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update favorite status: $e')),
      );
    } finally {
      // **Remove the userId from processing set**
      setState(() {
        _processingUserIds.remove(userId);
      });
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
        _isProfessionToggled = false;
        _isFavoriteToggled = false;
      });
      await _fetchOtherUsers();
      return;
    }

    // If Location filter is already toggled and there are selected states, reset filter
    if (_isLocationToggled && _selectedStates.isNotEmpty) {
      setState(() {
        _isLocationToggled = false;
        _selectedStates = [];
        // Reset other filters
        _isProfessionToggled = false;
        _isFavoriteToggled = false;
      });
      await _fetchOtherUsers();
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
          _isProfessionToggled = false;
          _isFavoriteToggled = false;
        });
        await _fetchSameLocationUsers(selected);
      } else {
        // If no states were selected, remove the location filter
        setState(() {
          _isLocationToggled = false;
          _selectedStates = [];
          // Reset other filters
          _isProfessionToggled = false;
          _isFavoriteToggled = false;
        });
        await _fetchOtherUsers();
      }
    }
  }

  void _onProfessionTap() {
    if (_isLocationToggled) {
      setState(() => _isLocationToggled = false);
    }
    if (_isFavoriteToggled) {
      setState(() => _isFavoriteToggled = false);
    }
    if (_isProfessionToggled) {
      setState(() => _isProfessionToggled = false);
      _fetchOtherUsers();
    } else {
      setState(() => _isProfessionToggled = true);
      _fetchSameProfessionUsers();
    }
  }

  void _onFavoriteTap() {
    if (_isLocationToggled) {
      setState(() => _isLocationToggled = false);
    }
    if (_isProfessionToggled) {
      setState(() => _isProfessionToggled = false);
    }
    if (_isFavoriteToggled) {
      setState(() => _isFavoriteToggled = false);
      _fetchOtherUsers();
    } else {
      setState(() => _isFavoriteToggled = true);
      _fetchFavoriteUsers();
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
                      SizedBox(width: 3.w),
                      const Expanded(child: SizedBox()),
                      SizedBox(width: 3.w),
                      CustomContainer(
                        text: "Favourite",
                        icon: Icons.favorite_border,
                        onTap: () {
                          print("Favorite Container tapped!");
                          _onFavoriteTap();
                        },
                      ),
                      SizedBox(width: 3.w),
                      CustomContainer(
                        text: "Location",
                        icon: Icons.location_on_outlined,
                        onTap: () {
                          print("Location Container tapped!");
                          _onLocationTap();
                        },
                      ),
                      SizedBox(width: 3.w),
                      CustomContainer(
                        text: "Profession",
                        image: "assets/icons/calculator.png", // Use appropriate icon
                        onTap: () {
                          print("Profession Container tapped!");
                          _onProfessionTap();
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
                    "EXPLORE MEMBERS",
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
                    controller: _searchController,
                    hintText: "Member names or professions",
                  ),
                ),

                /// Content
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _filteredMembers.isEmpty
                      ? Center(
                    child: Text(
                      "No members found.",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey,
                      ),
                    ),
                  )
                      : ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _filteredMembers.length,
                    itemBuilder: (context, index) {
                      final member = _filteredMembers[index];
                      final userId = int.tryParse(member["id"] ?? "") ?? 0;
                      final isFavorite = member["is_favorite"] == true;
                      final isProcessing = _processingUserIds.contains(userId);
                      return InkWell(
                        onTap: () {
                          navigationController.navigateToChild(
                            ProfileDetailsScreen(
                              title: "Member Profile",
                              name: member["name"]!,
                              professionOrCategory: member["profession"]!,
                              location: member["location"]!,
                              imagePath: member["imagePath"]!,
                              about: "This is some info about ${member["name"]}",
                              interestsOrCategories: [
                                "Music",
                                "Art",
                                "Technology"
                              ],
                              personalDetails: {
                                "Phone": member['phone']!,
                                "Email": member["email"]!,
                                "Location": member["location"]!,
                                "Gender": member['gender']!,
                                "D.O.B": member['dob']!,
                                "Profession": member["profession"]!,
                                "Nationality": member['nationality']!,
                                "Marital Status": member['marital_status']!,
                              },
                            ),
                          );
                        },
                        child: MemberTile(
                          imagePath: member["imagePath"]!,
                          name: member["name"]!,
                          profession: member["profession"]!,
                          location: member["location"]!,
                          isCircular: true,
                          isFavorite: isFavorite, // Use 'is_favorite' from API
                          isProcessing: isProcessing,
                          onFavoriteTap: () => _onFavoriteIconTap(userId),
                          onTap: () {
                            navigationController.navigateToChild(
                              ProfileDetailsScreen(
                                title: "Member Profile",
                                name: member["name"]!,
                                professionOrCategory: member["profession"]!,
                                location: member["location"]!,
                                imagePath: member["imagePath"]!,
                                about: "This is some info about ${member["name"]}",
                                interestsOrCategories: [
                                  "Music",
                                  "Art",
                                  "Technology"
                                ],
                                personalDetails: {
                                  "Phone": member['phone'],
                                  "Email": member["email"],
                                  "Location": member["location"],
                                  "Gender": member['gender'],
                                  "D.O.B": member['dob'],
                                  "Profession": member["profession"],
                                  "Nationality": member['nationality'],
                                  "Marital Status": member['marital_status']!,
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
