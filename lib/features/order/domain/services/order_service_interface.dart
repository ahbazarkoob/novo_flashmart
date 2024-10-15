import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:novo_instamart/features/order/domain/models/order_cancellation_body.dart';
import 'package:novo_instamart/features/order/domain/models/order_details_model.dart';
import 'package:novo_instamart/features/order/domain/models/order_model.dart';

abstract class OrderServiceInterface {
  Future<PaginatedOrderModel?> getRunningOrderList(int offset);
  Future<PaginatedOrderModel?> getHistoryOrderList(int offset);
  Future<List<OrderDetailsModel>?> getOrderDetails(String orderID);
  Future<List<CancellationData>?> getCancelReasons();
  Future<List<String?>?> getRefundReasons();
  Future<void> submitRefundRequest(
      int selectedReasonIndex,
      List<String?>? refundReasons,
      String note,
      String? orderId,
      XFile? refundImage);
  Future<Response> trackOrder(String? orderID, {String? contactNumber});
  Future<bool> cancelOrder(String orderID, String? reason);
  OrderModel? prepareOrderModel(
      PaginatedOrderModel? runningOrderModel, int? orderID);
  Future<bool> switchToCOD(String? orderID);
  void paymentRedirect(
      {required String url,
      required bool canRedirect,
      required String? contactNumber,
      required Function onClose,
      required final String? addFundUrl,
      required final String orderID});
}
