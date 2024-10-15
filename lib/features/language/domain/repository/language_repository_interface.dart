import 'package:flutter/material.dart';
import 'package:novo_instamart/features/address/domain/models/address_model.dart';
import 'package:novo_instamart/interfaces/repository_interface.dart';

abstract class LanguageRepositoryInterface extends RepositoryInterface {
  AddressModel? getAddressFormSharedPref();
  void updateHeader(AddressModel? addressModel, Locale locale, int? moduleId);
  Locale getLocaleFromSharedPref();
  void saveLanguage(Locale locale);
}
