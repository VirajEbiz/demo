import 'dart:developer';

import 'package:flutter/cupertino.dart';

// common print function
class MyPrint {
  MyPrint({required String tag, required String value}) {
    //log(tag+"==>"+value);
    debugPrint(tag + "==>" + value);
  }
}
