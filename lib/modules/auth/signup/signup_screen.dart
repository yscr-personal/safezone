import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unb/common/widgets/base_screen_layout.dart';
import 'package:unb/modules/auth/signup/signup_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  final _signupController = Modular.get<SignupController>();

  var _pwdVisible = false;
  var _email = '';
  var _password = '';
  var _username = '';
  var _name = '';
  XFile? _image;

  Future pickImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    if (image == null) return;
    setState(() => _image = XFile(image.path));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      overflowTop: true,
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
                CircleAvatar(
                  radius: 70,
                  backgroundImage: _image == null
                      ? const AssetImage('assets/images/safezone-logo.png')
                          as ImageProvider
                      : FileImage(File(_image!.path)),
                  child: IconButton(
                    onPressed: () => pickImage(),
                    icon: const Icon(
                      Icons.add_a_photo,
                      color: Colors.white,
                    ),
                  ),
                ),
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
                    _username = value ?? '';
                  },
                  decoration: const InputDecoration(
                    hintText: 'Username',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.person),
                  ),
                  keyboardType: TextInputType.name,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  onSaved: (final value) {
                    _name = value ?? '';
                  },
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.person),
                  ),
                  keyboardType: TextInputType.name,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid name';
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
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && _image != null) {
                      _formKey.currentState!.save();
                      final valid = await _signupController.signUpUser(
                        _email,
                        _password,
                        _username,
                        _name,
                        base64Encode(await _image!.readAsBytes()),
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
