import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novo_flashMart/helper/responsive_helper.dart';
import 'package:novo_flashMart/helper/route_helper.dart';
import 'package:novo_flashMart/util/dimensions.dart';
import 'package:novo_flashMart/util/styles.dart';

void showCartSnackBar() {
  ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
    dismissDirection: DismissDirection.horizontal,
    margin: EdgeInsets.only(
      right: ResponsiveHelper.isDesktop(Get.context)
          ? Get.context!.width * 0.7
          : Dimensions.paddingSizeSmall,
      top: Dimensions.paddingSizeSmall,
      bottom: Dimensions.paddingSizeSmall,
      left: Dimensions.paddingSizeSmall,
    ),
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.green,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
    content: Text('item_added_to_cart'.tr,
        style: figTreeMedium.copyWith(color: Colors.white)),
    action: SnackBarAction(
        label: 'view_cart'.tr,
        onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
        textColor: Colors.white),
  ));
}
