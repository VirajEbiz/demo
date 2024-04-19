import 'package:flutter/material.dart';
import 'package:watermel/app/utils/theme/colors.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/widgets/common_text.dart';

commonDialog(BuildContext context, tittle, message,
    {void Function()? onTap}) async {
  return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          //  backgroundColor:MyColors.yellowColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: MyText(
            txtAlign: TextAlign.center,
            text_name: tittle,
            txtcolor: MyColors.blackColor,
            fontWeight: FontWeight.w500,
            txtfontsize: FontSizes.s20,
          ),
          content: MyText(
            txtAlign: TextAlign.left,
            text_name: message,
            txtcolor: MyColors.blackColor,
            fontWeight: FontWeight.w400,
            txtfontsize: FontSizes.s15,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: MyText(
                txtAlign: TextAlign.center,
                text_name: "No",
                txtcolor: MyColors.grayColor,
                fontWeight: FontWeight.w500,
                txtfontsize: FontSizes.s17,
              ),
            ),
            TextButton(
              onPressed: onTap,
              child: MyText(
                txtAlign: TextAlign.center,
                text_name: "Yes",
                txtcolor: MyColors.greenColor,
                fontWeight: FontWeight.w500,
                txtfontsize: FontSizes.s17,
              ),
            ),
          ],
        ),
      )) ??
      false;
}
