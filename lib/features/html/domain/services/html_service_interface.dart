import 'package:get/get.dart';
import 'package:novo_instamart/util/html_type.dart';

abstract class HtmlServiceInterface {
  Future<Response> getHtmlText(HtmlType htmlType);
}
