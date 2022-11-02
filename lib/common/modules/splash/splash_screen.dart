import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:unb/common/cubits/auth/auth_cubit.dart';
import 'package:unb/common/widgets/base_screen_layout.dart';
import 'package:unb/common/widgets/loading_indicator.dart';

class SplashScreen extends StatelessWidget {
  final Logger logger = Modular.get();

  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case AuthLoaded:
              Future.delayed(
                const Duration(seconds: 2),
                () => Modular.to.pushReplacementNamed(
                  (state as AuthLoaded).user.username == ''
                      ? '/auth/'
                      : '/home/',
                ),
              );
              break;
            case AuthError:
              Future.delayed(
                const Duration(seconds: 2),
                () => {
                  logger.e(
                    '[SplashScreen] AuthFailed: ${(state as AuthError).message}',
                  ),
                  Modular.to.pushReplacementNamed('/auth/')
                },
              );
          }
          return const LoadingIndicator();
        },
      ),
    );
  }
}
