import 'package:get/get_connect/http/src/response/response.dart';
import 'package:novo_flashMart/interfaces/repository_interface.dart';

abstract class AuthRepositoryInterface extends RepositoryInterface {
  bool isSharedPrefNotificationActive();
  // Future<ResponseModel> registration(SignUpBodyModel signUpBody);
  Future<Response> loginRegistration({String? phone, int? otp});
  Future<Response> registeration({String? phone, int? otp,  String? name, String? gender});
  Future<Response> generateOtp({String? phone,String fcm
  });
  Future<Response> verifyOtp({String? phone, String? otp});
  // Future<Response> login({String? phone, String? password});
  Future<bool> saveUserToken(String token);
  Future<Response> updateToken({String notificationDeviceToken = ''});
  // Future<bool> saveSharedPrefGuestId(String id);
  // String getSharedPrefGuestId();
  // Future<bool> clearSharedPrefGuestId();
  // bool isGuestLoggedIn();
  bool clearSharedData();
  // Future<ResponseModel> guestLogin();
  // Future<Response> loginWithSocialMedia(
  //     SocialLogInBody socialLogInBody, int timeout);
  // Future<Response> registerWithSocialMedia(SocialLogInBody socialLogInBody);
  bool isLoggedIn();
  Future<bool> clearSharedAddress();
  Future<void> saveUserNumber(String number, String countryCode);
  Future<void> saveUserOtp(int otp);
  Future<void> saveUserNumberAndPassword(
      String number, String password, String countryCode);
  String getUserCountryCode();
  String getUserNumber();
  int getUserOtp();
  String getUserPassword();
  Future<bool> clearUserNumberAndPassword();
  String getUserToken();
  Future<Response> updateZone();
  // Future<bool> saveGuestContactNumber(String number);
  // String getGuestContactNumber();

  ///Todo:
  Future<bool> saveDmTipIndex(String index);
  String getDmTipIndex();
  Future<bool> saveEarningPoint(String point);
  String getEarningPint();
  void setNotificationActive(bool isActive);
  String? getSavedDeviceToken();
}
