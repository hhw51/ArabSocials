import 'dart:io';
import 'package:arab_socials/src/controllers/navigation_controller.dart';
import 'package:arab_socials/src/widgets/custom_header_text.dart';
import 'package:arab_socials/src/widgets/date_time_picker.dart';
import 'package:arab_socials/src/widgets/textfieled_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../apis/create_event.dart'; // Import your createEvent service

class PromoteEvent extends StatefulWidget {
  const PromoteEvent({super.key});

  @override
  State<PromoteEvent> createState() => _PromoteEventState();
}

class _PromoteEventState extends State<PromoteEvent> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  final CreateEventService _createEventService = CreateEventService();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController eventtypeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController ticketController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController starttimeController = TextEditingController();
  final TextEditingController endtimeController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _createEvent() async {
    if (_selectedImage == null) {
      Get.snackbar("Error", "Please upload an image.");
      return;
    }

    try {
      final formattedDate = DateTime.parse(dateController.text).toIso8601String();
      final response = await _createEventService.createEvent(
        title: titleController.text,
        eventType: eventtypeController.text,
        location: locationController.text,
        description: descriptionController.text,
        eventDate: formattedDate.split("T")[0],
        ticketLink: ticketController.text,
        promoCode: codeController.text,
        user: "User", // Replace with actual user value if needed
        startTime: starttimeController.text,
        endTime: endtimeController.text,
        flyer: _selectedImage!,
      );

      Get.snackbar("Success", "Event created successfully.");
      print('Event created: $response');
    } catch (e) {
      Get.snackbar("Error", "Failed to create event.");
      print('Error creating event: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController =
    Get.put(NavigationController());

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 250, 244, 228),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.h),
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
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: const CustomText(
                    text: "REGISTER EVENT",
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 200.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                        image: _selectedImage != null
                            ? DecorationImage(
                          image: FileImage(_selectedImage!),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      child: _selectedImage == null
                          ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: Color.fromARGB(255, 35, 94, 77),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Upload your image",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: titleController,
                        hintText: "Please enter event name",
                        labelText: "Event Name",
                        obscureText: false,
                      ),
                      CustomTextField(
                        controller: descriptionController,
                        hintText: "Your description",
                        labelText: "Description",
                        obscureText: false,
                      ),
                      CustomDropdown(
                        controller: eventtypeController,
                        hintText: "Event type",
                        prefixIcon: Icons.person_2_outlined,
                        items: const [
                          "Online",
                          "Offline"
                        ],
                        onChanged: (value) {
                          print("Selected Event Type: $value");
                        },
                      ),
                      CustomTextField(
                        controller: locationController,
                        hintText: "Please enter your location",
                        labelText: "Your location",
                        obscureText: false,
                      ),
                      CustomTextField(
                        controller: ticketController,
                        hintText: "Please enter Ticket link",
                        labelText: "Ticket link",
                        obscureText: false,
                      ),
                      CustomTextField(
                        controller: codeController,
                        hintText: "Please enter Promo-code",
                        labelText: "Promo code",
                        obscureText: false,
                      ),
                      DatePickerFieldWidget(
                        controller: dateController,
                        hintText: "Your event date",
                      ),
                      SizedBox(height: 10.h),
                      TimePickerFieldWidget(
                        controller: starttimeController,
                        hintText: "Select Start Time",
                      ),
                      SizedBox(height: 10.h),
                      TimePickerFieldWidget(
                        controller: endtimeController,
                        hintText: "Select End Time",
                      ),
                      SizedBox(height: 20.h),
                      ElevatedButton(
                        onPressed: _createEvent,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 35, 94, 77),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          minimumSize: Size(double.infinity, 56.h),
                        ),
                        child: Text(
                          "CREATE",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
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
      ),
    );
  }
}
