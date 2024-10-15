import 'package:get/get.dart';
import 'package:novo_instamart/features/category/domain/models/category_model.dart';
import 'package:novo_instamart/features/item/domain/models/item_model.dart';
import 'package:novo_instamart/features/store/domain/models/store_model.dart';

abstract class CategoryServiceInterface {
  bool? showFirstTime();
  void disableFirstTime();
  Future<List<CategoryModel>?> getCategoryList(bool allCategory);
  Future<List<CategoryModel>?> getSubCategoryList(String? parentID);
  Future<ItemModel?> getCategoryItemList(
      String? categoryID, int offset, String type);
  Future<StoreModel?> getCategoryStoreList(
      String? categoryID, int offset, String type);
  Future<Response> getSearchData(
      String? query, String? categoryID, bool isStore, String type);
  Future<bool> saveUserInterests(List<int?> interests);
}
