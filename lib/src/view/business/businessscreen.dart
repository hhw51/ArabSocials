import 'package:arab_socials/src/controllers/navigation_controller.dart';
import 'package:arab_socials/src/services/auth_services.dart';
import 'package:arab_socials/src/view/profile/ProfileDetailsScreen.dart';
import 'package:arab_socials/src/widgets/business_tiles.dart';
import 'package:arab_socials/src/widgets/custombuttons.dart';
import 'package:arab_socials/src/widgets/textfomr_feild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class Businessscreen extends StatefulWidget {
  const Businessscreen({super.key});

  @override
  State<Businessscreen> createState() => _BusinessscreenState();
}

class _BusinessscreenState extends State<Businessscreen> {
  final NavigationController navigationController = Get.put(NavigationController());
  final AuthService _authService = AuthService();

  List<Map<String, String>> _apiBusinesses = [];
  Set<int> _favoriteBusinessIds = {};
  bool _isLoading = true;

  bool _isLocationToggled = false;
  bool _isFavoriteToggled = false;

  final Color _lightGreen = const Color.fromARGB(255, 163, 214, 180);
  final Color _darkGreen = const Color.fromARGB(255, 35, 94, 77);

  static const String _baseImageUrl = 'http://35.222.126.155:8000';

  @override
  void initState() {
    super.initState();
    _fetchAllBusinesses();
    _fetchFavoriteBusinesses();
  }

  String _resolveImagePath(String? rawPath) {
    if (rawPath == null || rawPath.isEmpty) {
      return "assets/logo/default.png";
    }
    if (!rawPath.startsWith('http')) {
      return '$_baseImageUrl$rawPath';
    }
    return rawPath;
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
    try {
      final favorites = await _authService.getFavoriteBusinessUsers();
      setState(() {
        _favoriteBusinessIds = favorites.map<int>((business) => business["id"] as int).toSet();
      });
    } catch (e) {
      print("Error fetching favorite businesses: $e");
    }
  }

  void _onFavoriteIconTap(int businessId) async {
    try {
      if (_favoriteBusinessIds.contains(businessId)) {
        await _authService.removeFavoriteBusiness(businessId);
        setState(() => _favoriteBusinessIds.remove(businessId));
      } else {
        await _authService.addFavoriteBusiness(businessId);
        setState(() => _favoriteBusinessIds.add(businessId));
      }
    } catch (e) {
      print('Failed to update favorite status: $e');
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

  Color get _locationButtonColor => _isLocationToggled ? _darkGreen : _lightGreen;
  Color get _favoriteButtonColor => _isFavoriteToggled ? _darkGreen : _lightGreen;

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
                        icon: Icons.location_on_outlined,
                        onTap: () {
                          _onLocationTap();
                        },
                      ),
                       SizedBox(width: 3.w),
                      CustomContainer(
                        text: "Categories",
                        icon: Icons.location_on_outlined,
                        onTap: () {
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    "Businesses Directory",
                    style: GoogleFonts.playfairDisplaySc(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: const CustomTextFormField(
                    hintText: "Search businesses by name or category",
                  ),
                ),
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
                            return BusinessTile(
                              imagePath: business["imagePath"]!,
                              name: business["name"]!,
                              category: business["category"]!,
                              location: business["location"]!,
                              isCircular: true,
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
                              onFavoriteTap: () => _onFavoriteIconTap(businessId),
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
