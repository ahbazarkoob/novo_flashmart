import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:novo_flashMart/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:novo_flashMart/features/address/domain/models/address_model.dart';
import 'package:novo_flashMart/features/auth/domain/reposotories/auth_repository_interface.dart';
import 'package:novo_flashMart/helper/address_helper.dart';
import 'package:novo_flashMart/helper/module_helper.dart';
import 'package:novo_flashMart/util/app_constants.dart';

class AuthRepository implements AuthRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepository({required this.sharedPreferences, required this.apiClient});

  @override
  bool isSharedPrefNotificationActive() {
    return sharedPreferences.getBool(AppConstants.notification) ?? true;
  }

  @override
  Future<Response> loginRegistration({String? phone, int? otp}) async {
    Response response = await apiClient.postData(
      AppConstants.loginRegister,
      {'phone': phone, 'otp': otp},
      handleError: false,
    );
    return response;
  }

  @override
  Future<Response> registeration(
      {String? phone, int? otp, String? name, String? gender}) async {
    Response response = await apiClient.postData(
      AppConstants.loginRegister,
      {
        'phone': phone,
        'otp': otp,
        'name': name,
        'gender': gender,
      },
      handleError: false,
    );
    return response;
  }

  // @override
  // Future<ResponseModel> registration(SignUpBodyModel signUpBody) async {
  //   Response response = await apiClient.postData(
  //       AppConstants.registerUri, signUpBody.toJson(),
  //       handleError: false);
  //   if (response.statusCode == 200) {
  //     return ResponseModel(true, response.body["token"]);
  //   } else {
  //     return ResponseModel(false, response.statusText);
  //   }
  // }

  @override
  Future<Response> generateOtp({String? phone, String? fcm}) async {
    Response response = await apiClient.postData(
      AppConstants.generateOtpUri,
      {'phone': phone, 'token': fcm},
      handleError: false,
    );

    return response;
  }

  @override
  Future<Response> verifyOtp({String? phone, String? otp}) async {
    Response response = await apiClient
        .postData(AppConstants.generateOtpUri, {"phone": phone, "otp": otp});
    debugPrint(response.body);
    return response;
  }

  // @override
  // Future<Response> login({String? phone, String? password}) async {
  //   String guestId = getSharedPrefGuestId();
  //   Map<String, String> data = {
  //     "phone": phone!,
  //     "password": password!,
  //   };
  //   if (guestId.isNotEmpty) {
  //     data.addAll({"guest_id": guestId});
  //   }
  //   return await apiClient.postData(AppConstants.loginUri, data,
  //       handleError: false);
  // }

  // @override
  // Future<ResponseModel> guestLogin() async {
  //   ResponseModel responseModel;
  //   String? deviceToken = await _saveDeviceToken();
  //   Response response = await apiClient
  //       .postData(AppConstants.guestLoginUri, {'fcm_token': deviceToken});
  //   if (response.statusCode == 200) {
  //     await saveSharedPrefGuestId(response.body['guest_id'].toString());
  //     responseModel = ResponseModel(true, '${response.body['guest_id']}');
  //   } else {
  //     responseModel = ResponseModel(false, response.statusText);
  //   }
  //   return responseModel;
  // }

  // @override
  // Future<Response> loginWithSocialMedia(
  //     SocialLogInBody socialLogInBody, int timeout) async {
  //   return await apiClient.postData(
  //       AppConstants.socialLoginUri, socialLogInBody.toJson(),
  //       timeout: timeout);
  // }

  // @override
  // Future<Response> registerWithSocialMedia(
  //     SocialLogInBody socialLogInBody) async {
  //   return await apiClient.postData(
  //       AppConstants.socialRegisterUri, socialLogInBody.toJson());
  // }

  @override
  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    if (sharedPreferences.getString(AppConstants.userAddress) != null) {
      AddressModel? addressModel = AddressModel.fromJson(
          jsonDecode(sharedPreferences.getString(AppConstants.userAddress)!));
      apiClient.updateHeader(
        token,
        addressModel.zoneIds,
        addressModel.areaIds,
        sharedPreferences.getString(AppConstants.languageCode),
        ModuleHelper.getModule()?.id,
        addressModel.latitude,
        addressModel.longitude,
      );
    } else {
      apiClient.updateHeader(
          token,
          null,
          null,
          sharedPreferences.getString(AppConstants.languageCode),
          ModuleHelper.getModule()?.id,
          null,
          null);
    }
    debugPrint("Auth Repo Token : $token");
    return await sharedPreferences.setString(AppConstants.token, token);
  }

  @override
  Future<Response> updateToken({String notificationDeviceToken = ''}) async {
    String? deviceToken;
    if (notificationDeviceToken.isEmpty) {
      if (GetPlatform.isIOS && !GetPlatform.isWeb) {
        FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
        NotificationSettings settings =
            await FirebaseMessaging.instance.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          deviceToken = await _saveDeviceToken();
        }
      } else {
        deviceToken = await _saveDeviceToken();
      }
      if (!GetPlatform.isWeb) {
        FirebaseMessaging.instance.subscribeToTopic(AppConstants.topic);
      }
    }
    return await apiClient.postData(
        AppConstants.tokenUri,
        {
          "_method": "put",
          "cm_firebase_token": notificationDeviceToken.isNotEmpty
              ? notificationDeviceToken
              : deviceToken
        },
        handleError: false);
  }

  Future<String?> _saveDeviceToken() async {
    String? deviceToken = '@';
    if (!GetPlatform.isWeb) {
      try {
        deviceToken = (await FirebaseMessaging.instance.getToken())!;
      } catch (_) {}
    }
    if (deviceToken != null) {
      // if (kDebugMode) {
      print('--------Device Token---------- $deviceToken');
      await sharedPreferences.setString(AppConstants.fcmToken, deviceToken);
      // }
    }
    return deviceToken;
  }

  @override
  String? getSavedDeviceToken() {
    return sharedPreferences.getString(AppConstants.fcmToken);
  }

  @override
  bool isLoggedIn() {
    debugPrint("Shared Prefs print ${AppConstants.token}");
    debugPrint("${sharedPreferences.containsKey(AppConstants.token)}");
    return sharedPreferences.containsKey(AppConstants.token);
  }

  // @override
  // Future<bool> saveSharedPrefGuestId(String id) async {
  //   return await sharedPreferences.setString(AppConstants.guestId, id);
  // }

  // @override
  // String getSharedPrefGuestId() {
  //   return sharedPreferences.getString(AppConstants.guestId) ?? "";
  // }

  // @override
  // Future<bool> clearSharedPrefGuestId() async {
  //   return await sharedPreferences.remove(AppConstants.guestId);
  // }

  // @override
  // bool isGuestLoggedIn() {
  //   return sharedPreferences.containsKey(AppConstants.guestId);
  // }

  @override
  Future<bool> clearSharedAddress() async {
    await sharedPreferences.remove(AppConstants.userAddress);
    return true;
  }

  @override
  bool clearSharedData() {
    if (!GetPlatform.isWeb) {
      FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.topic);
      apiClient.postData(
          AppConstants.tokenUri, {"_method": "put", "cm_firebase_token": '@'},
          handleError: false);
    }
    sharedPreferences.remove(AppConstants.token);
    // sharedPreferences.remove(AppConstants.guestId);
    sharedPreferences.setStringList(AppConstants.cartList, []);
    sharedPreferences.remove(AppConstants.userAddress);
    apiClient.token = null;
    apiClient.updateHeader(null, null, null, null, null, null, null);
    return true;
  }

  @override
  Future<void> saveUserNumber(String number, String countryCode) async {
    try {
      await sharedPreferences.setString(AppConstants.userNumber, number);
      await sharedPreferences.setString(
          AppConstants.userCountryCode, countryCode);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveUserOtp(int otp) async {
    try {
      await sharedPreferences.setInt(AppConstants.userOtp, otp);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveUserNumberAndPassword(
      String number, String password, String countryCode) async {
    try {
      await sharedPreferences.setString(AppConstants.userPassword, password);
      await sharedPreferences.setString(AppConstants.userNumber, number);
      await sharedPreferences.setString(
          AppConstants.userCountryCode, countryCode);
    } catch (e) {
      rethrow;
    }
  }

  @override
  int getUserOtp() {
    return sharedPreferences.getInt(AppConstants.userOtp) ?? 0;
  }

  @override
  String getUserNumber() {
    return sharedPreferences.getString(AppConstants.userNumber) ?? "";
  }

  @override
  String getUserCountryCode() {
    return sharedPreferences.getString(AppConstants.userCountryCode) ?? "";
  }

  @override
  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.userPassword) ?? "";
  }

  @override
  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.userPassword);
    await sharedPreferences.remove(AppConstants.userCountryCode);
    return await sharedPreferences.remove(AppConstants.userNumber);
  }

  @override
  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  @override
  Future<Response> updateZone() async {
    return await apiClient.getData(AppConstants.updateZoneUri);
  }

  // @override
  // Future<bool> saveGuestContactNumber(String number) async {
  //   return await sharedPreferences.setString(AppConstants.guestNumber, number);
  // }

  // @override
  // String getGuestContactNumber() {
  //   return sharedPreferences.getString(AppConstants.guestNumber) ?? "";
  // }

  ///Todo:
  @override
  Future<bool> saveDmTipIndex(String index) async {
    return await sharedPreferences.setString(AppConstants.dmTipIndex, index);
  }

  @override
  String getDmTipIndex() {
    return sharedPreferences.getString(AppConstants.dmTipIndex) ?? "";
  }

  @override
  Future<bool> saveEarningPoint(String point) async {
    return await sharedPreferences.setString(AppConstants.earnPoint, point);
  }

  @override
  String getEarningPint() {
    return sharedPreferences.getString(AppConstants.earnPoint) ?? "";
  }

  @override
  void setNotificationActive(bool isActive) {
    if (isActive) {
      updateToken();
    } else {
      if (!GetPlatform.isWeb) {
        updateToken(notificationDeviceToken: '@');
        FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.topic);
        if (isLoggedIn()) {
          FirebaseMessaging.instance.unsubscribeFromTopic(
              'zone_${AddressHelper.getUserAddressFromSharedPref()!.zoneId}_customer');
        }
      }
    }
    sharedPreferences.setBool(AppConstants.notification, isActive);
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(String? id) {
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset}) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }
}
