import 'package:get/get.dart';
import 'package:novo_flashMart/util/html_type.dart';

abstract class HtmlServiceInterface {
  Future<Response> getHtmlText(HtmlType htmlType);
}
