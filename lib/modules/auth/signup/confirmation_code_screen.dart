import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unb/common/widgets/base_screen_layout.dart';
import 'package:unb/modules/auth/signup/signup_controller.dart';

class ConfirmationCodeScreen extends StatefulWidget {
  final String? email;

  const ConfirmationCodeScreen({super.key, this.email});

  @override
  State<ConfirmationCodeScreen> createState() => _ConfirmationCodeScreenState();
}

class _ConfirmationCodeScreenState extends State<ConfirmationCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _controller = Modular.get<SignupController>();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance
        .addPostFrameCallback((_) => _showConfirmationCodeSent(context));
  }

  Future<void> _showConfirmationCodeSent(final BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation code sent to your email'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Please check your email and enter the confirmation code'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Confirmation code',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid code';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final valid = await _controller.confirmUser(
                      widget.email!,
                      _codeController.text,
                    );
                    if (valid) {
                      Modular.to.pushReplacementNamed('/auth/');
                    }
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
