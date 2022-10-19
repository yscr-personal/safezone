import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextFormField(
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
      ],
    );
  }
}
