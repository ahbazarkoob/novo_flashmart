import 'package:novo_flashMart/interfaces/repository_interface.dart';
import 'package:novo_flashMart/util/html_type.dart';

abstract class HtmlRepositoryInterface extends RepositoryInterface {
  Future<dynamic> getHtmlText(HtmlType htmlType);
}
