import 'package:arabsocials/src/controllers/navigation_controller.dart';
import 'package:arabsocials/src/services/auth_services.dart';
import 'package:arabsocials/src/view/auth/sign_in/pages/sign_in_page.dart';
import 'package:arabsocials/src/widgets/abouMe_popup.dart';
import 'package:arabsocials/src/widgets/custom_profiletext.dart';
import 'package:arabsocials/src/widgets/custombuttons.dart';
import 'package:arabsocials/src/widgets/edit_profile_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../apis/visibility_toggle.dart' as visibilityPrefService;

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});
  static final GlobalKey<ProfilescreenState> globalKey = GlobalKey<ProfilescreenState>();

  @override
  State<Profilescreen> createState() => ProfilescreenState();
}

class ProfilescreenState extends State<Profilescreen> with ShowEditProfileDialog {
  final AuthService _authService = AuthService();

  // Secure storage
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // We'll store the token once we fetch it
  String? _authToken;

  // Reactive state variables
  final RxString name = ''.obs;
  final RxString aboutMe = ''.obs;
  final RxString phone = ''.obs;
  final RxString email = ''.obs;
  final RxString location = ''.obs;
  final RxString gender = ''.obs;
  final RxString dob = ''.obs;
  final RxString profession = ''.obs;
  final RxString nationality = ''.obs;
  final RxString maritalStatus = ''.obs;
  final RxList myInterest = RxList();

  final RxBool isLoading = true.obs;

  // Visibility switches
  // "false" means visually show the thumb on the right
  final RxBool aboutMeSwitch = false.obs;
  final RxBool interestsSwitch = false.obs;
  final RxBool locationSwitch = false.obs;
  final RxBool phoneSwitch = false.obs;
  final RxBool emailSwitch = false.obs;
  final RxBool genderSwitch = false.obs;
  final RxBool dobSwitch = false.obs;
  final RxBool professionSwitch = false.obs;
  final RxBool nationalitySwitch = false.obs;
  final RxBool maritalStatusSwitch = false.obs;

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchUserInfo();
  }

  /// Fetch the token from secure storage, then fetch the user info
  Future<void> _loadTokenAndFetchUserInfo() async {
    try {
      final token = await getToken();
      if (token != null) {
        _authToken = token;
        await fetchUserInfo();
      } else {
        // No token found, handle accordingly (maybe redirect to login)
        isLoading.value = false;
      }
    } catch (e) {
      print('Error loading token: $e');
      isLoading.value = false;
    }
  }

  /// Reads the token from secure storage
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  Future<void> fetchUserInfo() async {
    if (_authToken == null) {
      return;
    }

    try {
      isLoading.value = true;
      final userInfo = await _authService.getUserInfo(token: _authToken!);
      print("User Info Fetched: $userInfo");

      // Assign values to reactive variables
      name.value = userInfo['name'] ?? '';
      aboutMe.value = userInfo['about_me'] ?? '';
      phone.value = userInfo['phone'] ?? '';
      email.value = userInfo['email'] ?? '';
      location.value = userInfo['location'] ?? '';
      gender.value = userInfo['gender'] ?? '';
      dob.value = userInfo['dob'] ?? '';
      profession.value = userInfo['profession'] ?? '';
      nationality.value = userInfo['nationality'] ?? '';
      maritalStatus.value = userInfo['marital_status'] ?? '';

      // Process interests field safely
      if (userInfo['interests'] != null && userInfo['interests'] is List) {
        myInterest.assignAll(
          (userInfo['interests'] as List<dynamic>).map((e) => e.toString().trim()).toList(),
        );
      }

      // Assign switch values (assuming backend returns booleans)
      phoneSwitch.value = userInfo['phoneSwitch'] ?? false;
      emailSwitch.value = userInfo['emailSwitch'] ?? false;
      genderSwitch.value = userInfo['genderSwitch'] ?? false;
      dobSwitch.value = userInfo['dobSwitch'] ?? false;
      professionSwitch.value = userInfo['professionSwitch'] ?? false;
      nationalitySwitch.value = userInfo['nationalitySwitch'] ?? false;
      maritalStatusSwitch.value = userInfo['maritalStatusSwitch'] ?? false;

      aboutMeSwitch.value = userInfo['aboutMeSwitch'] ?? false;
      interestsSwitch.value = userInfo['interestsSwitch'] ?? false;
      locationSwitch.value = userInfo['locationSwitch'] ?? false;

    } catch (e) {
      print('Error fetching user info: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile: $e')),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _showParagraphDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AboutMepopUp(
          title: "Edit About Me",
          hintText: "Type something about yourself...",
          initialText: aboutMe.value,
          onSave: (newText) {
            aboutMe.value = newText;
            // Optionally, you can also update the backend here
          },
        );
      },
    );
  }

  /// Function to handle toggle changes and update the API
  Future<void> _handleToggleChange({
    required String fieldName,
    required bool currentValue,
    required RxBool switchController,
  }) async {
    if (_authToken == null) {
      // If no token, revert back
      switchController.value = currentValue;
      return;
    }

    print('--- Toggle Change Detected ---');
    print('Field: $fieldName');
    print('New Value (logic): ${switchController.value}');

    // Prepare the updated visibility preferences
    bool updatedEmail = emailSwitch.value;
    bool updatedPhone = phoneSwitch.value;
    bool updatedGender = genderSwitch.value;
    bool updatedDob = dobSwitch.value;
    bool updatedProfession = professionSwitch.value;
    bool updatedNationality = nationalitySwitch.value;
    bool updatedMaritalStatus = maritalStatusSwitch.value;

    try {
      final response = await visibilityPrefService.updateVisibilityPreferences(
        authToken: _authToken!,
        email: updatedEmail,
        phone: updatedPhone,
        gender: updatedGender,
        dob: updatedDob,
        profession: updatedProfession,
        nationality: updatedNationality,
        maritalStatus: updatedMaritalStatus,
      );

      print('API Response Message: ${response.message}');
      print('Updated Visibility Settings: ${response.visibilitySettings}');
    } catch (e) {
      print('Error updating visibility preferences: $e');
      // Revert the switch state in case of error
      switchController.value = currentValue;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update preferences: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController =
    Get.put(NavigationController());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color.fromARGB(255, 250, 244, 228),
        foregroundColor: const Color.fromARGB(255, 250, 244, 228),
        surfaceTintColor: const Color.fromARGB(255, 250, 244, 228),
        elevation: 0,
        leading: InkWell(
          onTap: () => navigationController.navigateBack(),
          child: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 35, 94, 77), size: 24),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 17.0),
            child: InkWell(
              onTap: () {
                Get.to(const Signinscreen());
              },
              child: const ImageIcon(
                AssetImage("assets/icons/profilelogout.png"),
                size: 23,
                color: Color.fromARGB(255, 35, 94, 77),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CustomContainer(
              text: "Edit Profile",
              image: "assets/icons/editprofile.png",
              onTap: () {
                showPopUp(context,  token: _authToken!).then((value) {
                  if (value != null && value['interests'] != null && value['interests'] is List) {
                    myInterest.assignAll(
                      (value['interests'] as List).map((e) => e.toString().trim()).toList(),
                    );
                  }
                  name.value = value?["name"] ?? '';
                  aboutMe.value = value?["about_me"] ?? '';
                  phone.value = value?["phone"] ?? '';
                  location.value = value?["location"] ?? '';
                  gender.value = value?["gender"] ?? '';
                  dob.value = value?["dob"] ?? '';
                  profession.value = value?["profession"] ?? '';
                  nationality.value = value?["nationality"] ?? '';
                  maritalStatus.value = value?["marital_status"] ?? '';
                });
              },
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Text(
                  "PROFILE",
                  style: GoogleFonts.playfairDisplaySc(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          height: 96.h,
                          width: 96.w,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/logo/profileimage.png"),
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Obx(() => Text(
                          name.value,
                          style: GoogleFonts.playfairDisplaySc(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color.fromARGB(255, 35, 94, 77),
                          ),
                        )),
                        Obx(() => Text(
                          profession.value,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[400],
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 18.h),
                Row(
                  children: [
                    Text(
                      "ABOUT ME",
                      style: GoogleFonts.playfairDisplaySc(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color.fromARGB(255, 35, 94, 77),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: () => _showParagraphDialog(context),
                      child: Icon(Icons.edit, color: const Color.fromARGB(255, 35, 94, 77), size: 24),
                    ),
                    Spacer(),
                    Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        value: !aboutMeSwitch.value,
                        onChanged: (val) {
                          aboutMeSwitch.value = !val;
                        },
                        activeColor: Colors.white,
                        activeTrackColor: const Color.fromARGB(255, 35, 94, 77),
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Obx(() => Text(
                    aboutMe.value,
                    style: TextStyle(fontSize: 14.sp, color: Colors.black),
                  )),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Text(
                      "INTERESTS",
                      style: GoogleFonts.playfairDisplaySc(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color.fromARGB(255, 35, 94, 77),
                      ),
                    ),
                    const Spacer(),
                    Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        value: !interestsSwitch.value,
                        onChanged: (val) {
                          interestsSwitch.value = !val;
                        },
                        activeColor: Colors.grey,
                        activeTrackColor: Colors.grey[300],
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
                Obx(
                      () => SizedBox(
                    height: 25.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: myInterest.length,
                      itemBuilder: (context, index) {
                        return CustomIntrestsContainer(
                          text: Interest.fromApi(value: myInterest[index]).name,
                          color: Interest.fromApi(value: myInterest[index]).color,
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "PERSONAL DETAILS",
                    style: GoogleFonts.playfairDisplaySc(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromARGB(255, 35, 94, 77),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                // Phone Toggle
                Obx(() => CustomData(
                  title: "Phone",
                  subtitle: phone.value,
                  showSwitch: true,
                  switchValue: !phoneSwitch.value,
                  onSwitchChanged: (val) {
                    final oldValue = phoneSwitch.value;
                    phoneSwitch.value = !val;
                    _handleToggleChange(
                      fieldName: 'phone',
                      currentValue: oldValue,
                      switchController: phoneSwitch,
                    );
                  },
                )),
                // Email Toggle
                Obx(() => CustomData(
                  title: "Email",
                  subtitle: email.value,
                  showSwitch: true,
                  switchValue: !emailSwitch.value,
                  onSwitchChanged: (val) {
                    final oldValue = emailSwitch.value;
                    emailSwitch.value = !val;
                    _handleToggleChange(
                      fieldName: 'email',
                      currentValue: oldValue,
                      switchController: emailSwitch,
                    );
                  },
                )),
                // Location Toggle (Assuming no API integration for location)
                Obx(() => CustomData(
                  title: "Location",
                  subtitle: location.value,
                  showSwitch: true,
                  switchValue: !locationSwitch.value,
                  onSwitchChanged: (val) {
                    locationSwitch.value = !val;
                  },
                )),
                // Gender Toggle
                Obx(() => CustomData(
                  title: "Gender",
                  subtitle: gender.value,
                  showSwitch: true,
                  switchValue: !genderSwitch.value,
                  onSwitchChanged: (val) {
                    final oldValue = genderSwitch.value;
                    genderSwitch.value = !val;
                    _handleToggleChange(
                      fieldName: 'gender',
                      currentValue: oldValue,
                      switchController: genderSwitch,
                    );
                  },
                )),
                // DOB Toggle
                Obx(() => CustomData(
                  title: "DOB",
                  subtitle: dob.value,
                  showSwitch: true,
                  switchValue: !dobSwitch.value,
                  onSwitchChanged: (val) {
                    final oldValue = dobSwitch.value;
                    dobSwitch.value = !val;
                    _handleToggleChange(
                      fieldName: 'dob',
                      currentValue: oldValue,
                      switchController: dobSwitch,
                    );
                  },
                )),
                // Profession Toggle
                Obx(() => CustomData(
                  title: "Profession",
                  subtitle: profession.value,
                  showSwitch: true,
                  switchValue: !professionSwitch.value,
                  onSwitchChanged: (val) {
                    final oldValue = professionSwitch.value;
                    professionSwitch.value = !val;
                    _handleToggleChange(
                      fieldName: 'profession',
                      currentValue: oldValue,
                      switchController: professionSwitch,
                    );
                  },
                )),
                // Nationality Toggle
                Obx(() => CustomData(
                  title: "Nationality",
                  subtitle: nationality.value,
                  showSwitch: true,
                  switchValue: !nationalitySwitch.value,
                  onSwitchChanged: (val) {
                    final oldValue = nationalitySwitch.value;
                    nationalitySwitch.value = !val;
                    _handleToggleChange(
                      fieldName: 'nationality',
                      currentValue: oldValue,
                      switchController: nationalitySwitch,
                    );
                  },
                )),
                // Marital Status Toggle
                Obx(() => CustomData(
                  title: "Marital Status",
                  subtitle: maritalStatus.value,
                  showSwitch: true,
                  switchValue: !maritalStatusSwitch.value,
                  onSwitchChanged: (val) {
                    final oldValue = maritalStatusSwitch.value;
                    maritalStatusSwitch.value = !val;
                    _handleToggleChange(
                      fieldName: 'marital_status',
                      currentValue: oldValue,
                      switchController: maritalStatusSwitch,
                    );
                  },
                )),
              ],
            ),
          ),
        );
      }),
    );
  }
}
