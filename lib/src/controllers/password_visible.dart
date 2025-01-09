import 'package:get/get.dart';

class PasswordVisibilityController extends GetxController {
  var visibilityMap = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    initializeField('password');
    initializeField('confirmPassword');
  }

  void initializeField(String key) {
    if (!visibilityMap.containsKey(key)) {
      visibilityMap[key] = false;
    }
  }

  void toggleVisibility(String key) {
    if (visibilityMap.containsKey(key)) {
      visibilityMap[key] = !visibilityMap[key]!;
    }
  }

  bool isVisible(String key) {
    return visibilityMap[key] ?? false;
  }
}
