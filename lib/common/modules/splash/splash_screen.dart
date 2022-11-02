import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:unb/common/cubits/auth/auth_cubit.dart';
import 'package:unb/common/widgets/base_screen_layout.dart';
import 'package:unb/common/widgets/loading_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _logger = Modular.get<Logger>();
  final _authCubit = Modular.get<AuthCubit>();

  @override
  void initState() {
    super.initState();
    _authCubit.tryToLoadUserFromStorage();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      child: BlocProvider.value(
        value: _authCubit,
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
                    _logger.e(
                      '[SplashScreen] AuthFailed: ${(state as AuthError).message}',
                    ),
                    Modular.to.pushReplacementNamed('/auth/')
                  },
                );
            }
            return const LoadingIndicator();
          },
        ),
      ),
    );
  }
}
