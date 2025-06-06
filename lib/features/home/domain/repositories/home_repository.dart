import 'package:get/get_connect/http/src/response/response.dart';
import 'package:novo_flashMart/api/api_client.dart';
import 'package:novo_flashMart/features/home/domain/models/cashback_model.dart';
import 'package:novo_flashMart/util/app_constants.dart';
import 'home_repository_interface.dart';

class HomeRepository implements HomeRepositoryInterface {
  final ApiClient apiClient;
  HomeRepository({required this.apiClient});

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(String? id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset}) async {
    List<CashBackModel>? cashBackModelList;
    Response response =
        await apiClient.getData(AppConstants.cashBackOfferListUri);
    if (response.statusCode == 200) {
      cashBackModelList = [];
      response.body.forEach((data) {
        cashBackModelList!.add(CashBackModel.fromJson(data));
      });
    }
    return cashBackModelList;
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<CashBackModel?> getCashBackData(double amount) async {
    //double cashbackAmount = 0;
    CashBackModel? cashBackModel;
    Response response = await apiClient
        .getData('${AppConstants.getCashBackAmountUri}?amount=$amount');
    if (response.statusCode == 200) {
      //cashbackAmount = response.body['cashback_amount'] != null ? double.parse(response.body['cashback_amount'].toString()) : 0;
      cashBackModel = CashBackModel.fromJson(response.body);
    }
    return cashBackModel;
  }
}
