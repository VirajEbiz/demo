import 'package:flutter_easyloading/flutter_easyloading.dart';

class Loader {}

showLoader() {
  EasyLoading.show(status: 'loading...');
}

hideLoader() {
  EasyLoading.dismiss();
}
