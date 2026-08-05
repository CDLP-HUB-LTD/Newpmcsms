import 'package:pmcsms/core/config/env/base_env.dart';

class DevEnv implements BaseEnv {
  factory DevEnv() => _instance;
  DevEnv._internal();
  static final DevEnv _instance = DevEnv._internal();

  @override
  // If your dev team uses a different staging link, swap it here. Otherwise use production:
  String get baseUrl => 'https://demo.autobiz.app';
}
