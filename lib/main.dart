import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:unb/amplifyconfiguration.dart';
import 'package:unb/app_module.dart';
import 'package:unb/app_widget.dart';
import 'package:unb/common/environment_config.dart';
import 'package:unb/common/models/amplify/ModelProvider.dart';

Future<void> _configureAmplify() async {
  try {
    final dataStorePlugin =
        AmplifyDataStore(modelProvider: ModelProvider.instance);
    final apiPlugin = AmplifyAPI();
    final authCognitoPlugin = AmplifyAuthCognito();
    await Amplify.addPlugins([dataStorePlugin, apiPlugin, authCognitoPlugin]);
    await Amplify.configure(amplifyconfig);
  } catch (e) {
    safePrint('An error occurred while configuring Amplify: $e');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  await _configureAmplify();

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://12e65a9fce4246f79e6a369842b3e78d@o4504154891485184.ingest.sentry.io/4504154892664832';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
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
