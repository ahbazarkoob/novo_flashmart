import 'package:flutter/material.dart';
import 'package:novo_instamart/features/auth/controllers/auth_controller.dart';
import 'package:novo_instamart/features/auth/screens/sign_up_screen.dart';
import 'package:novo_instamart/features/auth/widgets/condition_check_box_widget.dart';
import 'package:novo_instamart/features/language/controllers/language_controller.dart';
import 'package:novo_instamart/helper/responsive_helper.dart';
import 'package:novo_instamart/helper/route_helper.dart';
import 'package:novo_instamart/util/app_constants.dart';
import 'package:novo_instamart/util/dimensions.dart';
import 'package:novo_instamart/util/images.dart';
import 'package:novo_instamart/util/styles.dart';
import 'package:novo_instamart/common/widgets/custom_button.dart';
import 'package:novo_instamart/common/widgets/menu_drawer.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../../common/widgets/custom_snackbar.dart';
import '../../../helper/auth_helper.dart';
import '../../cart/controllers/cart_controller.dart';

class OTPVerify extends StatefulWidget {
  const OTPVerify({super.key});

  @override
  State<OTPVerify> createState() => _OTPVerifyState();
}

class _OTPVerifyState extends State<OTPVerify> {
  final TextEditingController _otpController = TextEditingController();
  late String phoneNumber;
  @override
  void initState() {
    phoneNumber = Get.find<AuthController>().getUserNumber();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Navigator.canPop(context),
      child: Scaffold(
        backgroundColor: ResponsiveHelper.isDesktop(context)
            ? Colors.transparent
            : Theme.of(context).cardColor,
        appBar: (ResponsiveHelper.isDesktop(context)
            ? null
            : AppBar(
                leading: IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.arrow_back_ios_rounded,
                      color: Theme.of(context).textTheme.bodyLarge!.color),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                actions: const [SizedBox()],
              )),
        endDrawer: const MenuDrawer(),
        endDrawerEnableOpenDragGesture: false,
        body: SafeArea(
            child: Center(
          child: Container(
            height: ResponsiveHelper.isDesktop(context) ? 690 : null,
            width: context.width > 700 ? 500 : context.width,
            padding: context.width > 700
                ? const EdgeInsets.symmetric(horizontal: 0)
                : const EdgeInsets.all(Dimensions.paddingSizeExtremeLarge),
            decoration: context.width > 700
                ? BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    boxShadow: ResponsiveHelper.isDesktop(context)
                        ? null
                        : [
                            BoxShadow(
                                color: Colors.grey[Get.isDarkMode ? 700 : 300]!,
                                blurRadius: 5,
                                spreadRadius: 1)
                          ],
                  )
                : null,
            child: GetBuilder<AuthController>(builder: (authController) {
              return Center(
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      ResponsiveHelper.isDesktop(context)
                          ? Positioned(
                              top: 0,
                              right: 0,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () => Get.back(),
                                  icon: const Icon(Icons.clear),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      Padding(
                        padding: ResponsiveHelper.isDesktop(context)
                            ? const EdgeInsets.all(40)
                            : EdgeInsets.zero,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                Images.logo,
                                width: 125,
                                fit: BoxFit.contain,
                              ),
                              Center(
                                  child: Text(AppConstants.appName,
                                      style: figTreeMedium.copyWith(
                                          fontSize: Dimensions.fontSizeLarge))),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraLarge),
                              Align(
                                alignment:
                                    Get.find<LocalizationController>().isLtr
                                        ? Alignment.topLeft
                                        : Alignment.topRight,
                                child: Text('Enter OTP'.tr,
                                    style: figTreeBold.copyWith(
                                        fontSize:
                                            Dimensions.fontSizeExtraLarge)),
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeDefault),
                              Align(
                                alignment:
                                    Get.find<LocalizationController>().isLtr
                                        ? Alignment.topLeft
                                        : Alignment.topRight,
                                child: Text(phoneNumber.tr,
                                    style: figTreeBold.copyWith(
                                        fontSize:
                                            Dimensions.fontSizeExtraLarge)),
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeDefault),
                              Pinput(
                                length: 6,
                                controller: _otpController,
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeLarge),
                              const Align(
                                alignment: Alignment.center,
                                child: ConditionCheckBoxWidget(
                                    forDeliveryMan: false),
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeDefault),
                              CustomButton(
                                height: ResponsiveHelper.isDesktop(context)
                                    ? 45
                                    : null,
                                width: ResponsiveHelper.isDesktop(context)
                                    ? 180
                                    : null,
                                buttonText: ResponsiveHelper.isDesktop(context)
                                    ? 'login'.tr
                                    : 'sign_in'.tr,
                                onPressed: () => _verifyOtp(authController),
                                // isLoading: authController.isLoading,
                                radius: ResponsiveHelper.isDesktop(context)
                                    ? Dimensions.radiusSmall
                                    : Dimensions.radiusDefault,
                                isBold: !ResponsiveHelper.isDesktop(context),
                                fontSize: ResponsiveHelper.isDesktop(context)
                                    ? Dimensions.fontSizeExtraSmall
                                    : null,
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraLarge),
                              ResponsiveHelper.isDesktop(context)
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                          Text('do_not_have_account'.tr,
                                              style: figTreeRegular.copyWith(
                                                  color: Theme.of(context)
                                                      .hintColor)),
                                          InkWell(
                                            onTap: () {
                                              if (ResponsiveHelper.isDesktop(
                                                  context)) {
                                                Get.back();
                                                Get.dialog(
                                                    const SignUpScreen());
                                              } else {
                                                Get.toNamed(RouteHelper
                                                    .getSignUpRoute());
                                              }
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  Dimensions
                                                      .paddingSizeExtraSmall),
                                              child: Text('sign_up'.tr,
                                                  style: figTreeMedium.copyWith(
                                                      color: Theme.of(context)
                                                          .primaryColor)),
                                            ),
                                          ),
                                        ])
                                  : const SizedBox(),
                            ]),
                      )
                    ],
                  ),
                ),
              );
            }),
          ),
        )),
      ),
    );
  }

  void _verifyOtp(AuthController authController) async {
    String otp = _otpController.text.trim();
    String phone = authController.getUserNumber().toString();
    String countryDialCode = authController.getUserCountryCode().toString();
    debugPrint(countryDialCode);
    String numberWithCountryCode = countryDialCode + phone;
    debugPrint(numberWithCountryCode);
    String recievedOtp = Get.find<AuthController>().recievedOtp;
    debugPrint("recievedOtp = $recievedOtp");
    int generatedOtp = int.parse(recievedOtp);
    debugPrint("otp $otp");
    debugPrint("generated otp $generatedOtp");
    authController.saveUserOtpSharedPref(int.parse(otp));

    if (otp.isEmpty) {
      showCustomSnackBar('enter otp'.tr);
    } else if (int.parse(otp) != generatedOtp) {
      showCustomSnackBar('invalid otp'.tr);
    } else {
      bool loginSuccess = Get.find<AuthController>().loginSuccess;
      debugPrint("$loginSuccess");
      debugPrint('${AuthHelper.isLoggedIn()}');
      if (loginSuccess == true) {
        authController
            .loginRegisteration(numberWithCountryCode, int.parse(otp))
            .then((status) {
          bool loginSuccess = Get.find<AuthController>().loginSuccess;
          if (status.success == true) {
            if (loginSuccess == true) {
              Get.find<CartController>().getCartDataOnline();
              debugPrint('${AuthHelper.isLoggedIn()}');
              Get.toNamed(RouteHelper.getInitialRoute(fromSplash: false));
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('OTP Verified')));
            }
          }
        });
      } else {
        Get.toNamed(RouteHelper.getSignUpRoute());
        // showCustomSnackBar('OTP verify');
      }
      // authController
      //     .loginRegisteration(numberWithCountryCode, int.parse(otp))
      //     .then((status) {
      //   bool loginSuccess = Get.find<AuthController>().loginSuccess;
      //   if (status.success == true) {
      //     if (loginSuccess == true) {
      //       Get.find<CartController>().getCartDataOnline();
      //       debugPrint('***************************${AuthHelper.isLoggedIn()}');
      //       Get.toNamed(RouteHelper.getInitialRoute(fromSplash: false));
      //        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP Verified')));
      //     }
      //   } else {
      //     Get.toNamed(RouteHelper.getSignUpRoute());
      //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP Verified')));
      //   }
      // });
    }
  }
}
