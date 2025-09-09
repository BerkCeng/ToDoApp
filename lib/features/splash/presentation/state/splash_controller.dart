import 'package:get/get.dart';
import 'package:todoapp/core/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.offAllNamed(Routes.todo);
  }
}


