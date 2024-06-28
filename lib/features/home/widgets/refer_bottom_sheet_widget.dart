import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novo_flashMart/common/widgets/custom_asset_image_widget.dart';
import 'package:novo_flashMart/features/profile/controllers/profile_controller.dart';
import 'package:novo_flashMart/helper/responsive_helper.dart';
import 'package:novo_flashMart/util/app_constants.dart';
import 'package:novo_flashMart/util/dimensions.dart';
import 'package:novo_flashMart/util/images.dart';
import 'package:novo_flashMart/util/styles.dart';

class ReferBottomSheetWidget extends StatelessWidget {
  const ReferBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return Container(
      width: isDesktop ? 450 : MediaQuery.of(context).size.width,
      padding:
          EdgeInsets.only(top: isDesktop ? 0 : Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isDesktop
              ? Dimensions.radiusDefault
              : Dimensions.radiusExtraLarge),
          topRight: Radius.circular(isDesktop
              ? Dimensions.radiusDefault
              : Dimensions.radiusExtraLarge),
          bottomLeft: Radius.circular(isDesktop ? Dimensions.radiusDefault : 0),
          bottomRight:
              Radius.circular(isDesktop ? Dimensions.radiusDefault : 0),
        ),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        isDesktop
            ? const SizedBox()
            : Container(
                height: 5,
                width: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
        isDesktop
            ? Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close,
                      color: Theme.of(context).disabledColor.withOpacity(0.4),
                      size: 25),
                ),
              )
            : const SizedBox(),
        Flexible(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeLarge,
                  vertical: Dimensions.paddingSizeDefault),
              child: Column(children: [
                const Padding(
                  padding: EdgeInsets.only(
                      top: Dimensions.paddingSizeExtremeLarge,
                      bottom: Dimensions.paddingSizeExtraLarge),
                  child: CustomAssetImageWidget(
                    Images.referBg,
                    height: 120,
                    width: 190,
                  ),
                ),
                Text('${'welcome_to'.tr} ${AppConstants.appName}!',
                    style: figTreeBold.copyWith(
                        fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Text(
                  '${'get_ready_for_a_special_welcome_gift_enjoy_a_special_discount_on_your_first_order_within'.tr} ${Get.find<ProfileController>().userInfoModel!.validity} ${'start_exploring_the_best_services_around_you'.tr}',
                  textAlign: TextAlign.center,
                  style: figTreeRegular.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color
                          ?.withOpacity(0.5)),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}
