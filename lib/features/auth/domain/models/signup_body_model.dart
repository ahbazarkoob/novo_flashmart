class SignUpBodyModel {
  String? name;
  String? phone;
  int? otp;
  String? gender;

  SignUpBodyModel({this.name, this.phone, this.gender, this.otp});

  SignUpBodyModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    otp = json['otp'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone'] = phone;
    data['otp'] = otp;
    data['gender'] = gender;
    return data;
  }
}


class LoginBodyModel {
  String? phone;
  int? otp;

  LoginBodyModel({this.phone,this.otp});

  LoginBodyModel.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone'] = phone;
    data['otp'] = otp;
    return data;
  }
}