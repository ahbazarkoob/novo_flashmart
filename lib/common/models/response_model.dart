class ResponseModel {
  final bool _isSuccess;
  final String? _message;
  final bool? isPhoneVerified;
  List<int>? zoneIds;
  ResponseModel(this._isSuccess, this._message,
      {this.isPhoneVerified = false, this.zoneIds});

  String? get message => _message;
  bool get isSuccess => _isSuccess;
}

class OtpResponseModel {
  int? otp;
  bool? registeredUser;

  OtpResponseModel({this.otp, this.registeredUser});

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpResponseModel(
      otp: json["otp"] as int,
      registeredUser: json["registered_user"] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['otp'] = otp;
    data['registered_user'] = registeredUser;
    return data;
  }
}

class RegisterModel {
  String? token;
  int? isPhoneVerified;
  String? phoneVerifyEndUrl;

  RegisterModel(
      {this.token, this.isPhoneVerified, this.phoneVerifyEndUrl});

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
        token: json['token'] as String,
        isPhoneVerified: json['is_phone_verified'] as int,
        phoneVerifyEndUrl: json['phone_verify_end_url'] as String,);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['is_phone_verified'] = isPhoneVerified;
    data['phone_verify_end_url'] = phoneVerifyEndUrl;
    return data;
  }
}

class LoginRegisterModel {
  bool? success;
  String? token;

  LoginRegisterModel({this.success, this.token});

  factory LoginRegisterModel.fromJson(Map<String, dynamic> json) {
    return LoginRegisterModel(success: json['success'] as bool, token: json['token'] as String);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['token'] = token;
    return data;
  }
}
