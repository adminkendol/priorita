import 'package:get/get.dart';
import 'package:mario/app/data/providers/get_token_provider.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<GetTokenProvider>(
      () => GetTokenProvider(),
    );
  }
}
