import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unb/amplifyconfiguration.dart';
import 'package:unb/common/cubits/auth/auth_cubit.dart';
import 'package:unb/common/models/amplify/ModelProvider.dart';
import 'package:unb/main_module.dart';
import 'package:unb/main_widget.dart';

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  await _configureAmplify();

  final authCubit = AuthCubit();

  return runApp(
    ModularApp(
      module: AppModule(authCubit: authCubit),
      child: BlocProvider.value(
        value: authCubit..tryToLoadUserFromStorage(),
        child: const AppWidget(),
      ),
    ),
  );
}
