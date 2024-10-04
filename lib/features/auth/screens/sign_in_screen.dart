import 'dart:async';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:novo_flashMart/features/language/controllers/language_controller.dart';
import 'package:novo_flashMart/features/auth/controllers/auth_controller.dart';
import 'package:novo_flashMart/features/auth/screens/sign_up_screen.dart';
import 'package:novo_flashMart/features/auth/widgets/condition_check_box_widget.dart';
import 'package:novo_flashMart/helper/custom_validator.dart';
import 'package:novo_flashMart/helper/responsive_helper.dart';
import 'package:novo_flashMart/helper/route_helper.dart';
import 'package:novo_flashMart/util/app_constants.dart';
import 'package:novo_flashMart/util/dimensions.dart';
import 'package:novo_flashMart/util/images.dart';
import 'package:novo_flashMart/util/styles.dart';
import 'package:novo_flashMart/common/widgets/custom_button.dart';
import 'package:novo_flashMart/common/widgets/custom_snackbar.dart';
import 'package:novo_flashMart/common/widgets/custom_text_field.dart';
import 'package:novo_flashMart/common/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../splash/controllers/splash_controller.dart';

class SignInScreen extends StatefulWidget {
  final bool exitFromApp;
  final bool backFromThis;
  const SignInScreen(
      {super.key, required this.exitFromApp, required this.backFromThis});

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _countryDialCode;
  bool _canExit = GetPlatform.isWeb ? true : false;

  @override
  void initState() {
    super.initState();

    _countryDialCode =
        Get.find<AuthController>().getUserCountryCode().isNotEmpty
            ? Get.find<AuthController>().getUserCountryCode()
            : CountryCode.fromCountryCode(
                    Get.find<SplashController>().configModel!.country!)
                .dialCode;
    _phoneController.text = Get.find<AuthController>().getUserNumber();
    _passwordController.text = Get.find<AuthController>().getUserPassword();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvokedWithResult: (value, res) async {
        if (widget.exitFromApp) {
          if (_canExit) {
            if (GetPlatform.isAndroid) {
              SystemNavigator.pop();
            } else if (GetPlatform.isIOS) {
              exit(0);
            } else {
              Navigator.pushNamed(context, RouteHelper.getInitialRoute());
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
        } else {
          return;
        }
      },
      child: Scaffold(
        backgroundColor: ResponsiveHelper.isDesktop(context)
            ? Colors.transparent
            : Theme.of(context).cardColor,
        appBar: (ResponsiveHelper.isDesktop(context)
            ? null
            : !widget.exitFromApp
                ? AppBar(
                    leading: IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.arrow_back_ios_rounded,
                          color: Theme.of(context).textTheme.bodyLarge!.color),
                    ),
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    actions: const [SizedBox()],
                  )
                : null),
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
                                child: Text('enter_phone_number'.tr,
                                    // 'sign_in'.tr,
                                    style: figTreeBold.copyWith(
                                        fontSize:
                                            Dimensions.fontSizeExtraLarge)),
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeDefault),

                              CustomTextField(
                                titleText: ResponsiveHelper.isDesktop(context)
                                    ? 'phone'.tr
                                    : 'enter_phone_number'.tr,
                                hintText: '',
                                controller: _phoneController,
                                focusNode: _phoneFocus,
                                nextFocus: _passwordFocus,
                                inputType: TextInputType.phone,
                                isPhone: true,
                                showTitle: ResponsiveHelper.isDesktop(context),
                                onCountryChanged: (CountryCode countryCode) {
                                  _countryDialCode = countryCode.dialCode;
                                },
                                countryDialCode: _countryDialCode ??
                                    Get.find<LocalizationController>()
                                        .locale
                                        .countryCode,
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
                                buttonText: 'Send Otp'.tr,
                                onPressed: () => _generteOtp(
                                    authController, _countryDialCode!),
                                isLoading: authController.isLoading,
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
                                              child: Text('sign_up / Login'.tr,
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

  void _generteOtp(
      AuthController authController, String countryDialCode) async {
    String phone = _phoneController.text.trim();
    String numberWithCountryCode = countryDialCode + phone;
    PhoneValid phoneValid =
        await CustomValidator.isPhoneValid(numberWithCountryCode);
    numberWithCountryCode = phoneValid.phone;

    if (phone.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (!phoneValid.isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else {
      authController.generateOtp(numberWithCountryCode).then((status) async {
        authController.saveUserNumberSharedPref(phone, countryDialCode);
        Get.toNamed(RouteHelper.getOtpVerifyRoute());
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP Send')));
      });
    }
  }
}
