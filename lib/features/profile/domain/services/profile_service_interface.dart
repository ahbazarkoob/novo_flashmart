import 'package:image_picker/image_picker.dart';
import 'package:novo_instamart/common/models/response_model.dart';
import 'package:novo_instamart/features/profile/domain/models/userinfo_model.dart';

abstract class ProfileServiceInterface {
  Future<UserInfoModel?> getUserInfo();
  Future<ResponseModel> updateProfile(
      UserInfoModel userInfoModel, XFile? data, String token);
  Future<ResponseModel> changePassword(UserInfoModel userInfoModel);
  Future<ResponseModel> deleteUser();
}
