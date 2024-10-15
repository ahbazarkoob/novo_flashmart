import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novo_instamart/common/models/response_model.dart';
import 'package:novo_instamart/features/auth/domain/reposotories/auth_repository_interface.dart';
import 'package:novo_instamart/features/auth/domain/services/auth_service_interface.dart';

class AuthService implements AuthServiceInterface {
  final AuthRepositoryInterface authRepositoryInterface;
  AuthService({required this.authRepositoryInterface});

  @override
  bool isSharedPrefNotificationActive() {
    return authRepositoryInterface.isSharedPrefNotificationActive();
  }

  @override
  Future<RegisterModel> registeration(
      {String? phone, int? otp, String? name, String? gender}) async {
    try {
      Response response = await authRepositoryInterface.registeration(
          phone: phone, otp: otp, name: name, gender: gender);
      if (response.statusCode == 200) {
        final body = response.body;
        RegisterModel registerModel = RegisterModel.fromJson(body);
        debugPrint('Token:::   ${registerModel.token}');
        authRepositoryInterface.saveUserToken("${registerModel.token}");
        return registerModel;
      } else {
        throw Exception('Failed to register user: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error while registering user: $e');
      rethrow;
    }
  }

  @override
  Future<LoginRegisterModel> loginRegistration(
      {String? phone, int? otp}) async {
    try {
      Response response = await authRepositoryInterface.loginRegistration(
          phone: phone, otp: otp);
      if (response.statusCode == 200) {
        final body = response.body;
        LoginRegisterModel loginRegisterModel =
            LoginRegisterModel.fromJson(body);
        debugPrint('Token:::   ${loginRegisterModel.token}');
        debugPrint('Success:::   ${loginRegisterModel.success}');
        authRepositoryInterface.saveUserToken("${loginRegisterModel.token}");
        debugPrint("Tokennn${authRepositoryInterface.getUserToken()}");
        return loginRegisterModel;
      } else {
        throw Exception('Failed to login user: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error while logging in: $e');
      rethrow;
    }
  }

  // @override
  // Future<ResponseModel> registration(
  //     SignUpBodyModel signUpBody, bool isCustomerVerificationOn) async {
  //   ResponseModel responseModel =
  //       await authRepositoryInterface.registration(signUpBody);
  //   if (responseModel.isSuccess) {
  //     if (!isCustomerVerificationOn) {
  //       authRepositoryInterface.saveUserToken(responseModel.message!);
  //       await authRepositoryInterface.updateToken();
  //       authRepositoryInterface.clearSharedPrefGuestId();
  //     }
  //   }
  //   return responseModel;
  // }

  @override
  Future<OtpResponseModel> generateOtp({String? phone}) async {
    try {
      String fcm = authRepositoryInterface.getSavedDeviceToken() ?? '';
      print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
      print(fcm);
      Response response =
          await authRepositoryInterface.generateOtp(phone: phone, fcm: fcm);
      if (response.statusCode == 200) {
        final decodedResponse = response.body;
        OtpResponseModel otpResponseModel =
            OtpResponseModel.fromJson(decodedResponse);
        debugPrint('OTP:::   ${otpResponseModel.otp}');
        debugPrint('OTP:::   ${otpResponseModel.registeredUser}');
        return otpResponseModel;
      } else {
        throw Exception('Failed to generate OTP: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error generating OTP: $e');
      rethrow;
    }
  }

  @override
  Future<OtpResponseModel> verifyOtp({String? phone, String? otp}) async {
    final OtpResponseModel otpResponseModel;
    Response response =
        await authRepositoryInterface.verifyOtp(phone: phone, otp: otp);
    final decodedResponse = jsonDecode(response.body);
    otpResponseModel = OtpResponseModel.fromJson(decodedResponse);
    return otpResponseModel;
  }

  // @override
  // Future<ResponseModel> login(
  //     {String? phone,
  //     String? password,
  //     required bool isCustomerVerificationOn}) async {
  //   Response response =
  //       await authRepositoryInterface.login(phone: phone, password: password);
  //   ResponseModel responseModel;
  //   if (response.statusCode == 200) {
  //     if (isCustomerVerificationOn && response.body['is_phone_verified'] == 0) {
  //     } else {
  //       authRepositoryInterface.saveUserToken(response.body['token']);
  //       await authRepositoryInterface.updateToken();
  //       authRepositoryInterface.clearSharedPrefGuestId();
  //     }
  //     responseModel = ResponseModel(true,
  //         '${response.body['is_phone_verified']}${response.body['token']}',
  //         isPhoneVerified: response.body['is_phone_verified'] == 1);
  //   } else {
  //     responseModel = ResponseModel(false, response.statusText,
  //         isPhoneVerified: response.body['is_phone_verified'] == 1);
  //   }
  //   return responseModel;
  // }

  // @override
  // Future<ResponseModel> guestLogin() async {
  //   return await authRepositoryInterface.guestLogin();
  // }

  // @override
  // Future<bool> loginWithSocialMedia(SocialLogInBody socialLogInBody,
  //     int timeout, bool isCustomerVerificationOn) async {
  //   bool canNavigateToLocation = false;
  //   Response response = await authRepositoryInterface.loginWithSocialMedia(
  //       socialLogInBody, timeout);
  //   if (response.statusCode == 200) {
  //     String? token = response.body['token'];
  //     if (token != null && token.isNotEmpty) {
  //       if (isCustomerVerificationOn &&
  //           response.body['is_phone_verified'] == 0) {
  //         Get.toNamed(RouteHelper.getVerificationRoute(
  //             response.body['phone'] ?? socialLogInBody.email,
  //             token,
  //             RouteHelper.signUp,
  //             ''));
  //       } else {
  //         authRepositoryInterface.saveUserToken(response.body['token']);
  //         await authRepositoryInterface.updateToken();
  //         authRepositoryInterface.clearSharedPrefGuestId();
  //         canNavigateToLocation = true;
  //       }
  //     } else {
  //       Get.toNamed(RouteHelper.getForgotPassRoute(true, socialLogInBody));
  //     }
  //   } else if (response.statusCode == 403 &&
  //       response.body['errors'][0]['code'] == 'email') {
  //     Get.toNamed(RouteHelper.getForgotPassRoute(true, socialLogInBody));
  //   } else {
  //     showCustomSnackBar(response.statusText);
  //   }
  //   return canNavigateToLocation;
  // }

  // @override
  // Future<bool> registerWithSocialMedia(
  //     SocialLogInBody socialLogInBody, bool isCustomerVerificationOn) async {
  //   bool canNavigateToLocation = false;
  //   Response response =
  //       await authRepositoryInterface.registerWithSocialMedia(socialLogInBody);
  //   if (response.statusCode == 200) {
  //     String? token = response.body['token'];
  //     if (isCustomerVerificationOn && response.body['is_phone_verified'] == 0) {
  //       Get.toNamed(RouteHelper.getVerificationRoute(
  //           socialLogInBody.phone, token, RouteHelper.signUp, ''));
  //     } else {
  //       authRepositoryInterface.saveUserToken(response.body['token']);
  //       await authRepositoryInterface.updateToken();
  //       authRepositoryInterface.clearSharedPrefGuestId();
  //       canNavigateToLocation = true;
  //     }
  //   } else {
  //     showCustomSnackBar(response.statusText);
  //   }
  //   return canNavigateToLocation;
  // }

  @override
  Future<void> updateToken() async {
    await authRepositoryInterface.updateToken();
  }

  @override
  bool isLoggedIn() {
    return authRepositoryInterface.isLoggedIn();
  }

  // @override
  // bool isGuestLoggedIn() {
  //   return authRepositoryInterface.isGuestLoggedIn();
  // }

  // @override
  // String getSharedPrefGuestId() {
  //   return authRepositoryInterface.getSharedPrefGuestId();
  // }

  @override
  bool clearSharedData() {
    return authRepositoryInterface.clearSharedData();
  }

  @override
  Future<bool> clearSharedAddress() async {
    return await authRepositoryInterface.clearSharedAddress();
  }

  @override
  Future<void> saveUserOtp(int otp) async {
    await authRepositoryInterface.saveUserOtp(otp);
  }

  @override
  Future<void> saveUserNumber(String number, String countryCode) async {
    await authRepositoryInterface.saveUserNumber(number, countryCode);
  }

  @override
  Future<void> saveUserNumberAndPassword(
      String number, String password, String countryCode) async {
    await authRepositoryInterface.saveUserNumberAndPassword(
        number, password, countryCode);
  }

  @override
  String getUserCountryCode() {
    return authRepositoryInterface.getUserCountryCode();
  }

  @override
  String getUserNumber() {
    debugPrint("auth_service.dart");
    debugPrint(authRepositoryInterface.getUserNumber());
    return authRepositoryInterface.getUserNumber();
  }

  @override
  int getUserOtp() {
    return authRepositoryInterface.getUserOtp();
  }

  @override
  String getUserPassword() {
    return authRepositoryInterface.getUserPassword();
  }

  @override
  Future<bool> clearUserNumberAndPassword() async {
    return await authRepositoryInterface.clearUserNumberAndPassword();
  }

  @override
  String getUserToken() {
    return authRepositoryInterface.getUserToken();
  }

  @override
  Future updateZone() async {
    await authRepositoryInterface.updateZone();
  }

  // @override
  // Future<bool> saveGuestContactNumber(String number) async {
  //   return authRepositoryInterface.saveGuestContactNumber(number);
  // }

  // @override
  // String getGuestContactNumber() {
  //   return authRepositoryInterface.getGuestContactNumber();
  // }

  ///Todo:
  @override
  Future<bool> saveDmTipIndex(String index) async {
    return await authRepositoryInterface.saveDmTipIndex(index);
  }

  @override
  String getDmTipIndex() {
    return authRepositoryInterface.getDmTipIndex();
  }

  @override
  Future<bool> saveEarningPoint(String point) async {
    return await authRepositoryInterface.saveEarningPoint(point);
  }

  @override
  String getEarningPint() {
    return authRepositoryInterface.getEarningPint();
  }

  @override
  void setNotificationActive(bool isActive) {
    authRepositoryInterface.setNotificationActive(isActive);
  }

  @override
  OtpResponseModel otpResponseModel = OtpResponseModel();

  @override
  LoginRegisterModel loginRegisterModel = LoginRegisterModel();

  @override
  RegisterModel registerModel = RegisterModel();
}
