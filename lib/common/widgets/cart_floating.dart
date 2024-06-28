import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novo_flashMart/common/widgets/custom_button.dart';
import 'package:novo_flashMart/common/widgets/custom_snackbar.dart';
import 'package:novo_flashMart/features/store/controllers/store_controller.dart';
import 'package:novo_flashMart/util/dimensions.dart';
import '../../features/cart/controllers/cart_controller.dart';
import '../../features/cart/widgets/not_available_bottom_sheet_widget.dart';
import '../../features/coupon/controllers/coupon_controller.dart';
import '../../features/item/domain/models/item_model.dart';
import '../../features/splash/controllers/splash_controller.dart';
import '../../helper/price_converter.dart';
import '../../helper/responsive_helper.dart';
import '../../helper/route_helper.dart';
import '../../util/images.dart';
import '../../util/styles.dart';

void showCartFloatingWidget(BuildContext context, Item item) {
  double percentage = 0;

  FloatingActionButton(
    onPressed: () {},
    child: GetBuilder<StoreController>(
      builder: (storeController) {
        return GetBuilder<CartController>(builder: (cartController) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ResponsiveHelper.isDesktop(context)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault,
                            vertical: Dimensions.paddingSizeSmall),
                        child: Column(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('item_price'.tr, style: figTreeRegular),
                                PriceConverter.convertAnimationPrice(
                                    cartController.itemPrice,
                                    textStyle: figTreeRegular),
                              ]),
                          SizedBox(
                              height: cartController.variationPrice > 0
                                  ? Dimensions.paddingSizeSmall
                                  : 0),
                          Get.find<SplashController>()
                                      .getModuleConfig(item.moduleType)
                                      .newVariation! &&
                                  cartController.variationPrice > 0
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('variations'.tr,
                                        style: figTreeRegular),
                                    Text(
                                        '(+) ${PriceConverter.convertPrice(cartController.variationPrice)}',
                                        style: figTreeRegular,
                                        textDirection: TextDirection.ltr),
                                  ],
                                )
                              : const SizedBox(),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('discount'.tr, style: figTreeRegular),
                                storeController.store != null
                                    ? Row(children: [
                                        Text('(-)', style: figTreeRegular),
                                        PriceConverter.convertAnimationPrice(
                                            cartController.itemDiscountPrice,
                                            textStyle: figTreeRegular),
                                      ])
                                    : Text('calculating'.tr,
                                        style: figTreeRegular),
                                // Text('(-) ${PriceConverter.convertPrice(cartController.itemDiscountPrice)}', style: figTreeRegular, textDirection: TextDirection.ltr),
                              ]),
                          SizedBox(
                              height: Get.find<SplashController>()
                                      .configModel!
                                      .moduleConfig!
                                      .module!
                                      .addOn!
                                  ? 10
                                  : 0),
                          Get.find<SplashController>()
                                  .configModel!
                                  .moduleConfig!
                                  .module!
                                  .addOn!
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('addons'.tr, style: figTreeRegular),
                                    Text(
                                        '(+) ${PriceConverter.convertPrice(cartController.addOns)}',
                                        style: figTreeRegular,
                                        textDirection: TextDirection.ltr),
                                  ],
                                )
                              : const SizedBox(),
                        ]),
                      )
                    : const SizedBox(),
                (storeController.store != null &&
                        !storeController.store!.freeDelivery! &&
                        Get.find<SplashController>()
                                .configModel!
                                .freeDeliveryOver !=
                            null &&
                        percentage < 1)
                    ? Column(children: [
                        Row(children: [
                          Image.asset(Images.percentTag, height: 20, width: 20),
                          const SizedBox(
                              width: Dimensions.paddingSizeExtraSmall),
                          Text(
                            PriceConverter.convertPrice(
                                Get.find<SplashController>()
                                        .configModel!
                                        .freeDeliveryOver! -
                                    cartController.subTotal),
                            style: figTreeMedium.copyWith(
                                color: Theme.of(context).primaryColor),
                            textDirection: TextDirection.ltr,
                          ),
                          const SizedBox(
                              width: Dimensions.paddingSizeExtraSmall),
                          Text('more_for_free_delivery'.tr,
                              style: figTreeMedium.copyWith(
                                  color: Theme.of(context).disabledColor)),
                        ]),
                        const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall),
                        LinearProgressIndicator(
                          backgroundColor:
                              Theme.of(context).primaryColor.withOpacity(0.2),
                          value: percentage,
                        ),
                      ])
                    : const SizedBox(),
                ResponsiveHelper.isDesktop(context)
                    ? const Divider(height: 1)
                    : const SizedBox(),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: Dimensions.paddingSizeSmall),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('subtotal'.tr,
                          style: figTreeMedium.copyWith(
                              color: ResponsiveHelper.isDesktop(context)
                                  ? Theme.of(context).textTheme.bodyLarge!.color
                                  : Theme.of(context).primaryColor)),
                      PriceConverter.convertAnimationPrice(
                          cartController.subTotal,
                          textStyle: figTreeRegular.copyWith(
                              color: Theme.of(context).primaryColor)),
                      // Text(
                      //   PriceConverter.convertPrice(cartController.subTotal),
                      //   style: figTreeMedium.copyWith(color: ResponsiveHelper.isDesktop(context) ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).primaryColor), textDirection: TextDirection.ltr,
                      // ),
                    ],
                  ),
                ),
                ResponsiveHelper.isDesktop(context) &&
                        Get.find<SplashController>()
                            .getModuleConfig(
                                cartController.cartList[0].item!.moduleType)
                            .newVariation! &&
                        (storeController.store != null &&
                            storeController.store!.cutlery!)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(Images.cutlery,
                                  height: 18, width: 18),
                              const SizedBox(
                                  width: Dimensions.paddingSizeDefault),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('add_cutlery'.tr,
                                          style: figTreeMedium.copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                      const SizedBox(
                                          height:
                                              Dimensions.paddingSizeExtraSmall),
                                      Text('do_not_have_cutlery'.tr,
                                          style: figTreeRegular.copyWith(
                                              color: Theme.of(context)
                                                  .disabledColor,
                                              fontSize:
                                                  Dimensions.fontSizeSmall)),
                                    ]),
                              ),
                              Transform.scale(
                                scale: 0.7,
                                child: CupertinoSwitch(
                                  value: cartController.addCutlery,
                                  activeColor: Theme.of(context).primaryColor,
                                  onChanged: (bool? value) {
                                    cartController.updateCutlery();
                                  },
                                  trackColor: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.5),
                                ),
                              )
                            ]),
                      )
                    : const SizedBox(),
                ResponsiveHelper.isDesktop(context)
                    ? const SizedBox(height: Dimensions.paddingSizeSmall)
                    : const SizedBox(),
                !ResponsiveHelper.isDesktop(context)
                    ? const SizedBox()
                    : Container(
                        width: Dimensions.webMaxWidth,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusSmall),
                            color: Theme.of(context).cardColor,
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 0.5)),
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        //margin: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall) : EdgeInsets.zero,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                if (ResponsiveHelper.isDesktop(context)) {
                                  Get.dialog(const Dialog(
                                      child: NotAvailableBottomSheetWidget()));
                                } else {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (con) =>
                                        const NotAvailableBottomSheetWidget(),
                                  );
                                }
                              },
                              child: Row(children: [
                                Expanded(
                                    child: Text(
                                        'if_any_product_is_not_available'.tr,
                                        style: figTreeMedium,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis)),
                                const Icon(Icons.keyboard_arrow_down, size: 18),
                              ]),
                            ),
                            cartController.notAvailableIndex != -1
                                ? Row(children: [
                                    Text(
                                        cartController
                                            .notAvailableList[cartController
                                                .notAvailableIndex]
                                            .tr,
                                        style: figTreeMedium.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: Theme.of(context)
                                                .primaryColor)),
                                    IconButton(
                                      onPressed: () =>
                                          cartController.setAvailableIndex(-1),
                                      icon: const Icon(Icons.clear, size: 18),
                                    )
                                  ])
                                : const SizedBox(),
                          ],
                        ),
                      ),
                ResponsiveHelper.isDesktop(context)
                    ? const SizedBox(height: Dimensions.paddingSizeSmall)
                    : const SizedBox(),
                CustomButton(
                    buttonText: 'proceed_to_checkout'.tr,
                    fontSize: ResponsiveHelper.isDesktop(context)
                        ? Dimensions.fontSizeSmall
                        : Dimensions.fontSizeLarge,
                    isBold: ResponsiveHelper.isDesktop(context) ? false : true,
                    radius: ResponsiveHelper.isDesktop(context)
                        ? Dimensions.radiusSmall
                        : Dimensions.radiusDefault,
                    onPressed: () {
                      if (!cartController.cartList.first.item!.scheduleOrder! &&
                          cartController.availableList.contains(false)) {
                        showCustomSnackBar(
                            'one_or_more_product_unavailable'.tr);
                      } /*else if(AuthHelper.isGuestLoggedIn() && !Get.find<SplashController>().configModel!.guestCheckoutStatus!) {
                                                  showCustomSnackBar('currently_your_zone_have_no_permission_to_place_any_order'.tr);
                                        }*/
                      else {
                        if (Get.find<SplashController>().module == null) {
                          int i = 0;
                          for (i = 0;
                              i <
                                  Get.find<SplashController>()
                                      .moduleList!
                                      .length;
                              i++) {
                            if (cartController.cartList[0].item!.moduleId ==
                                Get.find<SplashController>()
                                    .moduleList![i]
                                    .id) {
                              break;
                            }
                          }
                          Get.find<SplashController>().setModule(
                              Get.find<SplashController>().moduleList![i]);
                          // HomeScreen.loadData(true);
                        }
                        Get.find<CouponController>().removeCouponData(false);

                        Get.toNamed(RouteHelper.getCheckoutRoute('cart'));
                      }
                    }),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.15,
                )
              ],
            ),
          );
        });
      },
    ),
  );
}
