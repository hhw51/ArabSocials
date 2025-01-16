import 'package:arab_socials/src/controllers/navigation_controller.dart';
import 'package:arab_socials/src/services/auth_services.dart'; // Import FavoritesService
import 'package:arab_socials/src/view/profile/ProfileDetailsScreen.dart';
import 'package:arab_socials/src/widgets/business_tiles.dart';
import 'package:arab_socials/src/widgets/custombuttons.dart';
import 'package:arab_socials/src/widgets/textfomr_feild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../apis/add_remove_favorite.dart';

class Businessscreen extends StatefulWidget {
  const Businessscreen({super.key});

  @override
  State<Businessscreen> createState() => _BusinessscreenState();
}

class _BusinessscreenState extends State<Businessscreen> {
  final NavigationController navigationController = Get.put(NavigationController());
  final AuthService _authService = AuthService();
  final FavoritesService _favoritesService = FavoritesService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();// Initialize FavoritesService

  List<Map<String, String>> _apiBusinesses = [];
  Set<int> _favoriteBusinessIds = {};
  Set<int> _processingBusinessIds = {}; // To track processing business IDs
  bool _isLoading = true;

  bool _isLocationToggled = false;
  bool _isFavoriteToggled = false;

  static const String _baseImageUrl = 'http://35.222.126.155:8000';

  @override
  void initState() {
    super.initState(); // Load favorites on initialization
    _fetchAllBusinesses(); // Ensure this method fetches business data
    _loadFavoriteBusinessIds();
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

  void _loadFavoriteBusinessIds() async {
    try {
      // Read the stored favorite business IDs as a comma-separated string
      final favoriteIdsString = await _secureStorage.read(key: 'favoriteBusinessIds');

      if (favoriteIdsString != null && favoriteIdsString.isNotEmpty) {
        setState(() {
          _favoriteBusinessIds = favoriteIdsString
              .split(',')
              .map((id) => int.parse(id))
              .toSet();
        });
      }
    } catch (e) {
      print('Error loading favorite businesses: $e');
    }
  }


  void _fetchAllBusinesses() async {
    setState(() => _isLoading = true);
    try {
      final businessData = await _authService.getOtherBusinessUsers();
      _apiBusinesses = businessData.map<Map<String, String>>((business) {
        return {
          "id": business["id"].toString(),
          "name": business["name"] ?? "No Name",
          "category": business["category"] ?? "No Category",
          "location": business["location"] ?? "Unknown",
          "imagePath": _resolveImagePath(business["image"]),
          "email": business["email"] ?? "No Email",
        };
      }).toList();
    } catch (e) {
      print("Error fetching businesses: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _fetchSameLocationBusinesses() async {
    setState(() => _isLoading = true);
    try {
      final locationData = await _authService.getBusinessUsersWithSameLocation();
      _apiBusinesses = locationData.map<Map<String, String>>((business) {
        return {
          "id": business["id"].toString(),
          "name": business["name"] ?? "No Name",
          "category": business["category"] ?? "No Category",
          "location": business["location"] ?? "Unknown",
          "imagePath": _resolveImagePath(business["image"]),
          "email": business["email"] ?? "No Email",
        };
      }).toList();
    } catch (e) {
      print("Error fetching same-location businesses: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _fetchFavoriteBusinesses() async {
    setState(() => _isLoading = true);
    try {
      final favoriteData = await _authService.getFavoriteBusinessUsers();
      _apiBusinesses = favoriteData.map<Map<String, String>>((business) {
        return {
          "id": business["id"].toString(),
          "name": business["name"] ?? "No Name",
          "category": business["category"] ?? "No Category",
          "location": business["location"] ?? "Unknown",
          "imagePath": _resolveImagePath(business["image"]),
          "email": business["email"] ?? "No Email",
        };
      }).toList();
    } catch (e) {
      print("Error fetching favorite businesses: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }


  /// **Updated:** Optimistic UI implementation with error handling
  void _onFavoriteIconTap(int businessId) async {
    if (_processingBusinessIds.contains(businessId)) return; // Prevent multiple taps

    final isCurrentlyFavorite = _favoriteBusinessIds.contains(businessId);

    // Optimistically update the UI
    setState(() {
      if (isCurrentlyFavorite) {
        _favoriteBusinessIds.remove(businessId);
      } else {
        _favoriteBusinessIds.add(businessId);
      }
      _processingBusinessIds.add(businessId); // Mark as processing
    });

    try {
      if (isCurrentlyFavorite) {
        await _favoritesService.removeFavorite(userId: businessId);
      } else {
        await _favoritesService.addFavorite(userId: businessId);
      }

      // Persist the updated favoriteBusinessIds to Flutter Secure Storage
      await _secureStorage.write(
        key: 'favoriteBusinessIds',
        value: _favoriteBusinessIds.join(','), // Store as comma-separated string
      );

      // Optionally, show a success SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isCurrentlyFavorite ? 'Removed from favorites' : 'Added to favorites',
          ),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Failed to update favorite status: $e');

      // Revert the UI state if the API call fails
      setState(() {
        if (isCurrentlyFavorite) {
          _favoriteBusinessIds.add(businessId);
        } else {
          _favoriteBusinessIds.remove(businessId);
        }
      });

      // Show an error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update favorite status. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      // Remove the businessId from processing set
      setState(() {
        _processingBusinessIds.remove(businessId);
      });
    }
  }


  void _onLocationTap() {
    if (_isFavoriteToggled) {
      setState(() => _isFavoriteToggled = false);
    }
    if (_isLocationToggled) {
      setState(() => _isLocationToggled = false);
      _fetchAllBusinesses();
    } else {
      setState(() => _isLocationToggled = true);
      _fetchSameLocationBusinesses();
    }
  }

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
                  child: const CustomTextFormField(
                    hintText: "Search businesses by name or category",
                  ),
                ),
                /// Content
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _apiBusinesses.length,
                    itemBuilder: (context, index) {
                      final business = _apiBusinesses[index];
                      final businessId = int.tryParse(business["id"] ?? "") ?? 0;
                      final isFavorite = _favoriteBusinessIds.contains(businessId);
                      final isProcessing = _processingBusinessIds.contains(businessId);
                      return BusinessTile(
                        imagePath: business["imagePath"]!,
                        name: business["name"]!,
                        category: business["category"]!,
                        location: business["location"]!,
                        isCircular: true,
                        isFavorite: isFavorite, // Pass favorite status to the tile
                        isProcessing: isProcessing, // Pass processing status
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
                        onFavoriteTap: () => _onFavoriteIconTap(businessId), // Pass businessId
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
