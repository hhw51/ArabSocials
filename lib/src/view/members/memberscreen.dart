import 'package:arab_socials/src/controllers/navigation_controller.dart';
import 'package:arab_socials/src/view/profile/ProfileDetailsScreen.dart';
import 'package:arab_socials/src/widgets/custombuttons.dart';
import 'package:arab_socials/src/widgets/member_tiles.dart';
import 'package:arab_socials/src/widgets/textfomr_feild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../apis/get_favorites.dart';
import '../../apis/get_other_users.dart';
import '../../apis/same-profession.dart';
import '../../apis/same_location.dart';
import '../../apis/add_remove_favorite.dart';

class Memberscreen extends StatefulWidget {
  Memberscreen({super.key});

  @override
  State<Memberscreen> createState() => _MemberscreenState();
}

class _MemberscreenState extends State<Memberscreen> {
  final NavigationController navigationController = Get.put(NavigationController());
  final FavoritesService _favoritesService = FavoritesService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();


  List<Map<String, String>> _apiMembers = [];
  Set<int> _favoriteUserIds = {};
  bool _isLoading = true;

  bool _isLocationToggled = false;
  bool _isProfessionToggled = false;
  bool _isFavoriteToggled = false;

  final Color _lightGreen = const Color.fromARGB(255, 163, 214, 180);
  final Color _darkGreen = const Color.fromARGB(255, 35, 94, 77);

  /// Your server domain for building the full image URL
  static const String _baseImageUrl = 'http://35.222.126.155:8000';

  @override
  void initState() {
    super.initState();
    _fetchOtherUsers();
    _loadFavoriteUserIds();
  }

  void _loadFavoriteUserIds() async {
    try {
      // Read the stored favorite IDs as a comma-separated string
      final favoriteIdsString = await _secureStorage.read(key: 'favoriteUserIds');

      if (favoriteIdsString != null && favoriteIdsString.isNotEmpty) {
        setState(() {
          _favoriteUserIds = favoriteIdsString
              .split(',')
              .map((id) => int.parse(id))
              .toSet();
        });
      }
    } catch (e) {
      print('Error loading favorite users: $e');
    }
  }


  /// If the backend path is something like "/media/user_images/xxx.jpg"
  /// we prefix it with _baseImageUrl => "http://.../media/user_images/xxx.jpg"
  /// If it's empty or null, fallback to local asset "assets/logo/member_group.png"
  String _resolveImagePath(String? rawPath) {
    if (rawPath == null || rawPath.isEmpty) {
      return "assets/logo/member_group.png"; // local fallback
    }
    if (!rawPath.startsWith('http')) {
      return '$_baseImageUrl$rawPath';
    }
    return rawPath;
  }

  void _fetchOtherUsers() async {
    setState(() => _isLoading = true);
    try {
      final data = await GetOtherUsers().getOtherUsers();
      _apiMembers = data.map<Map<String, String>>((user) {
        return {
          "id": user["id"].toString(), // Ensure user ID is included here
          "name": user["name"] ?? "No Name",
          "profession": user["profession"] ?? "No Profession",
          "location": user["location"] ?? "USA",
          "imagePath": _resolveImagePath(user["image"]),
          "email": user["email"] ?? "No Email"
        };
      }).toList();
      // _loadFavoriteUserIds();
    } catch (e) {
      print("Error fetching users: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }


  void _fetchSameLocationUsers() async {
    setState(() => _isLoading = true);
    try {
      final sameLocData = await SameLocation().getSameLocationUsers();
      _apiMembers = sameLocData.map<Map<String, String>>((user) {
        return {
          "name": user["name"] ?? "No Name",
          "profession": user["profession"] ?? "No Profession",
          "location": user["location"] ?? "USA",
          "imagePath": _resolveImagePath(user["image"]),
          "email": user["email"] ?? "No Email"
        };
      }).toList();
    } catch (e) {
      print("Error fetching same-location users: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _fetchSameProfessionUsers() async {
    setState(() => _isLoading = true);
    try {
      final sameProfData = await SameProfession().getSameProfessionUsers();
      _apiMembers = sameProfData.map<Map<String, String>>((user) {
        return {
          "name": user["name"] ?? "No Name",
          "profession": user["profession"] ?? "No Profession",
          "location": user["location"] ?? "USA",
          "imagePath": _resolveImagePath(user["image"]),
          "email": user["email"] ?? "No Email"
        };
      }).toList();
    } catch (e) {
      print("Error fetching same-profession users: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _fetchFavoriteUsers() async {
    setState(() => _isLoading = true);
    try {
      final sameProfData = await GetFavorites().getFavoriteUsers();
      _apiMembers = sameProfData.map<Map<String, String>>((user) {
        return {
          "name": user["name"] ?? "No Name",
          "profession": user["profession"] ?? "No Profession",
          "location": user["location"] ?? "USA",
          "imagePath": _resolveImagePath(user["image"]),
          "email": user["email"] ?? "No Email"
        };
      }).toList();
    } catch (e) {
      print("Error fetching same-profession users: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onFavoriteIconTap(int userId) async {
    try {
      if (_favoriteUserIds.contains(userId)) {
        // Remove favorite
        await _favoritesService.removeFavorite(userId: userId);
        setState(() => _favoriteUserIds.remove(userId));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Removed from favorites')),
        );
      } else {
        // Add favorite
        await _favoritesService.addFavorite(userId: userId);
        setState(() => _favoriteUserIds.add(userId));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added to favorites')),
        );
      }

      // Persist the updated favoriteUserIds to Flutter Secure Storage
      await _secureStorage.write(
        key: 'favoriteUserIds',
        value: _favoriteUserIds.join(','), // Store as comma-separated string
      );
    } catch (e) {
      print('Failed to update favorite status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update favorite status: $e')),
      );
    }
  }


  void _onLocationTap() {
    if (_isProfessionToggled) {
      setState(() => _isProfessionToggled = false);
    }
    if (_isFavoriteToggled) {
      setState(() => _isFavoriteToggled = false);
    }
    if (_isLocationToggled) {
      setState(() => _isLocationToggled = false);
      _fetchOtherUsers();
    } else {
      setState(() => _isLocationToggled = true);
      _fetchSameLocationUsers();
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

  Color get _locationButtonColor => _isLocationToggled ? _darkGreen : _lightGreen;
  Color get _professionButtonColor => _isProfessionToggled ? _darkGreen : _lightGreen;
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
                        onTap: (){
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
                        image: "assets/icons/calculator.png",
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
                  child: const CustomTextFormField(
                    hintText: "Member names or professions",
                  ),
                ),

                /// Content
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _apiMembers.length,
                    itemBuilder: (context, index) {
                      final member = _apiMembers[index];
                      final userId = int.tryParse(member["id"] ?? "") ?? 0;
                      return MemberTile(
                        imagePath: member["imagePath"]!,
                        name: member["name"]!,
                        profession: member["profession"]!,
                        location: member["location"]!,
                        isCircular: true,
                        isFavorite: _favoriteUserIds.contains(userId),
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
                                "Phone": "4788743654478",
                                "Email": member["email"]!,
                                "Location": member["location"]!,
                                "Gender": "Female",
                                "D.O.B": "03-11-2005",
                                "Profession": member["profession"]!,
                                "Nationality": "USA",
                                "Marital Status": "Single",
                              },
                            ),
                          );
                        },
                        onFavoriteTap: () => _onFavoriteIconTap(userId),
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
