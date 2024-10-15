import 'package:novo_instamart/api/api_client.dart';
import 'package:novo_instamart/features/auth/domain/models/delivery_man_body.dart';
import 'package:novo_instamart/interfaces/repository_interface.dart';

abstract class DeliverymanRegistrationRepositoryInterface
    extends RepositoryInterface {
  @override
  Future getList(
      {int? offset, int? zoneId, bool isZone = true, bool isVehicle = false});
  Future<bool> registerDeliveryMan(
      DeliveryManBody deliveryManBody, List<MultipartBody> multiParts);
}
