import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

// Import your custom widgets and services
import 'package:arabsocials/src/controllers/navigation_controller.dart';
import 'package:arabsocials/src/widgets/custom_header_text.dart';
import 'package:arabsocials/src/widgets/date_time_picker.dart';
import 'package:arabsocials/src/widgets/textfieled_widget.dart';
import '../../apis/create_event.dart'; // Adjust the import path as necessary

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

    // Validate that all required fields are filled
    if (titleController.text.isEmpty ||
        eventtypeController.text.isEmpty ||
        locationController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        ticketController.text.isEmpty ||
        codeController.text.isEmpty ||
        dateController.text.isEmpty ||
        starttimeController.text.isEmpty ||
        endtimeController.text.isEmpty) {
      Get.snackbar("Error", "Please fill in all fields.");
      return;
    }

    try {
      // Parse the event date
      final DateTime parsedDate = DateTime.parse(dateController.text);
      final formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);

      // Extract times from controllers
      final String startTime = starttimeController.text; // e.g., "03 : 24 PM" or "15 : 24"
      final String endTime = endtimeController.text; // e.g., "05 : 30 PM" or "17 : 30"

      // Handle time parsing based on format
      String formattedStartTime;
      String formattedEndTime;

      // Determine if the time is in 24-hour or 12-hour format based on presence of AM/PM
      final bool isStartTime24Hour = !startTime.contains(RegExp(r'[APap][Mm]'));
      final bool isEndTime24Hour = !endTime.contains(RegExp(r'[APap][Mm]'));

      if (isStartTime24Hour && isEndTime24Hour) {
        formattedStartTime = startTime.replaceAll(' ', ''); // Remove spaces: "15:24"
        formattedEndTime = endTime.replaceAll(' ', ''); // Remove spaces: "17:30"
      } else {
        // Parse 12-hour format to 24-hour format
        final parsedStartTime = DateFormat("h : mm a").parse(startTime);
        final parsedEndTime = DateFormat("h : mm a").parse(endTime);

        formattedStartTime = DateFormat("HH:mm").format(parsedStartTime);
        formattedEndTime = DateFormat("HH:mm").format(parsedEndTime);
      }

      // Optionally, validate the time format using regex
      final timeRegex = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$');
      if (!timeRegex.hasMatch(formattedStartTime) || !timeRegex.hasMatch(formattedEndTime)) {
        Get.snackbar("Error", "Invalid time format. Please use HH:mm or h:mm AM/PM.");
        return;
      }

      // Proceed to create the event
      final response = await _createEventService.createEvent(
        title: titleController.text,
        eventType: eventtypeController.text,
        location: locationController.text,
        description: descriptionController.text,
        eventDate: formattedDate,
        ticketLink: ticketController.text,
        promoCode: codeController.text,
        user: "User", // Replace with actual user value if needed
        startTime: formattedStartTime,
        endTime: formattedEndTime,
        flyer: _selectedImage!,
      );

      Get.snackbar("Success", "Event created successfully.");
      print('Event created: $response');
    } catch (e, stackTrace) {
      Get.snackbar("Error", "Failed to create event.");
      print('Error creating event: $e');
      print('Stack Trace: $stackTrace');
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    titleController.dispose();
    eventtypeController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    ticketController.dispose();
    dateController.dispose();
    starttimeController.dispose();
    endtimeController.dispose();
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController =
    Get.put(NavigationController());

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 250, 244, 228),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
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
            // Header Text
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
            // Image Upload Section
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
            // Expanded Scrollable Form
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Event Name
                      CustomTextField(
                        controller: titleController,
                        hintText: "Please enter event name",
                        labelText: "Event Name",
                        obscureText: false,
                      ),
                      SizedBox(height: 12.h),
                      // Description
                      CustomTextField(
                        controller: descriptionController,
                        hintText: "Your description",
                        labelText: "Description",
                        obscureText: false,
                      ),
                      SizedBox(height: 12.h),
                      // Event Type Dropdown
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
                      SizedBox(height: 12.h),
                      // Location
                      CustomTextField(
                        controller: locationController,
                        hintText: "Please enter your location",
                        labelText: "Your location",
                        obscureText: false,
                      ),
                      SizedBox(height: 12.h),
                      // Ticket Link
                      CustomTextField(
                        controller: ticketController,
                        hintText: "Please enter Ticket link",
                        labelText: "Ticket link",
                        obscureText: false,
                      ),
                      SizedBox(height: 12.h),
                      // Promo Code
                      CustomTextField(
                        controller: codeController,
                        hintText: "Please enter Promo-code",
                        labelText: "Promo code",
                        obscureText: false,
                      ),
                      SizedBox(height: 12.h),
                      // Event Date Picker
                      DatePickerFieldWidget(
                        controller: dateController,
                        hintText: "Your event date",
                      ),
                      SizedBox(height: 12.h),
                      // Start Time Picker
                      TimePickerFieldWidget(
                        controller: starttimeController,
                        hintText: "Select Start Time",
                      ),
                      SizedBox(height: 12.h),
                      // End Time Picker
                      TimePickerFieldWidget(
                        controller: endtimeController,
                        hintText: "Select End Time",
                      ),
                      SizedBox(height: 20.h),
                      // Additional spacing to ensure content is above the Create button
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        // Fixed "Create" Button at the Bottom
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: ElevatedButton(
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
        ),
      ),
    );
  }
}