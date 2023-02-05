import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:unb/app_module.dart';
import 'package:unb/app_widget.dart';
import 'package:unb/common/environment_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  await SentryFlutter.init(
    (options) {
      options.dsn = EnvironmentConfig.SENTRY_DSN;
      options.tracesSampleRate = 1.0;
      options.enableAutoSessionTracking = true;
      options.environment = EnvironmentConfig.ENV;
    },
    appRunner: () => runApp(
      ModularApp(
        module: AppModule(),
        child: const AppWidget(),
      ),
    ),
  );
}
