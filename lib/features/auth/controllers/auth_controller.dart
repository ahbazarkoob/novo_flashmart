import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:novo_instamart/common/models/response_model.dart';
import 'package:novo_instamart/features/splash/controllers/splash_controller.dart';
import 'package:novo_instamart/features/auth/domain/services/auth_service_interface.dart';

import '../../profile/controllers/profile_controller.dart';

class AuthController extends GetxController implements GetxService {
  final AuthServiceInterface authServiceInterface;
  AuthController({required this.authServiceInterface}) {
    _notification = authServiceInterface.isSharedPrefNotificationActive();
  }

  late String _recievedOtp;
  String get recievedOtp => _recievedOtp;

  late bool _loginSuccess;
  bool get loginSuccess => _loginSuccess;

  bool _notification = true;
  bool get notification => _notification;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // bool _guestLoading = false;
  // bool get guestLoading => _guestLoading;

  bool _acceptTerms = true;
  bool get acceptTerms => _acceptTerms;

  bool _isActiveRememberMe = false;
  bool get isActiveRememberMe => _isActiveRememberMe;

  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    update();
  }

  void toggleTerms() {
    _acceptTerms = !_acceptTerms;
    update();
  }

  Future<LoginRegisterModel> loginRegisteration(String? phone, int? otp) async {
    _isLoading = true;
    update();
    authServiceInterface.loginRegisterModel =
        await authServiceInterface.loginRegistration(phone: phone, otp: otp);
    _loginSuccess = authServiceInterface.loginRegisterModel.success!;
    _isLoading = false;
    update();
    return authServiceInterface.loginRegisterModel;
  }

  Future<RegisterModel> registeration(
      String? phone, int? otp, String? name, String? gender) async {
    _isLoading = true;
    update();
    authServiceInterface.registerModel = await authServiceInterface
        .registeration(phone: phone, otp: otp, name: name, gender: gender);
    Get.find<ProfileController>().getUserInfo();
    _isLoading = false;
    update();
    return authServiceInterface.registerModel;
  }

  // Future<ResponseModel> registration(SignUpBodyModel signUpBody) async {
  //   _isLoading = true;
  //   update();
  //   ResponseModel responseModel = await authServiceInterface.registration(
  //       signUpBody,
  //       Get.find<SplashController>().configModel!.customerVerification!);
  //   if (responseModel.isSuccess &&
  //       !Get.find<SplashController>().configModel!.customerVerification!) {
  //     Get.find<ProfileController>().getUserInfo();
  //   }
  //   _isLoading = false;
  //   update();
  //   return responseModel;
  // }

  Future<OtpResponseModel> generateOtp(String? phone) async {
    _isLoading = true;
    update();
    authServiceInterface.otpResponseModel =
        await authServiceInterface.generateOtp(phone: phone);
    _recievedOtp = "${authServiceInterface.otpResponseModel.otp!}";
    _loginSuccess = authServiceInterface.otpResponseModel.registeredUser!;
    debugPrint("${authServiceInterface.otpResponseModel.otp}");
    _isLoading = false;
    update();
    return authServiceInterface.otpResponseModel;
  }

  Future<OtpResponseModel> verifyOtp(String? phone, String? otp) async {
    _isLoading = true;
    update();
    OtpResponseModel otpResponseModel = await authServiceInterface.verifyOtp();
    Get.find<ProfileController>().getUserInfo();
    _isLoading = false;
    update();
    return otpResponseModel;
  }

  // Future<ResponseModel> login(String? phone, String password) async {
  //   _isLoading = true;
  //   update();
  //   ResponseModel responseModel = await authServiceInterface.login(
  //       phone: phone,
  //       password: password,
  //       isCustomerVerificationOn:
  //           Get.find<SplashController>().configModel!.customerVerification!);
  //   if (responseModel.isSuccess &&
  //       !Get.find<SplashController>().configModel!.customerVerification! &&
  //       responseModel.isPhoneVerified!) {
  //     Get.find<ProfileController>().getUserInfo();
  //   }
  //   _isLoading = false;
  //   update();
  //   return responseModel;
  // }

  // Future<ResponseModel> guestLogin() async {
  //   _guestLoading = true;
  //   update();
  //   ResponseModel responseModel = await authServiceInterface.guestLogin();
  //   _guestLoading = false;
  //   update();
  //   return responseModel;
  // }

  // Future<void> loginWithSocialMedia(SocialLogInBody socialLogInBody) async {
  //   _isLoading = true;
  //   update();
  //   bool canNavigateToLocation =
  //       await authServiceInterface.loginWithSocialMedia(socialLogInBody, 60,
  //           Get.find<SplashController>().configModel!.customerVerification!);
  //   if (canNavigateToLocation) {
  //     Get.find<LocationController>().navigateToLocationScreen('sign-in');
  //   }
  //   _isLoading = false;
  //   update();
  // }

  // Future<void> registerWithSocialMedia(SocialLogInBody socialLogInBody) async {
  //   _isLoading = true;
  //   update();
  //   bool canNavigateToLocationScreen =
  //       await authServiceInterface.registerWithSocialMedia(socialLogInBody,
  //           Get.find<SplashController>().configModel!.customerVerification!);
  //   if (canNavigateToLocationScreen) {
  //     Get.find<LocationController>().navigateToLocationScreen('sign-in');
  //   }
  //   _isLoading = false;
  //   update();
  // }

  Future<void> updateToken() async {
    await authServiceInterface.updateToken();
  }

  bool isLoggedIn() {
    return authServiceInterface.isLoggedIn();
  }

  // bool isGuestLoggedIn() {
  //   return authServiceInterface.isGuestLoggedIn();
  // }

  // String getGuestId() {
  //   return authServiceInterface.getSharedPrefGuestId();
  // }

  bool clearSharedData() {
    Get.find<SplashController>().setModule(null);
    return authServiceInterface.clearSharedData();
  }

  Future<void> socialLogout() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    googleSignIn.disconnect();
    await FacebookAuth.instance.logOut();
  }

  Future<bool> clearSharedAddress() async {
    return await authServiceInterface.clearSharedAddress();
  }

  Future<void> saveUserOtpSharedPref(int otp) async {
    await authServiceInterface.saveUserOtp(otp);
  }

  Future<void> saveUserNumberSharedPref(
      String number, String countryCode) async {
    await authServiceInterface.saveUserNumber(number, countryCode);
  }

  Future<void> saveUserNumberAndPasswordSharedPref(
      String number, String password, String countryCode) async {
    await authServiceInterface.saveUserNumberAndPassword(
        number, password, countryCode);
  }

  int getUserOtp() {
    return authServiceInterface.getUserOtp();
  }

  String getUserNumber() {
    return authServiceInterface.getUserNumber();
  }

  String getUserCountryCode() {
    return authServiceInterface.getUserCountryCode();
  }

  String getUserPassword() {
    return authServiceInterface.getUserPassword();
  }

  Future<bool> clearUserNumberAndPassword() async {
    return authServiceInterface.clearUserNumberAndPassword();
  }

  String getUserToken() {
    return authServiceInterface.getUserToken();
  }

  Future<void> updateZone() async {
    await authServiceInterface.updateZone();
  }

  // Future<void> saveGuestNumber(String number) async {
  //   await authServiceInterface.saveGuestContactNumber(number);
  // }

  // String getGuestNumber() {
  //   return authServiceInterface.getGuestContactNumber();
  // }

  ///TODO: need to move these in required controller..
  Future<void> saveDmTipIndex(String i) async {
    await authServiceInterface.saveDmTipIndex(i);
  }

  String getDmTipIndex() {
    return authServiceInterface.getDmTipIndex();
  }

  void saveEarningPoint(String point) {
    authServiceInterface.saveEarningPoint(point);
  }

  String getEarningPint() {
    return authServiceInterface.getEarningPint();
  }

  bool setNotificationActive(bool isActive) {
    _notification = isActive;
    authServiceInterface.setNotificationActive(isActive);
    update();
    return _notification;
  }
}
