import 'dart:async';
import 'dart:io';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/services.dart';
import 'package:novo_instamart/features/location/controllers/location_controller.dart';
import 'package:novo_instamart/features/splash/controllers/splash_controller.dart';
import 'package:novo_instamart/features/order/controllers/order_controller.dart';
import 'package:novo_instamart/features/order/domain/models/order_model.dart';
import 'package:novo_instamart/features/address/screens/address_screen.dart';
import 'package:novo_instamart/features/auth/controllers/auth_controller.dart';
import 'package:novo_instamart/features/dashboard/widgets/bottom_nav_item_widget.dart';
import 'package:novo_instamart/helper/auth_helper.dart';
import 'package:novo_instamart/helper/responsive_helper.dart';
import 'package:novo_instamart/util/dimensions.dart';
import 'package:novo_instamart/util/images.dart';
import 'package:novo_instamart/common/widgets/custom_dialog.dart';
import 'package:novo_instamart/common/widgets/custom_snackbar.dart';
import 'package:novo_instamart/features/checkout/widgets/congratulation_dialogue.dart';
import 'package:novo_instamart/features/dashboard/widgets/address_bottom_sheet_widget.dart';
import 'package:novo_instamart/features/favourite/screens/favourite_screen.dart';
import 'package:novo_instamart/features/home/screens/home_screen.dart';
import 'package:novo_instamart/features/menu/screens/menu_screen.dart';
import 'package:novo_instamart/features/order/screens/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/custom_button.dart';
import '../../../helper/price_converter.dart';
import '../../../helper/route_helper.dart';
import '../../../util/styles.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../coupon/controllers/coupon_controller.dart';
import '../../store/controllers/store_controller.dart';
import '../widgets/running_order_view_widget.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  final bool fromSplash;
  const DashboardScreen(
      {super.key, required this.pageIndex, this.fromSplash = false});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  PageController? _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  bool _canExit = GetPlatform.isWeb ? true : false;

  GlobalKey<ExpandableBottomSheetState> key = GlobalKey();

  late bool _isLogin;
  bool active = false;

  @override
  void initState() {
    super.initState();

    _isLogin = AuthHelper.isLoggedIn();

    if (_isLogin) {
      if (Get.find<SplashController>().configModel!.loyaltyPointStatus == 1 &&
          Get.find<AuthController>().getEarningPint().isNotEmpty &&
          !ResponsiveHelper.isDesktop(Get.context)) {
        Future.delayed(const Duration(seconds: 1),
            () => showAnimatedDialog(context, const CongratulationDialogue()));
      }
      suggestAddressBottomSheet();
      Get.find<OrderController>().getRunningOrders(1);
    }

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      const HomeScreen(),
      const FavouriteScreen(),
      const SizedBox(),
      const OrderScreen(),
      const MenuScreen()
    ];

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });
  }

  Future<void> suggestAddressBottomSheet() async {
    active = await Get.find<LocationController>().checkLocationActive();
    if (widget.fromSplash &&
        Get.find<LocationController>().showLocationSuggestion &&
        active) {
      Future.delayed(const Duration(seconds: 1), () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (con) => const AddressBottomSheetWidget(),
        ).then((value) {
          Get.find<LocationController>().hideSuggestedLocation();
          setState(() {});
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    bool keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return GetBuilder<SplashController>(builder: (splashController) {
      return PopScope(
        canPop: Navigator.canPop(context),
        onPopInvokedWithResult: (value, res) async {
          if (_pageIndex != 0) {
            _setPage(0);
          } else {
            if (splashController.isRefreshing) {
              showCustomSnackBar('please_wait_until_refresh_complete'.tr,
                  isError: true);
            }
            if (!ResponsiveHelper.isDesktop(context) &&
                Get.find<SplashController>().module != null &&
                Get.find<SplashController>().configModel!.module == null) {
              Get.find<SplashController>().setModule(null);
            } else {
              if (_canExit) {
                if (GetPlatform.isAndroid) {
                  SystemNavigator.pop();
                } else if (GetPlatform.isIOS) {
                  exit(0);
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('back_press_again_to_exit'.tr,
                      style: const TextStyle(color: Colors.white)),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                  margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                ));
                _canExit = true;
                Timer(const Duration(seconds: 2), () {
                  _canExit = false;
                });
              }
            }
          }
        },
        child: GetBuilder<OrderController>(builder: (orderController) {
          List<OrderModel> runningOrder =
              orderController.runningOrderModel != null
                  ? orderController.runningOrderModel!.orders!
                  : [];

          List<OrderModel> reversOrder = List.from(runningOrder.reversed);

          return Scaffold(
            key: _scaffoldKey,
            body: ExpandableBottomSheet(
              background: Stack(children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: _screens.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _screens[index];
                  },
                ),
                ResponsiveHelper.isDesktop(context) || keyboardVisible
                    ? const SizedBox()
                    : Column(
                        children: [
                          const Expanded(child: SizedBox()),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(Dimensions.radiusLarge)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 5)
                              ],
                            ),
                            width: size.width,
                            child: GetBuilder<StoreController>(
                              builder: (storeController) {
                                double percentage = 0;
                                double freeDeliveryOver =
                                    Get.find<SplashController>()
                                            .configModel
                                            ?.freeDeliveryOver ??
                                        0;
                                return GetBuilder<CartController>(
                                    builder: (cartController) {
                                  percentage = cartController.subTotal /
                                      // Get.find<SplashController>()
                                      //     .configModel!
                                      //     .freeDeliveryOver!;
                                      freeDeliveryOver;
                                  return (cartController.subTotal > 0)
                                      ? Column(children: [
                                          (
                                                  // Get.find<SplashController>()
                                                  //               .configModel!
                                                  //               .freeDeliveryOver!
                                                  freeDeliveryOver -
                                                          cartController
                                                              .subTotal >
                                                      1)
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 10,
                                                      horizontal: Dimensions
                                                          .paddingSizeExtraOverLarge),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width:
                                                            size.width * 0.08,
                                                      ),
                                                      Stack(children: [
                                                        SizedBox(
                                                          height: 30,
                                                          width: 30,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Image.asset(
                                                                Images
                                                                    .percentTag,
                                                                height: 20,
                                                                width: 20),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                          width: 30,
                                                          child:
                                                              CircularProgressIndicator(
                                                            strokeWidth: 5,
                                                            value: percentage,
                                                            backgroundColor:
                                                                Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                        0.2),
                                                          ),
                                                        ),
                                                      ]),
                                                      const SizedBox(
                                                          width: Dimensions
                                                              .paddingSizeDefault),
                                                      const Text(
                                                          'Add items worth '),
                                                      Text(
                                                        PriceConverter.convertPrice(
                                                            Get.find<SplashController>()
                                                                    .configModel!
                                                                    .freeDeliveryOver! -
                                                                cartController
                                                                    .subTotal),
                                                        style: figTreeMedium
                                                            .copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor),
                                                        textDirection:
                                                            TextDirection.ltr,
                                                      ),
                                                      const SizedBox(
                                                          width: Dimensions
                                                              .paddingSizeExtraSmall),
                                                      Text(
                                                          'more_for_free_delivery'
                                                              .tr,
                                                          style: figTreeMedium.copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .disabledColor)),
                                                    ],
                                                  ),
                                                )
                                              : const SizedBox(
                                                  height: 10,
                                                ),
                                          //  Padding(
                                          //    padding:  const EdgeInsets.symmetric(vertical: 5, horizontal: Dimensions.paddingSizeDefault),
                                          //    child: Divider(
                                          //      color: Theme.of(context).dividerColor,
                                          //      height: 4,
                                          //    ),
                                          //  ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Row(
                                                children: [
                                                  const Text('Order Total : '),
                                                  PriceConverter.convertAnimationPrice(
                                                      cartController.subTotal,
                                                      textStyle: figTreeRegular
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor))
                                                ],
                                              ),
                                              SizedBox(
                                                width: size.width * 0.5,
                                                child: CustomButton(
                                                    buttonText: 'Go to cart'.tr,
                                                    fontSize: ResponsiveHelper
                                                            .isDesktop(context)
                                                        ? Dimensions
                                                            .fontSizeSmall
                                                        : Dimensions
                                                            .fontSizeLarge,
                                                    isBold: ResponsiveHelper
                                                            .isDesktop(context)
                                                        ? false
                                                        : true,
                                                    radius: ResponsiveHelper
                                                            .isDesktop(context)
                                                        ? Dimensions.radiusSmall
                                                        : Dimensions
                                                            .radiusDefault,
                                                    onPressed: () {
                                                      if (!cartController
                                                              .cartList
                                                              .first
                                                              .item!
                                                              .scheduleOrder! &&
                                                          cartController
                                                              .availableList
                                                              .contains(
                                                                  false)) {
                                                        showCustomSnackBar(
                                                            'one_or_more_product_unavailable'
                                                                .tr);
                                                      } /*else if(AuthHelper.isGuestLoggedIn() && !Get.find<SplashController>().configModel!.guestCheckoutStatus!) {
                                                                      showCustomSnackBar('currently_your_zone_have_no_permission_to_place_any_order'.tr);
                                                             }*/
                                                      else {
                                                        if (Get.find<
                                                                    SplashController>()
                                                                .module ==
                                                            null) {
                                                          int i = 0;
                                                          for (i = 0;
                                                              i <
                                                                  Get.find<
                                                                          SplashController>()
                                                                      .moduleList!
                                                                      .length;
                                                              i++) {
                                                            if (cartController
                                                                    .cartList[0]
                                                                    .item!
                                                                    .moduleId ==
                                                                Get.find<
                                                                        SplashController>()
                                                                    .moduleList![
                                                                        i]
                                                                    .id) {
                                                              break;
                                                            }
                                                          }
                                                          Get.find<
                                                                  SplashController>()
                                                              .setModule(Get.find<
                                                                      SplashController>()
                                                                  .moduleList![i]);
                                                          HomeScreen.loadData(
                                                              true);
                                                        }
                                                        Get.find<
                                                                CouponController>()
                                                            .removeCouponData(
                                                                false);

                                                        Get.toNamed(RouteHelper
                                                            .getCartRoute());
                                                      }
                                                    }),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          )
                                        ])
                                      : const SizedBox();
                                });
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: GetBuilder<SplashController>(
                                builder: (splashController) {
                              bool isParcel = splashController.module != null &&
                                  splashController.configModel!.moduleConfig!
                                      .module!.isParcel!;

                              _screens = [
                                const HomeScreen(),
                                isParcel
                                    ? const AddressScreen(fromDashboard: true)
                                    : const FavouriteScreen(),
                                const SizedBox(),
                                const OrderScreen(),
                                const MenuScreen()
                              ];
                              return Container(
                                width: size.width,
                                height: GetPlatform.isIOS ? 80 : 65,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(
                                          Dimensions.radiusLarge)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 5)
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    // Cart IConRemoved from Bottom Nav Bar
                                    // Center(
                                    //   heightFactor: 0.6,
                                    //   child: ResponsiveHelper.isDesktop(context)
                                    //       ? null
                                    //       : (widget.fromSplash &&
                                    //               Get.find<LocationController>()
                                    //                   .showLocationSuggestion &&
                                    //               active)
                                    //           ? null
                                    //           : (orderController.showBottomSheet &&
                                    //                   orderController
                                    //                           .runningOrderModel !=
                                    //                       null &&
                                    //                   orderController
                                    //                       .runningOrderModel!
                                    //                       .orders!
                                    //                       .isNotEmpty &&
                                    //                   _isLogin)
                                    //               ? const SizedBox()
                                    //               : Container(
                                    //                   width: 60,
                                    //                   height: 60,
                                    //                   decoration: BoxDecoration(
                                    //                       border: Border.all(
                                    //                           color:
                                    //                               Theme.of(context)
                                    //                                   .cardColor,
                                    //                           width: 5),
                                    //                       borderRadius:
                                    //                           BorderRadius.circular(
                                    //                               30),
                                    //                       boxShadow: [
                                    //                         BoxShadow(
                                    //                             color: Colors.black
                                    //                                 .withOpacity(
                                    //                                     0.1),
                                    //                             blurRadius: 2,
                                    //                             offset:
                                    //                                 const Offset(
                                    //                                     0, -2),
                                    //                             spreadRadius: 0)
                                    //                       ]),
                                    //                   child:
                                    //                   FloatingActionButton(
                                    //                     backgroundColor:
                                    //                         Theme.of(context)
                                    //                             .primaryColor,
                                    //                     onPressed: () {
                                    //                       if (isParcel) {
                                    //                         showModalBottomSheet(
                                    //                           context: context,
                                    //                           isScrollControlled:
                                    //                               true,
                                    //                           backgroundColor:
                                    //                               Colors
                                    //                                   .transparent,
                                    //                           builder: (con) =>
                                    //                               ParcelBottomSheetWidget(
                                    //                                   parcelCategoryList:
                                    //                                       Get.find<
                                    //                                               ParcelController>()
                                    //                                           .parcelCategoryList),
                                    //                         );
                                    //                       } else {
                                    //                         Get.toNamed(RouteHelper
                                    //                             .getCartRoute());
                                    //                       }
                                    //                     },
                                    //                     elevation: 0,
                                    //                     child: isParcel
                                    //                         ? Icon(
                                    //                             CupertinoIcons.add,
                                    //                             size: 34,
                                    //                             color: Theme.of(
                                    //                                     context)
                                    //                                 .cardColor)
                                    //                         : CartWidget(
                                    //                             color: Theme.of(
                                    //                                     context)
                                    //                                 .cardColor,
                                    //                             size: 22),
                                    //                   ),

                                    //                 ),

                                    // ),

                                    ResponsiveHelper.isDesktop(context)
                                        ? const SizedBox()
                                        : (widget.fromSplash &&
                                                Get.find<LocationController>()
                                                    .showLocationSuggestion &&
                                                active)
                                            ? const SizedBox()
                                            : (orderController
                                                        .showBottomSheet &&
                                                    orderController
                                                            .runningOrderModel !=
                                                        null &&
                                                    orderController
                                                        .runningOrderModel!
                                                        .orders!
                                                        .isNotEmpty &&
                                                    _isLogin)
                                                ? const SizedBox()
                                                : Center(
                                                    child: SizedBox(
                                                      width: size.width,
                                                      height: 80,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            BottomNavItemWidget(
                                                              title: 'home'.tr,
                                                              selectedIcon: Images
                                                                  .homeSelect,
                                                              unSelectedIcon: Images
                                                                  .homeUnselect,
                                                              isSelected:
                                                                  _pageIndex ==
                                                                      0,
                                                              onTap: () =>
                                                                  _setPage(0),
                                                            ),
                                                            // BottomNavItemWidget(
                                                            //   title: isParcel
                                                            //       ? 'address'.tr
                                                            //       : 'favourite'
                                                            //           .tr,
                                                            //   selectedIcon: isParcel
                                                            //       ? Images
                                                            //           .addressSelect
                                                            //       : Images
                                                            //           .favouriteSelect,
                                                            //   unSelectedIcon: isParcel
                                                            //       ? Images
                                                            //           .addressUnselect
                                                            //       : Images
                                                            //           .favouriteUnselect,
                                                            //   isSelected:
                                                            //       _pageIndex ==
                                                            //           1,
                                                            //   onTap: () =>
                                                            //       _setPage(1),
                                                            // ),

                                                            // Container(
                                                            //     width: size.width *
                                                            //         0.2),
                                                            BottomNavItemWidget(
                                                              title:
                                                                  'orders'.tr,
                                                              selectedIcon: Images
                                                                  .orderSelect,
                                                              unSelectedIcon: Images
                                                                  .orderUnselect,
                                                              isSelected:
                                                                  _pageIndex ==
                                                                      3,
                                                              onTap: () =>
                                                                  _setPage(3),
                                                            ),
                                                            BottomNavItemWidget(
                                                              title: 'menu'.tr,
                                                              selectedIcon:
                                                                  Images.menu,
                                                              unSelectedIcon:
                                                                  Images.menu,
                                                              isSelected:
                                                                  _pageIndex ==
                                                                      4,
                                                              onTap: () =>
                                                                  _setPage(4),
                                                            ),
                                                          ]),
                                                    ),
                                                  ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
              ]),
              persistentContentHeight: (widget.fromSplash &&
                      Get.find<LocationController>().showLocationSuggestion &&
                      active)
                  ? 0
                  : 100,
              onIsContractedCallback: () {
                if (!orderController.showOneOrder) {
                  orderController.showOrders();
                }
              },
              onIsExtendedCallback: () {
                if (orderController.showOneOrder) {
                  orderController.showOrders();
                }
              },
              enableToggle: true,
              expandableContent: (widget.fromSplash &&
                      Get.find<LocationController>().showLocationSuggestion &&
                      active &&
                      !ResponsiveHelper.isDesktop(context))
                  ? const SizedBox()
                  : (ResponsiveHelper.isDesktop(context) ||
                          !_isLogin ||
                          orderController.runningOrderModel == null ||
                          orderController.runningOrderModel!.orders!.isEmpty ||
                          !orderController.showBottomSheet)
                      ? const SizedBox()
                      : Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) {
                            if (orderController.showBottomSheet) {
                              orderController.showRunningOrders();
                            }
                          },
                          child: RunningOrderViewWidget(
                              reversOrder: reversOrder,
                              onOrderTap: () {
                                _setPage(3);
                                if (orderController.showBottomSheet) {
                                  orderController.showRunningOrders();
                                }
                              }),
                        ),
            ),
          );
        }),
      );
    });
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }

  Widget trackView(BuildContext context, {required bool status}) {
    return Container(
        height: 3,
        decoration: BoxDecoration(
            color: status
                ? Theme.of(context).primaryColor
                : Theme.of(context).disabledColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault)));
  }
}
