import 'package:get/get.dart';

class NavigationController extends GetxController {
  var currentIndex = 0.obs;
  final _navigationStack = <int>[].obs;

  void updateIndex(int index) {
    _navigationStack.add(currentIndex.value);
    currentIndex.value = index;
  }

  void navigateBack() {
    if (_navigationStack.isNotEmpty) {
      currentIndex.value = _navigationStack.removeLast();
    }
  }
}
