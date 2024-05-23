import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_info.dart';
import 'constant.dart';

abstract class CacheHelper {
  Future<bool> put({
    required String key,
    required String value,
  });

  Future<bool> clear({required String key});

  String? getString({required String key});

  UserInfo? getUserCredentials();
}

@LazySingleton(as: CacheHelper)
class CacheHelperImpl implements CacheHelper {
  final SharedPreferences _sharedPreferences;

  CacheHelperImpl(this._sharedPreferences);

  @override
  Future<bool> clear({required String key}) async {
    final bool f = await _basicErrorHandling(() async {
      return _sharedPreferences.remove(key);
    });
    return f;
  }

  @override
  Future<bool> put({required String key, required String value}) async {
    final isSucceed = await _sharedPreferences.setString(key, value);
    return isSucceed;
  }

  @override
  String? getString({required String key}) {
    final value = _sharedPreferences.getString(key);
    return value;
  }

  @override
  UserInfo? getUserCredentials() {
    final value = _sharedPreferences.getString(Constant.userInfo);
    if (value != null) {
      return UserInfo.fromJson(jsonDecode(value));
    } else {
      return null;
    }
  }

}

extension on CacheHelper {
  Future<T> _basicErrorHandling<T>(Future<T> Function() onSuccess) async {
    try {
      final f = await onSuccess();
      return f;
    } catch (e) {
      rethrow;
    }
  }
}
