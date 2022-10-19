import 'package:unb/common/environment_config.dart';

class AppUrls {
  static const String login = "${EnvironmentConfig.BACKEND_URL}/session";

  static const String register =
      "${EnvironmentConfig.BACKEND_URL}/registration";
}
