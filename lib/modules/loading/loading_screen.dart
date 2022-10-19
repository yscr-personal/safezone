import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unb/common/bloc/auth/auth_bloc.dart';
import 'package:unb/common/storage/user_preferences.dart';
import 'package:unb/common/widgets/base_screen_layout.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final UserPreferences userPreferences = Modular.get();
  final AuthBloc authBloc = Modular.get();

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoaded) {
            Modular.to.pushReplacementNamed(
              state.user.id == '' ? '/auth/' : '/home/',
            );
          }
          return const Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
          ));
        },
      ),
    );
  }
}
