import 'package:novo_instamart/features/chat/domain/models/conversation_model.dart';

class UserInfoModel {
  int? id;
  String? name;
  String? gender;
  String? image;
  String? phone;
  String? createdAt;
  String? password;
  int? orderCount;
  int? memberSinceDays;
  double? walletBalance;
  int? loyaltyPoint;
  String? refCode;
  String? socialId;
  User? userInfo;
  bool? isValidForDiscount;
  double? discountAmount;
  String? discountAmountType;
  String? validity;
  List<int>? selectedModuleForInterest;

  UserInfoModel({
    this.id,
    this.name,
    this.gender,
    this.image,
    this.phone,
    this.createdAt,
    this.password,
    this.orderCount,
    this.memberSinceDays,
    this.walletBalance,
    this.loyaltyPoint,
    this.refCode,
    this.socialId,
    this.userInfo,
    this.isValidForDiscount,
    this.discountAmount,
    this.discountAmountType,
    this.validity,
    this.selectedModuleForInterest,
  });

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    gender = json['gender'];
    image = json['image'];
    phone = json['phone'];
    createdAt = json['created_at'];
    password = json['password'];
    orderCount = json['order_count'];
    memberSinceDays = json['member_since_days'];
    walletBalance = json['wallet_balance'].toDouble();
    loyaltyPoint = json['loyalty_point'];
    refCode = json['ref_code'];
    socialId = json['social_id'];
    userInfo =
        json['userinfo'] != null ? User.fromJson(json['userinfo']) : null;
    isValidForDiscount = json['is_valid_for_discount'] ?? false;
    discountAmount = json['discount_amount']?.toDouble();
    discountAmountType = json['discount_amount_type'];
    validity = json['validity'];
    if (json['selected_modules_for_interest'] != null) {
      selectedModuleForInterest = [];
      json['selected_modules_for_interest'].forEach((value) {
        if (value != null && value != 'null') {
          selectedModuleForInterest!.add(int.parse(value.toString()));
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['gender'] = gender;
    data['image'] = image;
    data['phone'] = phone;
    data['created_at'] = createdAt;
    data['password'] = password;
    data['order_count'] = orderCount;
    data['member_since_days'] = memberSinceDays;
    data['wallet_balance'] = walletBalance;
    data['loyalty_point'] = loyaltyPoint;
    data['ref_code'] = refCode;
    if (userInfo != null) {
      data['user`info'] = userInfo!.toJson();
    }
    data['is_valid_for_discount'] = isValidForDiscount;
    data['discount_amount'] = discountAmount;
    data['discount_amount_type'] = discountAmountType;
    data['validity'] = validity;
    data['selected_modules_for_interest'] = selectedModuleForInterest;
    return data;
  }
}
