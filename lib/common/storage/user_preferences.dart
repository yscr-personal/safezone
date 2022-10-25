import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:unb/common/models/user_model.dart';

class UserPreferences {
  Future<void> saveToken(final UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", user.id);
  }

  Future<String?> get token async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }
}
