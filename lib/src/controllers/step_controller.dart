import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class StepsController extends GetxController {
  var currentStep = 0.obs;

  void nextStep() {
    if (currentStep.value < 2) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  String getCurrentStepTitle(int step) {
    switch (step) {
      case 0:
        return "DISCOVER EVENTS";
      case 1:
        return "CONNECT WITH MEMBERS";
      case 2:
        return "PROMOTE YOUR EVENTS";
      default:
        return "";
    }
  }

  List<String> getCurrentStepDescription(int step) {
    switch (step) {
      case 0:
        return ["Find gatherings tailored to your", "interests and location."];
      case 1:
        return ["Meet and collaborate with", "people in your community."];
      case 2:
        return ["Create, promote and manage", "your events effortlessly."];
      default:
        return [];
    }
  }

  // Method to return the image for the current step
  String getCurrentStepImage(int step) {
    switch (step) {
      case 0:
        return 'assets/logo/step1.png';
      case 1:
        return 'assets/logo/step2.png';
      case 2:
        return 'assets/logo/step3.png';
      default:
        return 'assets/logo/stepimage.png';
    }
  }
}
