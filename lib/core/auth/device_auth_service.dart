import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deviceAuthProvider = Provider<DeviceAuthService>((ref) {
  throw UnimplementedError('Initialize this in main.dart first');
});

class DeviceAuthService {
  final SharedPreferences _prefs;
  static const _userIdKey = 'device_user_id';

  DeviceAuthService(this._prefs);

  String get userId {
    String? id = _prefs.getString(_userIdKey);
    if (id == null) {
      id = const Uuid().v4();
      _prefs.setString(_userIdKey, id);
    }
    return id;
  }
}
