import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watermel/app/utils/theme/colors.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/widgets/common_text.dart';

class StoryIconWidget extends StatelessWidget {
  StoryIconWidget(
      {super.key,
      required this.imageUrl,
      required this.userName,
      required this.index});
  String? imageUrl;
  String? userName;
  int? index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: index == 0 ? Insets.i15 : Insets.i5),
      child: Column(
        children: [
          index == 0
              ? Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 64,
                      width: 64,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Insets.i16),
                          color: Colors.white,
                          border: Border.all(
                              width: 4,
                              color: MyColors.whiteColor,
                              strokeAlign: BorderSide.strokeAlignOutside),
                          image: DecorationImage(image: AssetImage(imageUrl!))),
                    ),
                    Positioned(
                      right: -10,
                      bottom: 0,
                      child: SizedBox(
                          height: 26,
                          width: 26,
                          child: Container(
                            alignment: Alignment.center,
                            height: 26,
                            width: 26,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2, color: MyColors.whiteColor),
                                color: MyColors.redColor,
                                shape: BoxShape.circle),
                            child: Icon(
                              Icons.add,
                              size: Insets.i20,
                              color: MyColors.whiteColor,
                            ),
                          )),
                    ),
                  ],
                )
              : Container(
                  alignment: Alignment.center,
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: MyColors.whiteColor,
                    ),
                    gradient: LinearGradient(
                        colors: [MyColors.greenColor, MyColors.redColor],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(Insets.i7),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: Colors.white,
                        border: Border.all(
                            width: 4,
                            color: MyColors.whiteColor,
                            strokeAlign: BorderSide.strokeAlignOutside),
                        image: DecorationImage(image: AssetImage(imageUrl!))),
                  ),
                ),
          const SizedBox(
            height: Insets.i5,
          ),
          MyText(
            text_name: index == 0 ? "Your Story" : userName ?? "",
            fontWeight: FontWeight.w400,
            txtfontsize: FontSizes.s12,
          )
        ],
      ),
    );
  }
}
