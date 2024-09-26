import 'package:novo_flashMart/common/models/response_model.dart';

abstract class AuthServiceInterface {
  bool isSharedPrefNotificationActive();
  OtpResponseModel otpResponseModel = OtpResponseModel();
  LoginRegisterModel loginRegisterModel = LoginRegisterModel();
  RegisterModel registerModel = RegisterModel();
  // Future<ResponseModel> registration(
  //     SignUpBodyModel signUpBody, bool isCustomerVerificationOn);
  Future<LoginRegisterModel> loginRegistration({String? phone, int? otp});
  Future<RegisterModel> registeration(
      {String? phone, int? otp, String? name, String? gender});
  Future<OtpResponseModel> generateOtp({String? phone});
  Future<OtpResponseModel> verifyOtp({String? phone, String? otp});
  // Future<ResponseModel> login(
  //     {String? phone,
  //     String? password,
  //     required bool isCustomerVerificationOn});
  // Future<ResponseModel> guestLogin();
  // Future<bool> loginWithSocialMedia(SocialLogInBody socialLogInBody,
      // int timeout, bool isCustomerVerificationOn);
  // Future<bool> registerWithSocialMedia(
  //     SocialLogInBody socialLogInBody, bool isCustomerVerificationOn);
  Future<void> updateToken();
  bool isLoggedIn();
  // bool isGuestLoggedIn();
  // String getSharedPrefGuestId();
  bool clearSharedData();
  Future<bool> clearSharedAddress();
  Future<void> saveUserOtp(int otp);
  Future<void> saveUserNumber(String number, String countryCode);
  Future<void> saveUserNumberAndPassword(
      String number, String password, String countryCode);
  int getUserOtp();
  String getUserNumber();
  String getUserCountryCode();
  String getUserPassword();
  Future<bool> clearUserNumberAndPassword();
  String getUserToken();
  Future updateZone();
  // Future<bool> saveGuestContactNumber(String number);
  // String getGuestContactNumber();
  Future<bool> saveDmTipIndex(String index);
  String getDmTipIndex();
  Future<bool> saveEarningPoint(String point);
  String getEarningPint();
  void setNotificationActive(bool isActive);
}
