import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:unb/common/models/user_model.dart';

class UserPreferences {
  final SharedPreferences _sharedPreferences;

  const UserPreferences(this._sharedPreferences);

  Future<void> saveToken(final UserModel user) async {
    await _sharedPreferences.setString("token", user.id);
  }

  String? get token => _sharedPreferences.getString("token");

  Future<void> deleteToken() async {
    await _sharedPreferences.remove("token");
  }
}
