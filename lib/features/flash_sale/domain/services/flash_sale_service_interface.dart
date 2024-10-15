import 'package:novo_instamart/features/flash_sale/domain/models/flash_sale_model.dart';
import 'package:novo_instamart/features/flash_sale/domain/models/product_flash_sale.dart';

abstract class FlashSaleServiceInterface {
  Future<FlashSaleModel?> getFlashSale();
  Future<ProductFlashSale?> getFlashSaleWithId(int id, int offset);
}
