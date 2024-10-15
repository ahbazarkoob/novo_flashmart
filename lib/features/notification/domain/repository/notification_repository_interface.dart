import 'package:novo_instamart/interfaces/repository_interface.dart';

abstract class NotificationRepositoryInterface extends RepositoryInterface {
  void saveSeenNotificationCount(int count);
  int? getSeenNotificationCount();
}
