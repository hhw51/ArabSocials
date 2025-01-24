import 'package:arabsocials/src/controllers/step_controller.dart';
import 'package:arabsocials/src/view/auth/sign_in/pages/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Add this line

class Stepscreen extends StatelessWidget {
  const Stepscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StepsController controller = Get.put(StepsController());
    final FlutterSecureStorage storage = FlutterSecureStorage(); // Add this line

    Future<void> _markStepsAsShown() async { // Add this method
      await storage.write(key: 'steps_shown', value: 'true');
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 35, 94, 77),
      body: Stack(
        children: [
          // Dynamic Background Image
          Obx(() {
            final step = controller.currentStep.value;
            return Container(
              height: 650.h,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(controller.getCurrentStepImage(step)),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 305.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 35, 94, 77),
                borderRadius: BorderRadius.vertical(top: Radius.circular(36.r)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 30),
                child: Column(
                  children: [
                    // Step-specific content
                    Obx(() {
                      final step = controller.currentStep.value;
                      return Column(
                        children: [
                          // Title
                          Text(
                            controller.getCurrentStepTitle(step),
                            style: GoogleFonts.playfairDisplaySc(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color.fromARGB(255, 254, 235, 196),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          // Descriptions
                          ...controller
                              .getCurrentStepDescription(step)
                              .map((line) => Text(
                                    line,
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ))
                              .toList(),
                        ],
                      );
                    }),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: Obx(() {
                        if (controller.currentStep.value == 2) {
                          // Show "Get Started" button in the last step
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 254, 235, 196),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              minimumSize: Size(double.infinity, 55.h),
                            ),
                            onPressed: () async {
                              await _markStepsAsShown(); // Add this line
                              Get.to(() => const Signinscreen());
                            },
                            child: Text(
                              "GET STARTED",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color.fromARGB(255, 35, 94, 77),
                              ),
                            ),
                          );
                        } else {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Back Button
                              TextButton(
                                onPressed: controller.previousStep,
                                child: Text(
                                  "Back",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: controller.currentStep.value > 0
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                              // Step Indicators
                              Row(
                                children: List.generate(3, (index) {
                                  return Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 5.w),
                                    width: 10.w,
                                    height: 10.h,
                                    decoration: BoxDecoration(
                                      color: index ==
                                              controller.currentStep.value
                                          ? Colors.white
                                          : Colors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                  );
                                }),
                              ),
                              // Next Button
                              TextButton(
                                onPressed: controller.nextStep,
                                child: Text(
                                  "Next",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
