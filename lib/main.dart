import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unb/common/bloc/auth/auth_bloc.dart';
import 'package:unb/common/storage/user_preferences.dart';
import 'package:unb/main_module.dart';
import 'package:unb/main_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  final sharedPreferences = await SharedPreferences.getInstance();
  final userPreferences = UserPreferences(sharedPreferences);
  final authBloc = AuthBloc(userPreferences);

  return runApp(
    ModularApp(
      module: AppModule(
        userPreferences: userPreferences,
        sharedPreferences: sharedPreferences,
        authBloc: authBloc,
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => authBloc..add(LoadUserTokenEvent())),
        ],
        child: const AppWidget(),
      ),
    ),
  );
}
