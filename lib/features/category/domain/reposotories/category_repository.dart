import 'package:get/get.dart';
import 'package:novo_flashMart/features/category/domain/models/category_model.dart';
import 'package:novo_flashMart/features/item/domain/models/item_model.dart';
import 'package:novo_flashMart/features/store/domain/models/store_model.dart';
import 'package:novo_flashMart/features/language/controllers/language_controller.dart';
import 'package:novo_flashMart/api/api_client.dart';
import 'package:novo_flashMart/util/app_constants.dart';
import 'package:novo_flashMart/features/category/domain/reposotories/category_repository_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryRepository implements CategoryRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  CategoryRepository({required this.apiClient,required this.sharedPreferences});

    @override
  bool? showFirstTime() {
    return sharedPreferences.getBool(AppConstants.firstTime);
  }
  @override
  void disableFirstTime() {
    sharedPreferences.setBool(AppConstants.firstTime, false);
  }

  @override
  Future getList(
      {int? offset,
      bool categoryList = false,
      bool subCategoryList = false,
      bool categoryItemList = false,
      bool categoryStoreList = false,
      bool? allCategory,
      String? id,
      String? type}) async {
    if (categoryList) {
      return await _getCategoryList(allCategory!);
    } else if (subCategoryList) {
      return await _getSubCategoryList(id);
    } else if (categoryItemList) {
      return await _getCategoryItemList(id, offset!, type!);
    } else if (categoryStoreList) {
      return await _getCategoryStoreList(id, offset!, type!);
    }
  }

  Future<List<CategoryModel>?> _getCategoryList(bool allCategory) async {
    List<CategoryModel>? categoryList;
    Response response = await apiClient.getData(AppConstants.categoryUri,
        headers: allCategory
            ? {
                'Content-Type': 'application/json; charset=UTF-8',
                AppConstants.localizationKey:
                    Get.find<LocalizationController>().locale.languageCode
              }
            : null);
    if (response.statusCode == 200) {
      categoryList = [];
      response.body.forEach((category) {
        categoryList!.add(CategoryModel.fromJson(category));
      });
    }
    return categoryList;
  }

  Future<List<CategoryModel>?> _getSubCategoryList(String? parentID) async {
    List<CategoryModel>? subCategoryList;
    Response response =
        await apiClient.getData('${AppConstants.subCategoryUri}$parentID');
    if (response.statusCode == 200) {
      subCategoryList = [];
      response.body.forEach(
          (category) => subCategoryList!.add(CategoryModel.fromJson(category)));
    }
    return subCategoryList;
  }

  Future<ItemModel?> _getCategoryItemList(
      String? categoryID, int offset, String type) async {
    ItemModel? categoryItem;
    Response response = await apiClient.getData(
        '${AppConstants.categoryItemUri}$categoryID?limit=10&offset=$offset&type=$type');
    if (response.statusCode == 200) {
      categoryItem = ItemModel.fromJson(response.body);
    }
    return categoryItem;
  }

  Future<StoreModel?> _getCategoryStoreList(
      String? categoryID, int offset, String type) async {
    StoreModel? categoryStore;
    Response response = await apiClient.getData(
        '${AppConstants.categoryStoreUri}$categoryID?limit=10&offset=$offset&type=$type');
    if (response.statusCode == 200) {
      categoryStore = StoreModel.fromJson(response.body);
    }
    return categoryStore;
  }

  @override
  Future<Response> getSearchData(
      String? query, String? categoryID, bool isStore, String type) async {
    return await apiClient.getData(
      '${AppConstants.searchUri}${isStore ? 'stores' : 'items'}/search?name=$query&category_id=$categoryID&type=$type&offset=1&limit=50',
    );
  }

  @override
  Future<bool> saveUserInterests(List<int?> interests) async {
    Response response = await apiClient
        .postData(AppConstants.interestUri, {"interest": interests});
    return (response.statusCode == 200);
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
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }
}
