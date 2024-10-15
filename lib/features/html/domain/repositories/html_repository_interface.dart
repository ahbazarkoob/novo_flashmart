import 'package:novo_instamart/interfaces/repository_interface.dart';
import 'package:novo_instamart/util/html_type.dart';

abstract class HtmlRepositoryInterface extends RepositoryInterface {
  Future<dynamic> getHtmlText(HtmlType htmlType);
}
