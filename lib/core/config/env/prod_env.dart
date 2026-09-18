import 'package:pmcsms/core/config/env/base_env.dart';

class ProdEnv implements BaseEnv {
  factory ProdEnv() => _instance;
  ProdEnv._internal();
  static final ProdEnv _instance = ProdEnv._internal();

  @override
  String get baseUrl => 'https://pmcsms.com';
}
