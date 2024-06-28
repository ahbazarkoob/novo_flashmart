import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:novo_flashMart/interfaces/repository_interface.dart';

abstract class OrderRepositoryInterface extends RepositoryInterface {
  @override
  Future get(String? id);
  @override
  Future getList(
      {int? offset,
      bool isRunningOrder = false,
      bool isHistoryOrder = false,
      bool isCancelReasons = false,
      bool isRefundReasons = false});
  Future<Response> submitRefundRequest(Map<String, String> body, XFile? data);
  Future<Response> trackOrder(String? orderID,
      {String? contactNumber});
  Future<bool> cancelOrder(String orderID, String? reason);
  Future<Response> switchToCOD(String? orderID);
}
