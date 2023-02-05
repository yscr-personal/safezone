import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:unb/common/storage/constants.dart';

class UserPreferences {
  Future<void> saveToken(final String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LocalStorageKeys.TOKEN, token);
  }

  Future<String?> get token async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(LocalStorageKeys.TOKEN);
  }

  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(LocalStorageKeys.TOKEN);
  }
}
