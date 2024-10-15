import 'package:novo_instamart/features/home/domain/models/cashback_model.dart';
import 'package:novo_instamart/interfaces/repository_interface.dart';

abstract class HomeRepositoryInterface<T> implements RepositoryInterface {
  Future<CashBackModel?> getCashBackData(double amount);
}
