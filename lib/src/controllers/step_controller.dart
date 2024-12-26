import 'package:get/get.dart';

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
        return ["Find gathering tailored to your", "interests and location."];
      case 1:
        return ["Meet and collaborate with", "people in your community."];
      case 2:
        return ["Create, promote and manage", "your events effortlessly."];
      default:
        return [];
    }
  }
}
