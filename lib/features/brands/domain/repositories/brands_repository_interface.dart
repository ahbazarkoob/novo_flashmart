import 'package:novo_instamart/features/item/domain/models/item_model.dart';
import 'package:novo_instamart/interfaces/repository_interface.dart';

abstract class BrandsRepositoryInterface extends RepositoryInterface {
  Future<ItemModel?> getBrandItemList({required int brandId, int? offset});
}
