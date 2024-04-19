import 'package:get/get.dart';
import 'package:watermel/app/Views/Home%20Feed/controllers/feed_home_controller.dart';

class HomeController extends GetxController {
  RxInt pageIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    HomeFeedController homeFeedController = Get.put(HomeFeedController());
  }
}
