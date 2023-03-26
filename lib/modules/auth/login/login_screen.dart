import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unb/common/cubits/auth/auth_cubit.dart';
import 'package:unb/common/widgets/base_screen_layout.dart';
import 'package:unb/common/widgets/loading_indicator.dart';
import 'package:unb/modules/auth/login/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = Modular.get<LoginController>();
  final _authCubit = Modular.get<AuthCubit>();
  var _email = '';
  var _password = '';

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      overflowTop: true,
      child: BlocProvider.value(
        value: _authCubit,
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const LoadingIndicator();
            }
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage('assets/images/safezone-logo.png'),
                        width: 200,
                        semanticLabel: 'Safe Zone',
                      ),
                      TextFormField(
                        onSaved: (final value) {
                          _email = value ?? '';
                        },
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        onSaved: (final value) {
                          _password = value ?? '';
                        },
                        decoration: const InputDecoration(
                          hintText: 'Password',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.lock),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'password is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            final valid = await _loginController.signInUser(
                              _email,
                              _password,
                            );
                            if (valid) {
                              Modular.to.pushReplacementNamed('/home/');
                            }
                          }
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Not registered yet?'),
                          TextButton(
                            onPressed: () {
                              Modular.to.pushNamed('/auth/signup/');
                            },
                            child: const Text('Create an account'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
