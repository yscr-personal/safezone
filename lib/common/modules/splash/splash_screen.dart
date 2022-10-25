import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:unb/common/bloc/auth/auth_bloc.dart';
import 'package:unb/common/storage/user_preferences.dart';
import 'package:unb/common/widgets/base_screen_layout.dart';
import 'package:unb/common/widgets/loading_indicator.dart';

class SplashScreen extends StatelessWidget {
  final UserPreferences userPreferences = Modular.get();
  final AuthBloc authBloc = Modular.get();
  final Logger logger = Modular.get();

  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case AuthLoaded:
              Future.delayed(
                const Duration(seconds: 2),
                () => Modular.to.pushReplacementNamed(
                  (state as AuthLoaded).user.id == '' ? '/auth/' : '/home/',
                ),
              );
              break;
            case AuthFailed:
              Future.delayed(
                const Duration(seconds: 2),
                () => {
                  logger.e(
                    '[SplashScreen] AuthFailed: ${(state as AuthFailed).message}',
                  ),
                  Modular.to.pushReplacementNamed('/auth/')
                },
              );
              break;
          }
          return const LoadingIndicator();
        },
      ),
    );
  }
}
