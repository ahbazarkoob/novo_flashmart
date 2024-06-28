import 'package:novo_flashMart/features/order/controllers/order_controller.dart';
import 'package:novo_flashMart/util/dimensions.dart';
import 'package:novo_flashMart/util/styles.dart';
import 'package:novo_flashMart/common/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class ConfirmationDialog extends StatelessWidget {
  final String icon;
  final String? title;
  final String description;
  final Function onYesPressed;
  final bool isLogOut;
  final Function? onNoPressed;
  const ConfirmationDialog(
      {super.key,
      required this.icon,
      this.title,
      required this.description,
      required this.onYesPressed,
      this.isLogOut = false,
      this.onNoPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: PointerInterceptor(
        child: SizedBox(
            width: 500,
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  child: Image.asset(icon,
                      width: 50,
                      height: 50,
                      color: Theme.of(context).primaryColor),
                ),
                title != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeLarge),
                        child: Text(
                          title!,
                          textAlign: TextAlign.center,
                          style: figTreeMedium.copyWith(
                              fontSize: Dimensions.fontSizeExtraLarge,
                              color: Colors.red),
                        ),
                      )
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  child: Text(description,
                      style: figTreeMedium.copyWith(
                          fontSize: Dimensions.fontSizeLarge),
                      textAlign: TextAlign.center),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
                GetBuilder<OrderController>(builder: (orderController) {
                  return !orderController.isLoading
                      ? Row(children: [
                          Expanded(
                              child: TextButton(
                            onPressed: () => isLogOut
                                ? onYesPressed()
                                : onNoPressed != null
                                    ? onNoPressed!()
                                    : Get.back(),
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.3),
                              minimumSize:
                                  const Size(Dimensions.webMaxWidth, 50),
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall)),
                            ),
                            child: Text(
                              isLogOut ? 'yes'.tr : 'no'.tr,
                              textAlign: TextAlign.center,
                              style: figTreeBold.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color),
                            ),
                          )),
                          const SizedBox(width: Dimensions.paddingSizeLarge),
                          Expanded(
                              child: CustomButton(
                            buttonText: isLogOut ? 'no'.tr : 'yes'.tr,
                            onPressed: () =>
                                isLogOut ? Get.back() : onYesPressed(),
                            radius: Dimensions.radiusSmall,
                            height: 50,
                          )),
                        ])
                      : const Center(child: CircularProgressIndicator());
                }),
              ]),
            )),
      ),
    );
  }
}
