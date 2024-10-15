import 'package:novo_instamart/interfaces/repository_interface.dart';

abstract class CampaignRepositoryInterface implements RepositoryInterface {
  @override
  Future getList(
      {int? offset, bool isBasicCampaign = false, bool isItemCampaign = false});
}
