import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:novo_instamart/features/coupon/controllers/coupon_controller.dart';
import 'package:novo_instamart/features/language/controllers/language_controller.dart';
import 'package:novo_instamart/features/splash/controllers/splash_controller.dart';
import 'package:novo_instamart/helper/auth_helper.dart';
import 'package:novo_instamart/helper/price_converter.dart';
import 'package:novo_instamart/helper/responsive_helper.dart';
import 'package:novo_instamart/util/dimensions.dart';
import 'package:novo_instamart/util/images.dart';
import 'package:novo_instamart/util/styles.dart';
import 'package:novo_instamart/common/widgets/custom_app_bar.dart';
import 'package:novo_instamart/common/widgets/custom_snackbar.dart';
import 'package:novo_instamart/common/widgets/footer_view.dart';
import 'package:novo_instamart/common/widgets/menu_drawer.dart';
import 'package:novo_instamart/common/widgets/no_data_screen.dart';
import 'package:novo_instamart/common/widgets/not_logged_in_screen.dart';

class TaxiCouponScreen extends StatefulWidget {
  const TaxiCouponScreen({super.key});

  @override
  State<TaxiCouponScreen> createState() => _TaxiCouponScreenState();
}

class _TaxiCouponScreenState extends State<TaxiCouponScreen> {
  bool _isLoggedIn = AuthHelper.isLoggedIn();

  @override
  void initState() {
    super.initState();

    initCall();
  }

  initCall() {
    if (_isLoggedIn) {
      Get.find<CouponController>().getTaxiCouponList();
    }
  }

  @override
  Widget build(BuildContext context) {
    _isLoggedIn = AuthHelper.isLoggedIn();
    return Scaffold(
      appBar: CustomAppBar(title: 'taxi_coupon'.tr),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: _isLoggedIn
          ? GetBuilder<CouponController>(builder: (couponController) {
              return couponController.taxiCouponList != null
                  ? couponController.taxiCouponList!.isNotEmpty
                      ? RefreshIndicator(
                          onRefresh: () async {
                            await couponController.getTaxiCouponList();
                          },
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Center(
                                child: FooterView(
                              child: SizedBox(
                                  width: Dimensions.webMaxWidth,
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          ResponsiveHelper.isDesktop(context)
                                              ? 3
                                              : ResponsiveHelper.isTab(context)
                                                  ? 2
                                                  : 1,
                                      mainAxisSpacing:
                                          Dimensions.paddingSizeSmall,
                                      crossAxisSpacing:
                                          Dimensions.paddingSizeSmall,
                                      childAspectRatio:
                                          ResponsiveHelper.isMobile(context)
                                              ? 2.6
                                              : 2.4,
                                    ),
                                    itemCount:
                                        couponController.taxiCouponList!.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.all(
                                        Dimensions.paddingSizeLarge),
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(
                                              text: couponController
                                                  .taxiCouponList![index]
                                                  .code!));
                                          showCustomSnackBar(
                                              'coupon_code_copied'.tr,
                                              isError: false);
                                        },
                                        child: Stack(children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.radiusSmall),
                                            child: Transform.rotate(
                                              angle: Get.find<
                                                          LocalizationController>()
                                                      .isLtr
                                                  ? 0
                                                  : pi,
                                              child: Image.asset(
                                                Images.couponBgLight,
                                                height: ResponsiveHelper
                                                        .isMobilePhone()
                                                    ? 130
                                                    : 140,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height:
                                                ResponsiveHelper.isMobilePhone()
                                                    ? 125
                                                    : 140,
                                            alignment: Alignment.center,
                                            child: Row(children: [
                                              const SizedBox(width: 30),
                                              Image.asset(Images.coupon,
                                                  height: 50,
                                                  width: 50,
                                                  color: Theme.of(context)
                                                      .cardColor),
                                              const SizedBox(width: 40),
                                              Expanded(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        '${couponController.taxiCouponList![index].code} (${couponController.taxiCouponList![index].title})',
                                                        style: figTreeRegular
                                                            .copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .cardColor),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      const SizedBox(
                                                          height: Dimensions
                                                              .paddingSizeExtraSmall),
                                                      Text(
                                                        '${couponController.taxiCouponList![index].discount}${couponController.taxiCouponList![index].discountType == 'percent' ? '%' : Get.find<SplashController>().configModel!.currencySymbol} off',
                                                        style: figTreeMedium
                                                            .copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .cardColor),
                                                      ),
                                                      const SizedBox(
                                                          height: Dimensions
                                                              .paddingSizeExtraSmall),
                                                      Row(children: [
                                                        Text(
                                                          '${'valid_until'.tr}:',
                                                          style: figTreeRegular.copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .cardColor,
                                                              fontSize: Dimensions
                                                                  .fontSizeSmall),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        const SizedBox(
                                                            width: Dimensions
                                                                .paddingSizeExtraSmall),
                                                        Text(
                                                          couponController
                                                              .taxiCouponList![
                                                                  index]
                                                              .expireDate!,
                                                          style: figTreeMedium.copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .cardColor,
                                                              fontSize: Dimensions
                                                                  .fontSizeSmall),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ]),
                                                      Row(children: [
                                                        Text(
                                                          '${'type'.tr}:',
                                                          style: figTreeRegular.copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .cardColor,
                                                              fontSize: Dimensions
                                                                  .fontSizeSmall),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        const SizedBox(
                                                            width: Dimensions
                                                                .paddingSizeExtraSmall),
                                                        Flexible(
                                                            child: Text(
                                                          '${couponController.taxiCouponList![index].couponType!.tr}${couponController.taxiCouponList![index].couponType == 'store_wise' ? ' (${couponController.taxiCouponList![index].data})' : ''}',
                                                          style: figTreeMedium.copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .cardColor,
                                                              fontSize: Dimensions
                                                                  .fontSizeSmall),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        )),
                                                      ]),
                                                      Row(children: [
                                                        Text(
                                                          '${'min_purchase'.tr}:',
                                                          style: figTreeRegular.copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .cardColor,
                                                              fontSize: Dimensions
                                                                  .fontSizeSmall),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        const SizedBox(
                                                            width: Dimensions
                                                                .paddingSizeExtraSmall),
                                                        Text(
                                                          PriceConverter.convertPrice(
                                                              couponController
                                                                  .taxiCouponList![
                                                                      index]
                                                                  .minPurchase),
                                                          style: figTreeMedium.copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .cardColor,
                                                              fontSize: Dimensions
                                                                  .fontSizeSmall),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ]),
                                                      Row(children: [
                                                        Text(
                                                          '${'max_discount'.tr}:',
                                                          style: figTreeRegular.copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .cardColor,
                                                              fontSize: Dimensions
                                                                  .fontSizeSmall),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        const SizedBox(
                                                            width: Dimensions
                                                                .paddingSizeExtraSmall),
                                                        Text(
                                                          PriceConverter.convertPrice(
                                                              couponController
                                                                  .taxiCouponList![
                                                                      index]
                                                                  .maxDiscount),
                                                          style: figTreeMedium.copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .cardColor,
                                                              fontSize: Dimensions
                                                                  .fontSizeSmall),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ]),
                                                    ]),
                                              ),
                                            ]),
                                          ),
                                        ]),
                                      );
                                    },
                                  )),
                            )),
                          ),
                        )
                      : NoDataScreen(
                          text: 'no_coupon_found'.tr, showFooter: true)
                  : const Center(child: CircularProgressIndicator());
            })
          : NotLoggedInScreen(callBack: (value) {
              initCall();
              setState(() {});
            }),
    );
  }
}
