import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unb/common/widgets/base_screen_layout.dart';
import 'package:unb/modules/auth/signup/signup_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _signupController = Modular.get<SignupController>();
  var _pwdVisible = false;
  var _email = '';
  var _password = '';

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16.0),
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
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      splashRadius: 20,
                      onPressed: () {
                        setState(() {
                          _pwdVisible = !_pwdVisible;
                        });
                      },
                      icon:
                          Icon(_pwdVisible ? Icons.remove_red_eye : Icons.lock),
                    ),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !_pwdVisible,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'password is required';
                    }

                    if (value.length < 8) {
                      return 'password must be at least 8 characters';
                    }

                    if (value.length > 256) {
                      return 'password must be at most 256 characters';
                    }

                    final containsUpperCase = value.contains(RegExp(r'[A-Z]'));

                    if (!containsUpperCase) {
                      return 'password must contain at least one uppercase letter';
                    }

                    final containsLowerCase = value.contains(RegExp(r'[A-Z]'));

                    if (!containsLowerCase) {
                      return 'password must contain at least one lowercase letter';
                    }

                    final containsNumber = value.contains(RegExp(r'[0-9]'));

                    if (!containsNumber) {
                      return 'password must contain at least one number';
                    }

                    final containsSpecialCharacter = value.contains(
                        RegExp(r'''[\^$*.[\]{}()?"!@#%&/\\,><':;|_~`=+\- ]'''));

                    if (!containsSpecialCharacter) {
                      return 'password must contain at least one special character';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final valid = await _signupController.signUpUser(
                        _email,
                        _password,
                      );
                      if (valid) {
                        Modular.to.pushReplacementNamed(
                            '/auth/signup/confirm-code?username=$_email');
                      }
                    }
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        Modular.to.pushNamed('/auth/');
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
