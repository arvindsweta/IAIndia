import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // Singleton pattern
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  // Initialize FlutterSecureStorage with v10.0.0 options
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      // v10 feature: migrates old data to the new encryption automatically
      migrateOnAlgorithmChange: true,
      // Uses the new RSA-OAEP + AES-GCM standard
      encryptedSharedPreferences: true,
    ),
  );

  static const _keyUserId = 'user_id';
  static const _keyComanyname = 'Comanyname';
  static const _keyUserName= 'UserName';
  static const _keyIslogin = '_keyIslogin';
  static const _keyIsloginType = '_keyIsloginType';
  static const pageheight = 'pageheight';
  static const pagewidth = 'pagewidth';
  static const FCMTOKEN = 'fcmtoken';
  static const DEVICE_ID = 'deviceId';
  static const DEVICE_OS = 'deviceOS';




  //  Add Notification

  Future<void> writeFCMToken(String fcmToken) async {
    await _storage.write(key: FCMTOKEN, value: fcmToken);
  }
  Future<void> writeDeviceId(String deviceId) async {
    await _storage.write(key: DEVICE_ID, value: deviceId);
  }
  Future<void> writeDeviceOS(String deviceOS) async {
    await _storage.write(key: DEVICE_OS, value: deviceOS);
  }



  /// Save the User ID
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _keyUserId, value: userId);
  }

  Future<void> writeCompany(String companyId) async {
    await _storage.write(key: _keyComanyname, value: companyId);
  }
  Future<void> writeUsername(String userName) async {
    await _storage.write(key: _keyUserName, value: userName);
  }
  Future<void> writeUserLogin(String isLogin) async {
    await _storage.write(key: _keyIslogin, value: isLogin);
  }


  Future<void> writeUserLoginType(String isLoginType) async {
    await _storage.write(key: _keyIsloginType, value: isLoginType);
  }

  Future<void> writeScreenHeight({required height}) async {
    await _storage.write(key: pageheight, value: height);
  }
  Future<void> writeScreenWidth({required width}) async {
    await _storage.write(key: pagewidth, value: width);
  }



  /// Get the User ID (returns null if not found)
  Future<String?> getUserId() async {
    return await _storage.read(key: _keyUserId);
  }
  Future<String?> getCompany() async {
    return await _storage.read(key: _keyComanyname);
  }
  Future<String?> getUsername() async {
    return await _storage.read(key: _keyUserName);
  }
  Future<String?> getIsLogin() async {
    return await _storage.read(key: _keyIslogin);
  }
  Future<double?> getScreenHeight() async {
    String? value = await _storage.read(key: pageheight);
    return value != null ? double.tryParse(value) : null;
  }

  Future<double?> getScreenWidth() async {
    String? value = await _storage.read(key: pagewidth);
    return value != null ? double.tryParse(value) : null;
  }
  Future<String?> getIsLoginType() async {
    return await _storage.read(key: _keyIsloginType);
  }
  Future<String?> getFCMToken() async {
    return await _storage.read(key: FCMTOKEN);
  }









  /// Delete the User ID (useful for Logout)
  Future<void> logout() async {
    await _storage.delete(key: _keyUserId);
    await _storage.delete(key: _keyUserName);
    await _storage.delete(key: _keyIslogin);
    await _storage.delete(key: _keyIsloginType);
    // Or clear everything: await _storage.deleteAll();
  }
}